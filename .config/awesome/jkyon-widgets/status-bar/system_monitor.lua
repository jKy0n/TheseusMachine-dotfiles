--[[
--       Title:      system_monitor.lua
--       Brief:      Extração central de métricas do sistema (CPU/RAM/GPU/PSU) pra wibar do AwesomeWM
--       Path:       jkyon-widgets/status-bar/system_monitor.lua
--       Version:    3.0
--       Notes:
--
--       Arquitetura:
--       1) DESCOBERTA (roda 1x, quando o módulo é carregado no boot do Awesome):
--          resolve quais arquivos em /sys/class/hwmon/hwmonN/ correspondem a
--          k10temp, amdgpu e corsairpsu, e guarda os caminhos prontos na tabela `hw`.
--          Isso existe porque o NÚMERO do hwmonN não é fixo entre boots/updates de
--          kernel — só o `name` dentro de cada um é estável. Resolver 1x evita ter
--          que re-descobrir isso a cada tick (que seria desperdício, já que o
--          hardware não muda em runtime).
--
--       2) EXTRAÇÃO (roda em runtime, todo tick): usa só io.open() direto nos
--          caminhos já resolvidos. NENHUM subprocess é criado (sem sensors,
--          sem rocm-smi, sem ls). io.open() é uma chamada de sistema simples;
--          io.popen() faria fork()+exec(), bloqueando o loop de eventos do
--          Awesome (que é single-threaded) até o subprocess terminar.
--
--       3) DOIS TIMERS, por custo/inércia real do dado:
--          - FAST:  CPU% e RAM/swap  -> só parse de /proc, custo desprezível,
--                   dado muda rápido, vale atualizar com mais frequência.
--          - SLOW:  temps, GPU, PSU  -> têm inércia física (temperatura não
--                   pula em 1s) ou são informativos/secundários, não precisam
--                   da mesma frequência do que uso de CPU/RAM.
--
--       4) TABELA CENTRAL: `system_monitor.stats` é a única fonte de verdade.
--          Os widgets (cpu_monitor, ram_monitor, gpu_monitor, psu_monitor) só
--          leem daqui via connect_signal, nunca fazem I/O própria.
--]]

local gears = require("gears")

local system_monitor = {
    stats = {
        cpu = { usage = nil, freq = nil, temp = nil },
        ram = {
            usage_available = nil, usage = nil, total = nil, used = nil,
            free = nil, available = nil,
            swap_usage = nil, swap_total = nil, swap_used = nil, swap_free = nil,
        },
        gpu = { usage = nil, freq = nil, temp = nil },
        psu = { usage = nil, power = nil, temp = nil },
    },
}

-- ============================================================
-- Helpers de I/O de baixo nível — sempre io.open, nunca io.popen
-- ============================================================

local function read_line(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local line = file:read("l")
    file:close()
    return line
end

local function read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local data = file:read("*a")
    file:close()
    return data
end

local function read_number(path)
    if not path then return nil end
    local raw = read_line(path)
    return raw and tonumber(raw)
end

-- ============================================================
-- Descoberta de hardware — roda 1x, no load do módulo
-- ============================================================

local HWMON_SCAN_LIMIT = 32  -- limite de segurança pra varredura de hwmonN
local DRM_SCAN_LIMIT = 16    -- idem pra /sys/class/drm/cardN

-- Acha o /sys/class/hwmon/hwmonN cujo "name" bate com target_name
local function find_hwmon_by_name(target_name)
    for i = 0, HWMON_SCAN_LIMIT do
        local path = "/sys/class/hwmon/hwmon" .. i
        if read_line(path .. "/name") == target_name then
            return path
        end
    end
    return nil
end

-- Acha "<prefix>N_input" cujo "<prefix>N_label" bate com target_label.
-- Ex: find_hwmon_attr(k10temp_path, "temp", "Tctl") -> ".../temp1_input"
local function find_hwmon_attr(hwmon_path, prefix, target_label)
    if not hwmon_path then return nil end
    for i = 1, 10 do
        local label_path = hwmon_path .. "/" .. prefix .. i .. "_label"
        if read_line(label_path) == target_label then
            return hwmon_path .. "/" .. prefix .. i .. "_input"
        end
    end
    return nil
end

local function read_pci_slot(uevent_path)
    local content = read_file(uevent_path)
    return content and content:match("PCI_SLOT_NAME=(%S+)")
end

-- Acha /sys/class/drm/cardN/device cujo PCI slot bate com o do hwmon do amdgpu.
-- Necessário porque "gpu_busy_percent" só existe no sysfs do DRM, não no hwmon.
local function find_drm_device_by_hwmon(hwmon_path)
    if not hwmon_path then return nil end
    local target_slot = read_pci_slot(hwmon_path .. "/device/uevent")
    if not target_slot then return nil end
    for i = 0, DRM_SCAN_LIMIT do
        local card_path = "/sys/class/drm/card" .. i
        if read_pci_slot(card_path .. "/device/uevent") == target_slot then
            return card_path .. "/device"
        end
    end
    return nil
end

-- Resolução final: depois deste bloco, `hw` tem todos os caminhos prontos
-- e o resto do módulo nunca mais precisa procurar nada.
local hw = {}
do
    local k10temp_path  = find_hwmon_by_name("k10temp")
    local amdgpu_path   = find_hwmon_by_name("amdgpu")
    local corsair_path  = find_hwmon_by_name("corsairpsu")
    local drm_device    = find_drm_device_by_hwmon(amdgpu_path)

    hw.cpu_freq  = "/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
    hw.cpu_temp  = find_hwmon_attr(k10temp_path, "temp", "Tctl")

    hw.gpu_busy  = drm_device and (drm_device .. "/gpu_busy_percent") or nil
    hw.gpu_freq  = find_hwmon_attr(amdgpu_path, "freq", "sclk")
    hw.gpu_temp  = find_hwmon_attr(amdgpu_path, "temp", "junction")

    hw.psu_power = find_hwmon_attr(corsair_path, "power", "power total")
    hw.psu_temp  = find_hwmon_attr(corsair_path, "temp", "vrm temp")
end

-- ============================================================
-- Extração — FAST tier (CPU% e RAM/swap): puro parse de /proc
-- ============================================================

local previous_cpu = { total = 0, idle = 0 }

local function parse_cpu_usage()
    local line = read_line("/proc/stat")
    if not line then return end

    local u, n, s, i, io_, irq, softirq, steal, guest, guest_nice =
        line:match("^cpu%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
    if not u then return end

    u, n, s, i, io_, irq, softirq, steal, guest, guest_nice =
        tonumber(u), tonumber(n), tonumber(s), tonumber(i), tonumber(io_),
        tonumber(irq), tonumber(softirq), tonumber(steal), tonumber(guest), tonumber(guest_nice)

    local total = u + n + s + i + io_ + irq + softirq + steal + guest + guest_nice
    local total_delta = total - previous_cpu.total
    local idle_delta = i - previous_cpu.idle

    if previous_cpu.total > 0 and total_delta > 0 then
        system_monitor.stats.cpu.usage = math.floor(((total_delta - idle_delta) / total_delta) * 100 + 0.5)
    end

    previous_cpu.total = total
    previous_cpu.idle = i
end

local function parse_cpu_freq()
    local khz = read_number(hw.cpu_freq)
    if khz then
        system_monitor.stats.cpu.freq = khz / 1000000  -- kHz -> GHz
    end
end

local function parse_ram()
    local raw = read_file("/proc/meminfo")
    if not raw then return end

    local values = {}
    for key, value in raw:gmatch("(%w+):%s*(%d+)") do
        values[key] = tonumber(value)
    end

    local total     = values.MemTotal and values.MemTotal / 1024 / 1024 or nil
    local free      = values.MemFree and values.MemFree / 1024 / 1024 or nil
    local available = values.MemAvailable and values.MemAvailable / 1024 / 1024 or nil
    local swap_total = values.SwapTotal and values.SwapTotal / 1024 / 1024 or nil
    local swap_free  = values.SwapFree and values.SwapFree / 1024 / 1024 or nil

    local used = (total and free) and (total - free) or nil
    local swap_used = (swap_total and swap_free) and (swap_total - swap_free) or nil

    local usage = (total and used and total > 0)
        and math.floor((used / total) * 100 + 0.5) or nil
    local usage_available = (total and available and total > 0)
        and math.floor(((total - available) / total) * 100 + 0.5) or nil
    local swap_usage = (swap_total and swap_used and swap_total > 0)
        and math.floor((swap_used / swap_total) * 100 + 0.5) or nil

    local ram = system_monitor.stats.ram
    ram.total, ram.free, ram.available = total, free, available
    ram.used, ram.usage, ram.usage_available = used, usage, usage_available
    ram.swap_total, ram.swap_free = swap_total, swap_free
    ram.swap_used, ram.swap_usage = swap_used, swap_usage
end

-- ============================================================
-- Extração — SLOW tier (temps, GPU, PSU): io.open direto no hwmon
-- ============================================================

local function parse_cpu_temp()
    local milli = read_number(hw.cpu_temp)
    system_monitor.stats.cpu.temp = milli and math.floor(milli / 1000 + 0.5) or nil
end

local function parse_gpu()
    local usage = read_number(hw.gpu_busy)          -- já vem em %, sem conversão
    local freq_hz = read_number(hw.gpu_freq)
    local temp_milli = read_number(hw.gpu_temp)

    system_monitor.stats.gpu.usage = usage
    system_monitor.stats.gpu.freq = freq_hz and math.floor(freq_hz / 1000000 + 0.5) or nil  -- Hz -> MHz
    system_monitor.stats.gpu.temp = temp_milli and math.floor(temp_milli / 1000 + 0.5) or nil -- m°C -> °C
end

-- Potência nominal da PSU (Corsair HX1500i = 1500W). Ajustar aqui se trocar de fonte.
-- "Usage %" da PSU = carga real / capacidade nominal — é o mesmo cálculo usado
-- nas certificações 80+. O pwm1 do corsairpsu NÃO serve pra isso: é o duty cycle
-- do controle da fan (por isso a fonte reporta "psu fan: 0 RPM" mas pwm1 > 0 —
-- é o valor que ela mandaria pra fan, não quantos watts estão passando).
local PSU_RATED_WATTS = 1500

local function parse_psu()
    local power_micro = read_number(hw.psu_power)
    local temp_milli = read_number(hw.psu_temp)

    local power_w = power_micro and math.floor(power_micro / 1000000 + 0.5) or nil

    system_monitor.stats.psu.power = power_w
    system_monitor.stats.psu.usage = power_w and math.floor((power_w / PSU_RATED_WATTS) * 100 + 0.5) or nil
    system_monitor.stats.psu.temp = temp_milli and math.floor(temp_milli / 1000 + 0.5) or nil -- m°C -> °C
end

-- ============================================================
-- Timers e sinal
-- ============================================================

local FAST_INTERVAL = 2  -- CPU%, CPU freq, RAM/swap
local SLOW_INTERVAL = 5  -- CPU temp, GPU, PSU

local function update_fast()
    parse_cpu_usage()
    parse_cpu_freq()
    parse_ram()
    awesome.emit_signal("system_monitor::updated", system_monitor.stats)
end

local function update_slow()
    parse_cpu_temp()
    parse_gpu()
    parse_psu()
    awesome.emit_signal("system_monitor::updated", system_monitor.stats)
end

gears.timer { timeout = FAST_INTERVAL, autostart = true, call_now = true, callback = update_fast }
gears.timer { timeout = SLOW_INTERVAL, autostart = true, call_now = true, callback = update_slow }

function system_monitor.connect_signal(callback)
    if type(callback) == "function" then
        awesome.connect_signal("system_monitor::updated", callback)
    end
end

return system_monitor