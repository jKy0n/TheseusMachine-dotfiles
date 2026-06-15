local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local system_monitor = require("jkyon-widgets.status-bar.system_monitor")

-- Função para criar o widget configurável
local function cpu_monitor(args)
    args = args or {}
    local show_usage, show_freq, show_temp = false, false, false
    local sep = " "  -- Espaçamento entre itens

    -- Checa quais informações mostrar
    for _, v in ipairs(args) do
        if v == "usage" then show_usage = true end
        if v == "freq"  then show_freq  = true end
        if v == "temp"  then show_temp  = true end
    end

    local icon = '<span font="MesloLGS Nerd Font 11">  </span> '
    local widget = wibox.widget {
        markup = icon .. " Loading... ",
        widget = wibox.widget.textbox
    }

    -- Variáveis para o popup
    local popup = nil
    local last_values = {
        usage = "--",
        freq = "--",
        temp = "--"
    }

    -- Função para criar o popup (cria só se não existir)
    local function show_popup()
        if not popup then
            local mouse_coords = mouse.coords()
            popup = awful.popup {
                widget = {
                    {
                        {
                            align = "right",
                            valign = "center",
                            widget = wibox.widget.textbox,
                            id = "labelbox",
                            markup = "<b>Usage:</b>\n<b>Frequency:</b>\n<b>Temperature:</b>"
                        },
                        {
                            align = "left",
                            valign = "center",
                            widget = wibox.widget.textbox,
                            id = "valuebox",
                            markup = "",
                        },
                        layout = wibox.layout.fixed.horizontal,
                        spacing = 10
                    },
                    margins = 10,
                    widget = wibox.container.margin
                },
                shape = gears.shape.rounded_rect,
                border_width = 2,
                border_color = beautiful.border_focus,
                ontop = true,
                visible = false,
            }
            popup.x = mouse_coords.x + 10
            popup.y = mouse_coords.y + 10
        else
            local mouse_coords = mouse.coords()
            popup.x = mouse_coords.x + 10
            popup.y = mouse_coords.y + 10
        end
        popup.visible = true
    end

    local function hide_popup()
        if popup then popup.visible = false end
    end

    local function update_widget()
        local cpu = system_monitor.stats.cpu
        last_values.usage = cpu.usage and tostring(cpu.usage) or "--"
        last_values.freq = cpu.freq and tostring(cpu.freq) or "--"
        last_values.temp = cpu.temp and tostring(cpu.temp) or "--"

        local items = {}
        if show_usage and cpu.usage then table.insert(items, string.format("%3s%%", cpu.usage)) end
        if show_freq and cpu.freq then table.insert(items, string.format("%4s MHz", cpu.freq)) end
        if show_temp and cpu.temp then table.insert(items, string.format("%3s°C ", cpu.temp)) end

        local padding = " "
        widget.markup = padding .. icon .. "<span font='MesloLGS Nerd Font Bold 8'>" .. table.concat(items, sep) .. "</span>" .. padding

        if popup and popup.visible then
            local valuebox = popup.widget:get_children_by_id("valuebox")[1]
            valuebox.markup = string.format(
                " %s%%\n %s GHz\n %s°C",
                last_values.usage,
                last_values.freq,
                last_values.temp
            )
        end
    end

    system_monitor.connect_signal(update_widget)
    gears.timer.delayed_call(update_widget)

    -- Eventos de mouse para mostrar/esconder popup
    widget:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            if popup and popup.visible then
                hide_popup()
            else
                show_popup()
            end
        end
    end)
    widget:connect_signal("mouse::leave", function()
        hide_popup()
    end)

    return widget
end

return cpu_monitor