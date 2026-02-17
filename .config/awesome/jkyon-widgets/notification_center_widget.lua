-- Notification Center Widget for AwesomeWM
-- Widget para wibar que mostra contador de notificações não lidas

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

-- Lazy load para evitar dependência circular
local notification_center = nil
local function get_notification_center()
    if not notification_center then
        notification_center = require("modules.notification_center")
    end
    return notification_center
end

local notification_widget = {}

-- Criar widget
function notification_widget.create()
    local widget = wibox.widget {
        {
            id = "icon",
            text = "",
            font = "MesloLGS Nerd Font Bold 14",
            widget = wibox.widget.textbox
        },
        {
            id = "badge",
            text = "",
            font = "MesloLGS Nerd Font Bold 10",
            fg = beautiful.fg_focus or "#cad3f5",
            widget = wibox.widget.textbox
        },
        layout = wibox.layout.stack,
        set_notification_count = function(self, count)
            local badge = self:get_children_by_id("badge")[1]
            if count > 0 then
                if count > 99 then
                    badge.text = "99+"
                else
                    badge.text = tostring(count)
                end
                badge.visible = true
            else
                badge.visible = false
            end
        end
    }

    -- Atualizar contador inicial
    widget:set_notification_count(get_notification_center():get_unread_count())

    -- Conectar aos sinais de notificações
    awesome.connect_signal("notification::added", function(notif)
        widget:set_notification_count(get_notification_center():get_unread_count())
    end)

    awesome.connect_signal("notification::removed", function(notif)
        widget:set_notification_count(get_notification_center():get_unread_count())
    end)

    awesome.connect_signal("notification::marked_read", function(notif)
        widget:set_notification_count(get_notification_center():get_unread_count())
    end)

    awesome.connect_signal("notification::cleared_all", function()
        widget:set_notification_count(0)
    end)

    -- Adicionar tooltip
    awful.tooltip {
        objects = {widget},
        text = "Clique para abrir a central de notificações",
        mode = "outside",
        align = "bottom"
    }

    -- Configurar botões do mouse
    widget:buttons(gears.table.join(
        -- Botão esquerdo: abrir painel
        awful.button({}, 1, function()
            awesome.emit_signal("notification_panel::toggle")
        end),
        -- Botão direito: limpar todas
        awful.button({}, 3, function()
            get_notification_center():clear_all()
        end),
        -- Scroll para cima: marcar todas como lidas
        awful.button({}, 4, function()
            get_notification_center():mark_all_as_read()
        end)
    ))

    return widget
end

return notification_widget
