-- Notification Center Module for AwesomeWM
-- Gerencia notificações com armazenamento, histórico e painel lateral

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local notification_center = {
    notifications = {},
    max_notifications = 50,
}

-- Estrutura de uma notificação armazenada
local function create_notification_entry(notification)
    return {
        id = notification.id,
        title = notification.title or "Sem título",
        message = notification.message or "",
        app_name = notification.app_name or "Sistema",
        icon = notification.icon,
        urgency = notification.urgency or "normal",
        timestamp = os.time(),
        read = false,
        actions = notification.actions or {},
        original_notification = notification
    }
end

-- Adicionar notificação ao histórico
function notification_center:add_notification(notification)
    local entry = create_notification_entry(notification)

    -- Adicionar ao início da lista (mais recentes primeiro)
    table.insert(self.notifications, 1, entry)

    -- Manter limite máximo
    if #self.notifications > self.max_notifications then
        table.remove(self.notifications, self.max_notifications + 1)
    end

    -- Emitir sinal
    awesome.emit_signal("notification::added", entry)

    return entry
end

-- Remover notificação
function notification_center:remove_notification(id)
    for i, notif in ipairs(self.notifications) do
        if notif.id == id then
            local removed = table.remove(self.notifications, i)
            awesome.emit_signal("notification::removed", removed)
            return removed
        end
    end
end

-- Marcar como lida
function notification_center:mark_as_read(id)
    for _, notif in ipairs(self.notifications) do
        if notif.id == id then
            notif.read = true
            awesome.emit_signal("notification::marked_read", notif)
            return true
        end
    end
    return false
end

-- Marcar todas como lidas
function notification_center:mark_all_as_read()
    for _, notif in ipairs(self.notifications) do
        notif.read = true
    end
    awesome.emit_signal("notification::marked_read", {all = true})
end

-- Limpar todas as notificações
function notification_center:clear_all()
    self.notifications = {}
    awesome.emit_signal("notification::cleared_all")
end

-- Obter notificações não lidas
function notification_center:get_unread_count()
    local count = 0
    for _, notif in ipairs(self.notifications) do
        if not notif.read then
            count = count + 1
        end
    end
    return count
end

-- Obter notificações não lidas
function notification_center:get_unread_notifications()
    local unread = {}
    for _, notif in ipairs(self.notifications) do
        if not notif.read then
            table.insert(unread, notif)
        end
    end
    return unread
end

-- Obter todas as notificações
function notification_center:get_all_notifications()
    return self.notifications
end

-- Conectar ao sistema de notificações naughty
naughty.connect_signal("request::display", function(n)
    -- Adicionar ao centro de notificações
    notification_center:add_notification(n)

    -- Exibir notificação padrão
    local box = naughty.layout.box {
        notification = n,
        shape = beautiful.notification_shape or gears.shape.rounded_rect,
    }

    -- Configurar botões
    box:buttons(gears.table.join(
        -- Botão esquerdo: marcar como lida e invocar ação
        awful.button({}, 1, function()
            notification_center:mark_as_read(n.id)
            local actions = n.actions or {}
            if #actions > 0 then
                actions[1]:invoke(n)
            end
            n:destroy(naughty.notification_closed_reason.dismissed_by_user)
        end),
        -- Botão direito: fechar silenciosamente
        awful.button({}, 3, function()
            n:destroy(naughty.notification_closed_reason.silent)
        end)
    ))
end)

-- Conectar ao sinal de destruição de notificações
naughty.connect_signal("notification::destroyed", function(n, reason)
    -- Não remover automaticamente - manter no histórico
end)

return notification_center
