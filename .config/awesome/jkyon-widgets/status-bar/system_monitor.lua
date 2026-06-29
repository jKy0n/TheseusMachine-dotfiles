local gears = require("gears")

local system_monitor = {
    stats = {
        cpu = {
            usage = nil,
            freq = nil,
            temp = nil,
        },
        ram = {
            usage_available = nil,
            usage = nil,
            total = nil,
            used = nil,
            free = nil,
            available = nil,
            swap_usage = nil,
            swap_total = nil,
            swap_used = nil,
            swap_free = nil,
        },
        gpu = {
            usage = nil,
            freq = nil,
            temp = nil,
        },
        psu = {
            usage = nil,
            power = nil,
            temp = nil,
        },
    },
}

local previous_cpu = {
    total = 0,
    idle = 0,
}

local function read_file(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end
    local data = file:read("*a")
    file:close()
    return data
end

local function read_line(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end
    local line = file:read("l")
    file:close()
    return line
end

local function file_exists(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end
    return false
end

local function read_int(path)
    local raw = read_line(path)
    return raw and tonumber(raw)
end

local function first_read_line(paths)
    for _, path in ipairs(paths) do
        local raw = read_line(path)
        if raw and raw ~= "" then
            return raw
        end
    end
    return nil
end

local function sensors_available()
    local handle = io.popen("command -v sensors 2>/dev/null")
    if not handle then
        return false
    end
    local path = handle:read("*a")
    handle:close()
    return path and path:match("%S") and true or false
end

local function read_sensors()
    local handle = io.popen("sensors -u 2>/dev/null")
    if not handle then
        return nil
    end
    local output = handle:read("*a")
    handle:close()
    if not output or output == "" then
        return nil
    end
    return output
end

local function parse_sensors_output(output)
    local sections = {}
    local current_section = nil
    local current_subsection = nil
    
    -- Patterns that identify a top-level section (hardware types)
    local hardware_patterns = {
        "%-pci%-", "%-i2c%-", "%-hid%-", "^%d+%-", "^k10temp", "^nct", "^it8", "^w83"
    }
    
    local function is_hardware_section(name)
        for _, pattern in ipairs(hardware_patterns) do
            if name:lower():match(pattern) then
                return true
            end
        end
        return false
    end

    for line in output:gmatch("[^\r\n]+") do
        line = line:gsub("%s+$", "")
        
        -- Skip empty lines and adapter lines
        if line == "" or line:match("^Adapter:") then
            goto continue
        end
        
        -- Determine indentation level
        local indent = 0
        if line:match("^%s") then
            indent = #(line:match("^%s+"))
        end
        
        -- Top-level (no indentation)
        if indent == 0 then
            -- Try to parse as header (with colon)
            local header, rest = line:match("^([^:]+):%s*(.*)$")
            if header and (rest == "" or not tonumber(rest)) then
                -- It's a header with colon and no numeric value
                if is_hardware_section(header) then
                    -- New top-level section (hardware type)
                    current_section = header
                    current_subsection = nil
                    sections[current_section] = {}
                else
                    -- It's a subsection (component name like "v_in:", "power total:")
                    if current_section and not sections[current_section][header] then
                        current_subsection = header
                        sections[current_section][current_subsection] = {}
                    end
                end
                goto continue
            else
                -- Check if it's a bare name without colon (like "corsairpsu-hid-3-9")
                if line:match("^[%w%-_]+$") then
                    current_section = line
                    current_subsection = nil
                    sections[current_section] = {}
                    goto continue
                end
            end
        elseif indent > 0 then
            -- Indented line
            local header, rest = line:match("^%s*([^:]+):%s*(.*)$")
            if header and (rest == "" or not tonumber(rest)) then
                -- Indented header = subsection
                current_subsection = header
                if current_section and not sections[current_section][current_subsection] then
                    sections[current_section][current_subsection] = {}
                end
                goto continue
            end
        end
        
        -- Parse key-value pairs
        local key, value = line:match("^%s*([%w_%+%-]+):%s*([%-]?[%d%.]+)%s*$")
        if key and value then
            if current_section then
                if current_subsection then
                    if type(sections[current_section][current_subsection]) == "table" then
                        sections[current_section][current_subsection][key] = tonumber(value)
                    end
                else
                    sections[current_section][key] = tonumber(value)
                end
            end
        end
        
        ::continue::
    end

    return sections
end

local function normalize_sensor_temp(value)
    if not value then
        return nil
    end
    if value > 1000 then
        return math.floor(value / 1000 + 0.5)
    end
    return math.floor(value + 0.5)
end

local function normalize_sensor_freq(value)
    if not value then
        return nil
    end
    if value > 1000000 then
        return math.floor(value / 1000000 + 0.5)
    elseif value > 10000 then
        return math.floor(value / 1000 + 0.5)
    end
    return math.floor(value + 0.5)
end

local function normalize_sensor_power(value)
    if not value then
        return nil
    end
    if value > 1000000 then
        return math.floor(value / 1000000 + 0.5)
    elseif value > 1000 then
        return math.floor(value / 1000 + 0.5)
    end
    return math.floor(value + 0.5)
end

local function get_sensors_data()
    if not sensors_available() then
        return nil
    end

    local output = read_sensors()
    if not output then
        return nil
    end

    return parse_sensors_output(output)
end

local function parse_cpu()
    local line = read_line("/proc/stat")
    if not line then
        return
    end

    local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
        line:match("^cpu%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
    if not user then
        return
    end

    user = tonumber(user)
    nice = tonumber(nice)
    system = tonumber(system)
    idle = tonumber(idle)
    iowait = tonumber(iowait)
    irq = tonumber(irq)
    softirq = tonumber(softirq)
    steal = tonumber(steal)
    guest = tonumber(guest)
    guest_nice = tonumber(guest_nice)

    local total = user + nice + system + idle + iowait + irq + softirq + steal + guest + guest_nice
    local idle_delta = idle - previous_cpu.idle
    local total_delta = total - previous_cpu.total

    local usage = nil
    if previous_cpu.total > 0 and total_delta > 0 then
        usage = math.floor(((total_delta - idle_delta) / total_delta) * 100 + 0.5)
    end

    previous_cpu.total = total
    previous_cpu.idle = idle

    system_monitor.stats.cpu.usage = usage
end

local function read_cpu_freq()
    local raw = read_line("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq")
    if raw then
        local freq = tonumber(raw)
        if freq then
            return math.floor(freq / 1000 + 0.5)
        end
    end

    raw = read_file("/proc/cpuinfo")
    if raw then
        local mhz = raw:match("cpu MHz%s*:%s*([%d%.]+)")
        if mhz then
            return math.floor(tonumber(mhz) + 0.5)
        end
    end

    return nil
end

local function read_cpu_temp()
    local targets = {
        "/sys/class/thermal/thermal_zone0/temp",
        "/sys/class/thermal/thermal_zone1/temp",
        "/sys/class/thermal/thermal_zone2/temp",
        "/sys/class/hwmon/hwmon0/temp1_input",
        "/sys/class/hwmon/hwmon1/temp1_input",
    }

    for i = 0, 3 do
        for j = 1, 4 do
            table.insert(targets, string.format("/sys/class/hwmon/hwmon%d/temp%d_input", i, j))
        end
    end

    local raw = first_read_line(targets)
    if not raw then
        return nil
    end

    local value = tonumber(raw)
    if not value then
        return nil
    end

    if value > 1000 then
        return math.floor(value / 1000 + 0.5)
    end
    return math.floor(value / 10 + 0.5)
end

local function parse_meminfo()
    local raw = read_file("/proc/meminfo")
    if not raw then
        return
    end

    local values = {}
    for key, value in raw:gmatch("(%w+):%s*(%d+)") do
        values[key] = tonumber(value)
    end

    local total = values.MemTotal and values.MemTotal / 1024 / 1024 or nil
    local free = values.MemFree and values.MemFree / 1024 / 1024 or nil
    local available = values.MemAvailable and values.MemAvailable / 1024 / 1024 or nil
    local buffers = values.Buffers and values.Buffers / 1024 / 1024 or 0
    local cached = values.Cached and values.Cached / 1024 / 1024 or 0
    local swap_total = values.SwapTotal and values.SwapTotal / 1024 / 1024 or nil
    local swap_free = values.SwapFree and values.SwapFree / 1024 / 1024 or nil

    local used = nil
    if total and free then
        used = total - free
    end

    local swap_used = nil
    if swap_total and swap_free then
        swap_used = swap_total - swap_free
    end

    local usage = nil
    if total and used and total > 0 then
        usage = math.floor((used / total) * 100 + 0.5)
    end

    local usage_available = nil
    if total and available and total > 0 then
        usage_available = math.floor(((total - available) / total) * 100 + 0.5)
    end

    local swap_usage = nil
    if swap_total and swap_used and swap_total > 0 then
        swap_usage = math.floor((swap_used / swap_total) * 100 + 0.5)
    end

    system_monitor.stats.ram.total = total
    system_monitor.stats.ram.used = used
    system_monitor.stats.ram.free = free
    system_monitor.stats.ram.available = available
    system_monitor.stats.ram.usage = usage
    system_monitor.stats.ram.usage_available = usage_available
    system_monitor.stats.ram.swap_total = swap_total
    system_monitor.stats.ram.swap_free = swap_free
    system_monitor.stats.ram.swap_used = swap_used
    system_monitor.stats.ram.swap_usage = swap_usage
end

local function find_sensor_value(values, patterns)
    for _, pattern in ipairs(patterns) do
        for key, value in pairs(values) do
            local key_lower = key:lower()
            if key_lower == pattern or 
               key_lower:match("^" .. pattern .. "$") or 
               key_lower:match("^" .. pattern .. "_input$") or
               key_lower:match("^" .. pattern .. "_average$") then
                return value
            end
        end
    end
    return nil
end

local function find_sensor_value_recursive(section_data, patterns)
    -- First try direct match
    local result = find_sensor_value(section_data, patterns)
    if result and type(result) ~= "table" then
        return result
    end
    
    -- Then try recursively in subsections (nested tables)
    for key, subsection in pairs(section_data) do
        if type(subsection) == "table" then
            result = find_sensor_value(subsection, patterns)
            if result and type(result) ~= "table" then
                return result
            end
        end
    end
    
    return nil
end

local function parse_gpu(sensors_data)
    local gpu = {
        usage = nil,
        freq = nil,
        temp = nil,
    }

    if file_exists("/usr/bin/nvidia-smi") or file_exists("/usr/local/bin/nvidia-smi") then
        local handle = io.popen("nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,clocks.current.graphics --format=csv,noheader,nounits 2>/dev/null")
        if handle then
            local output = handle:read("*a")
            handle:close()
            if output and #output > 0 then
                local usage, temp, freq = output:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
                gpu.usage = tonumber(usage)
                gpu.temp = tonumber(temp)
                gpu.freq = tonumber(freq)
            end
        end
    end

    local function read_gpu_sysfs()
        local candidates = {
            "/sys/class/drm/card0/device",
            "/sys/class/drm/card1/device",
            "/sys/class/drm/card2/device",
        }
        for _, base in ipairs(candidates) do
            if file_exists(base) then
                gpu.usage = gpu.usage or read_int(base .. "/gpu_busy_percent")
                gpu.freq = gpu.freq or read_int(base .. "/pp_cur_freq_mhz") or read_int(base .. "/gt_cur_freq_mhz")
                if not gpu.freq then
                    gpu.freq = read_int(base .. "/mclk_cur") or read_int(base .. "/mclk")
                end

                local temp_raw = first_read_line({
                    base .. "/hwmon/hwmon0/temp1_input",
                    base .. "/hwmon/hwmon1/temp1_input",
                    base .. "/temp1_input",
                    base .. "/temperature",
                })
                if temp_raw then
                    local temp_value = tonumber(temp_raw)
                    if temp_value then
                        if temp_value > 1000 then
                            gpu.temp = math.floor(temp_value / 1000 + 0.5)
                        else
                            gpu.temp = math.floor(temp_value / 10 + 0.5)
                        end
                    end
                end
                if gpu.usage or gpu.freq or gpu.temp then
                    return
                end
            end
        end
    end

    read_gpu_sysfs()

    if sensors_data and (not gpu.freq or not gpu.temp or not gpu.usage) then
        for section, values in pairs(sensors_data) do
            local name = section:lower()
            if name:find("gpu") or name:find("nvidia") or name:find("amdgpu") or name:find("radeon") or name:find("drm") then
                local freq_value = find_sensor_value_recursive(values, {"freq1", "freq2", "clock", "mclk"})
                if freq_value then
                    gpu.freq = gpu.freq or normalize_sensor_freq(freq_value)
                end

                local temp_value = find_sensor_value_recursive(values, {"temp1", "temp2", "edge"})
                if temp_value then
                    gpu.temp = gpu.temp or normalize_sensor_temp(temp_value)
                end

                local usage_value = find_sensor_value_recursive(values, {"util", "usage", "load", "busy", "power1_average"})
                if usage_value then
                    gpu.usage = gpu.usage or math.floor(usage_value + 0.5)
                end

                if gpu.freq and gpu.temp and gpu.usage then
                    break
                end
            end
        end

        if not (gpu.freq and gpu.temp) then
            for _, values in pairs(sensors_data) do
                local freq_value = find_sensor_value_recursive(values, {"freq1", "freq2", "clock", "mclk"})
                if freq_value then
                    gpu.freq = gpu.freq or normalize_sensor_freq(freq_value)
                end

                local temp_value = find_sensor_value_recursive(values, {"temp1", "temp2", "edge"})
                if temp_value then
                    gpu.temp = gpu.temp or normalize_sensor_temp(temp_value)
                end

                if gpu.freq and gpu.temp then
                    break
                end
            end
        end

        if not gpu.usage then
            for _, values in pairs(sensors_data) do
                local usage_value = find_sensor_value_recursive(values, {"util", "usage", "load", "busy", "power1_average"})
                if usage_value then
                    gpu.usage = math.floor(usage_value + 0.5)
                    break
                end
            end
        end
    end

    system_monitor.stats.gpu.usage = gpu.usage
    system_monitor.stats.gpu.freq = gpu.freq
    system_monitor.stats.gpu.temp = gpu.temp
end

local function parse_psu(sensors_data)
    local function find_battery_path()
        local candidates = {
            "/sys/class/power_supply/BAT0",
            "/sys/class/power_supply/BAT1",
        }
        for _, name in ipairs(candidates) do
            if file_exists(name .. "/capacity") then
                return name
            end
        end

        local handle = io.popen('ls -1 /sys/class/power_supply 2>/dev/null')
        if not handle then
            return nil
        end
        for dir in handle:lines() do
            local path = "/sys/class/power_supply/" .. dir
            if file_exists(path .. "/capacity") then
                handle:close()
                return path
            end
        end
        handle:close()
        return nil
    end

    local battery_path = find_battery_path()
    local usage, power, temp = nil, nil, nil
    if battery_path then
        usage = read_int(battery_path .. "/capacity")

        local temp_raw = read_int(battery_path .. "/temp") or read_int(battery_path .. "/temp1_input")
        if temp_raw then
            if temp_raw > 1000 then
                temp = math.floor(temp_raw / 1000 + 0.5)
            else
                temp = math.floor(temp_raw / 10 + 0.5)
            end
        end

        local power_raw = read_int(battery_path .. "/power_now")
        if power_raw then
            power = math.floor(power_raw / 1000000 + 0.5)
        else
            local current = read_int(battery_path .. "/current_now")
            local voltage = read_int(battery_path .. "/voltage_now")
            if current and voltage then
                power = math.floor(current * voltage / 1000000 + 0.5)
            end
        end
    elseif sensors_data then
        for section, values in pairs(sensors_data) do
            local name = section:lower()
            if name:find("corsair") or name:find("psu") or name:find("power") or name:find("h1500") then
                local power_value = find_sensor_value_recursive(values, {"power1"})
                if power_value then
                    power = power or normalize_sensor_power(power_value)
                end

                local temp_value = find_sensor_value_recursive(values, {"temp1", "temp2"})
                if temp_value then
                    temp = temp or normalize_sensor_temp(temp_value)
                end

                local usage_value = find_sensor_value_recursive(values, {"pwm1"})
                if usage_value then
                    usage = usage or math.min(100, math.max(0, math.floor(usage_value + 0.5)))
                end
            end
        end

        if not power or not temp or not usage then
            for section, values in pairs(sensors_data) do
                local power_value = find_sensor_value_recursive(values, {"power1"})
                if power_value then
                    power = power or normalize_sensor_power(power_value)
                end

                local temp_value = find_sensor_value_recursive(values, {"temp1", "temp2"})
                if temp_value then
                    temp = temp or normalize_sensor_temp(temp_value)
                end

                local usage_value = find_sensor_value_recursive(values, {"pwm1"})
                if usage_value then
                    usage = usage or math.min(100, math.max(0, math.floor(usage_value + 0.5)))
                end

                if power and temp and usage then
                    break
                end
            end
        end
    end

    system_monitor.stats.psu.usage = usage
    system_monitor.stats.psu.power = power
    system_monitor.stats.psu.temp = temp
end

local function update_stats()
    local sensors_data = get_sensors_data()
    parse_cpu()
    system_monitor.stats.cpu.freq = read_cpu_freq()
    system_monitor.stats.cpu.temp = read_cpu_temp()
    parse_meminfo()
    parse_gpu(sensors_data)
    parse_psu(sensors_data)
    awesome.emit_signal("system_monitor::updated", system_monitor.stats)
end

local update_timer = gears.timer {
    timeout = 1,
    autostart = true,
    callback = update_stats,
}

update_timer:start()

function system_monitor.connect_signal(callback)
    if type(callback) == "function" then
        awesome.connect_signal("system_monitor::updated", callback)
    end
end

return system_monitor
