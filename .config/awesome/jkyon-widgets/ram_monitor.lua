local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local function ram_monitor(args)
    args = args or {}
    local show_usage_available, show_usage, show_total, show_used, show_free, show_available = false, false, false, false, false, false
    local show_swap_usage, show_swap_total, show_swap_used, show_swap_free = false, false, false, false
    local sep = " "  -- Espaçamento entre itens

    -- Checa quais informações mostrar
    for _, v in ipairs(args) do
        if v == "usage_available" then show_usage_available = true end
        if v == "usage"           then show_usage           = true end
        if v == "total"           then show_total           = true end
        if v == "used"            then show_used            = true end
        if v == "free"            then show_free            = true end
        if v == "available"       then show_available       = true end
        if v == "swap_usage"      then show_swap_usage      = true end
        if v == "swap_total"      then show_swap_total      = true end
        if v == "swap_used"       then show_swap_used       = true end
        if v == "swap_free"       then show_swap_free       = true end
    end

    local icon = '<span font="MesloLGS Nerd Font 11"> </span> '
    local widget = wibox.widget {
        markup = icon .. " Loading... ",
        widget = wibox.widget.textbox
    }

    -- Variáveis para o popup
    local popup = nil
    local last_values = {
        usage_available = "--",
        usage = "--",
        available = "--",
        total = "--",
        used = "--",
        free = "--",
        swap_usage = "--",
        swap_total = "--",
        swap_used = "--",
        swap_free = "--"
    }

    -- Função para criar o popup (cria só uma vez)
    local function show_popup()
        if not popup then
            local mouse_coords = mouse.coords()
            popup = awful.popup {
                widget = {
                    {
                        {
                            {
                                align = "right",
                                valign = "center",
                                widget = wibox.widget.textbox,
                                markup = "<b>Usage Available:</b>\n<b>Usage:</b>\n<b>Available:</b>\n<b>Total:</b>\n<b>Used:</b>\n<b>Free:</b>\n\n<b>Swap Usage:</b>\n<b>Swap Total:</b>\n<b>Swap Used:</b>\n<b>Swap Free:</b>"
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
                    widget = wibox.container.background
                },
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

    -- Esconde o popup
    local function hide_popup()
        if popup then popup.visible = false end
    end

    -- Atualiza o widget periodicamente
    awful.widget.watch(
        "nice --adjustment=10 sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/RAM-monitor.sh",
        1, -- intervalo em segundos
        function(w, stdout)
            local usage_available = stdout:match("usage_available:%s*(%d+)")
            local usage           = stdout:match("\nusage:%s*(%d+)")
            local total           = stdout:match("\ntotal:%s*([%d%.]+)")
            local used            = stdout:match("\nused:%s*([%d%.]+)")
            local free            = stdout:match("\nfree:%s*([%d%.]+)")
            local available       = stdout:match("\navailable:%s*([%d%.]+)")
            local swap_usage      = stdout:match("\nswap_usage:%s*(%d+)")
            local swap_total      = stdout:match("\nswap_total:%s*([%d%.]+)")
            local swap_used       = stdout:match("\nswap_used:%s*([%d%.]+)")
            local swap_free       = stdout:match("\nswap_free:%s*([%d%.]+)")

            -- Salva para o popup
            last_values.usage_available = usage_available or "--"
            last_values.usage           = usage or "--"
            last_values.available       = available or "--"
            last_values.total           = total or "--"
            last_values.used            = used or "--"
            last_values.free            = free or "--"
            last_values.swap_usage      = swap_usage or "--"
            last_values.swap_total      = swap_total or "--"
            last_values.swap_used       = swap_used or "--"
            last_values.swap_free       = swap_free or "--"

            local items = {}
            if show_usage_available and usage_available then table.insert(items, string.format("%3s%%", usage_available)) end
            if show_usage           and usage           then table.insert(items, string.format("%3s%%", usage))           end
            if show_total           and total           then table.insert(items, string.format("%5s GB", total))          end
            if show_used            and used            then table.insert(items, string.format("%5s GB", used))           end
            if show_free            and free            then table.insert(items, string.format("%5s GB", free))           end
            if show_available       and available       then table.insert(items, string.format("%5s GB", available))      end
            if show_swap_usage      and swap_usage      then table.insert(items, string.format("%3s%%", swap_usage))      end
            if show_swap_total      and swap_total      then table.insert(items, string.format("%5s GB", swap_total))     end
            if show_swap_used       and swap_used       then table.insert(items, string.format("%5s GB", swap_used))      end
            if show_swap_free       and swap_free       then table.insert(items, string.format("%5s GB", swap_free))      end

            local padding = " "
            w.markup = padding .. icon .. "<span font='MesloLGS Nerd Font Bold 8'>" .. table.concat(items, sep) .. "</span>" .. padding

            -- Atualiza o popup se estiver visível
            if popup and popup.visible then
                local valuebox = popup.widget:get_children_by_id("valuebox")[1]
                valuebox.markup = string.format(
                    " %s%%\n %s%%\n %s GB\n %s GB\n %s GB\n %s GB\n\n %s%%\n %s GB\n %s GB\n %s GB",
                    last_values.usage_available,
                    last_values.usage,
                    last_values.available,
                    last_values.total,
                    last_values.used,
                    last_values.free,
                    last_values.swap_usage,
                    last_values.swap_total,
                    last_values.swap_used,
                    last_values.swap_free
                )
            end
        end,
        widget
    )

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

return ram_monitor