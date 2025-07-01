
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local portage_checker = wibox.widget.textbox()
local tooltip = awful.tooltip({ objects = {portage_checker}, text = "Verificando..." })

local function update_widget()
    awful.spawn.easy_async_with_shell('LC_MESSAGES=C emerge -pvuND @world', function(stdout)
        local num_pkgs = stdout:match("Total: (%d+) packages")
        if num_pkgs then
            portage_checker.text = "   " .. num_pkgs .. " Pkgs |"
        else
            portage_checker.text = ""
        end

        local updates = {}
        -- Simples, pega cada linha de atualização, ignora o resumo
        for line in stdout:gmatch("\n([^%s][^\n]*)") do
            if not line:match("^Total:") and not line:match("^\\[") then
                table.insert(updates, line)
            end
        end

        if #updates > 0 then
            tooltip.text = table.concat(updates, "\n")
        else
            tooltip.text = "Nenhuma atualização"
        end
    end)
end

-- Timer para atualizar a cada hora
local timer = gears.timer {
    timeout = 3600,
    autostart = true,
    call_now = true,
    callback = update_widget,
}

return portage_checker