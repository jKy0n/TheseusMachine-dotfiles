--[[
--       Title:      portage_update_checker.lua
--       Brief:      Widget para verificar atualizações do Portage e mostrar detalhes em um tooltip
--       Path:       /home/jkyon/.config/awesome/jkyon-widgets/portage_update_checker.lua
--       Author:     John Kennedy a.k.a. jKyon
--       Created:    2024-12-31
--       Updated:    2026-03-14
--       Notes:      Ainda não finalizado.
--]]


local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local portage_checker = wibox.widget.textbox()
local tooltip = awful.tooltip({
    bg = "#1e2030",
    border_color = beautiful.border_focus,
    border_width = 2,
    fg = "#cad3f5",
    font = "MesloLGS Nerd Font Bold 10", -- Dobre o tamanho aqui (ajuste conforme sua fonte)
    opacity = 1,
    shape = gears.shape.rounded_rect,
    text = "Verificando...",
}) -- Customizado manualmente

-- Função para mostrar/ocultar o tooltip manualmente
local tooltip_visible = false
local function toggle_tooltip()
    if tooltip_visible then
        tooltip:hide()
        tooltip:remove_from_object(portage_checker)
        tooltip_visible = false
    else
        tooltip:add_to_object(portage_checker)
        tooltip:show()
        tooltip_visible = true
    end
end

portage_checker:buttons(gears.table.join(
    awful.button({}, 1, function()
        toggle_tooltip()
    end)
))

local function update_widget()
    awful.spawn.easy_async_with_shell('LC_MESSAGES=C emerge -pvuND @world', function(stdout)
        local num_pkgs = stdout:match("Total: (%d+) packages")
        if num_pkgs and num_pkgs ~= "0" then
            portage_checker.text = "  " .. num_pkgs .. " Pkgs |"
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
    autostart = true,
    call_now = true,
    callback = update_widget,
    timeout = 3600,
}

return portage_checker