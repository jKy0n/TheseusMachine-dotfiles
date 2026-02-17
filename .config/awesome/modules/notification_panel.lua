-- Notification Panel for AwesomeWM
-- Painel lateral direito com lista de notificações

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

local notification_panel = {
    visible = false,
    width = 400,
    panel = nil,
    screen = nil
}

-- Cores padrão
local colors = {
    bg = beautiful.bg_normal or "#1e1e2e",
    fg = beautiful.fg_normal or "#cdd6f4",
    bg_focus = beautiful.bg_focus or "#313244",
    fg_focus = beautiful.fg_focus or "#89b4fa",
    border = beautiful.border_focus or "#89b4fa",
    urgent = "#f38ba8",
    success = "#a6e3a1",
    warning = "#f9e2af"
}

-- Criar entrada de notificação
local function create_notification_item(notif)
    local urgency_color = colors.fg
    if notif.urgency == "critical" then
        urgency_color = colors.urgent
    elseif notif.urgency == "normal" then
        urgency_color = colors.success
    end

    -- Formatar timestamp
    local time_diff = os.time() - notif.timestamp
    local time_str = ""
    if time_diff < 60 then
        time_str = "agora"
    elseif time_diff < 3600 then
        time_str = math.floor(time_diff / 60) .. "m"
    elseif time_diff < 86400 then
        time_str = math.floor(time_diff / 3600) .. "h"
    else
        time_str = math.floor(time_diff / 86400) .. "d"
    end

    -- Status de leitura
    local read_indicator = notif.read and "✓" or "●"

    -- Container principal
    local item = wibox.widget {
        {
            {
                {
                    text = read_indicator,
                    font = "MesloLGS Nerd Font Bold 12",
                    fg = notif.read and colors.fg or urgency_color,
                    widget = wibox.widget.textbox
                },
                left = 8,
                right = 8,
                widget = wibox.container.margin
            },
            {
                {
                    {
                        text = notif.title,
                        font = "MesloLGS Nerd Font Bold 11",
                        fg = colors.fg,
                        widget = wibox.widget.textbox
                    },
                    {
                        text = notif.app_name,
                        font = "MesloLGS Nerd Font 9",
                        fg = colors.fg_focus,
                        widget = wibox.widget.textbox
                    },
                    spacing = 2,
                    layout = wibox.layout.fixed.vertical
                },
                {
                    text = time_str,
                    font = "MesloLGS Nerd Font 9",
                    fg = colors.fg_focus,
                    widget = wibox.widget.textbox
                },
                layout = wibox.layout.align.horizontal
            },
            {
                {
                    text = notif.message,
                    font = "MesloLGS Nerd Font 10",
                    fg = colors.fg,
                    widget = wibox.widget.textbox
                },
                left = 8,
                right = 8,
                top = 4,
                bottom = 4,
                widget = wibox.container.margin
            },
            spacing = 4,
            layout = wibox.layout.fixed.vertical
        },
        left = 8,
        right = 8,
        top = 6,
        bottom = 6,
        widget = wibox.container.margin
    }

    -- Botões de ação
    local buttons = gears.table.join(
        -- Botão esquerdo: marcar como lida
        awful.button({}, 1, function()
            get_notification_center():mark_as_read(notif.id)
        end),
        -- Botão direito: deletar
        awful.button({}, 3, function()
            get_notification_center():remove_notification(notif.id)
        end)
    )

    item:buttons(buttons)

    -- Efeito hover
    item:connect_signal("mouse::enter", function()
        item.bg = colors.bg_focus
    end)

    item:connect_signal("mouse::leave", function()
        item.bg = colors.bg
    end)

    return item
end

-- Criar lista de notificações
local function create_notification_list()
    local list_widget = wibox.widget {
        layout = wibox.layout.fixed.vertical,
        spacing = 1
    }

    local function update_list()
        list_widget:reset()

        local notifications = get_notification_center():get_all_notifications()

        if #notifications == 0 then
            list_widget:add(wibox.widget {
                {
                    text = "Nenhuma notificação",
                    font = "MesloLGS Nerd Font 11",
                    fg = colors.fg_focus,
                    align = "center",
                    widget = wibox.widget.textbox
                },
                top = 20,
                bottom = 20,
                widget = wibox.container.margin
            })
        else
            for _, notif in ipairs(notifications) do
                list_widget:add(create_notification_item(notif))
                list_widget:add(wibox.widget {
                    bg = colors.border,
                    forced_height = 1,
                    widget = wibox.widget.base.make_widget()
                })
            end
        end
    end

    -- Atualizar lista ao adicionar/remover notificações
    awesome.connect_signal("notification::added", function()
        update_list()
    end)

    awesome.connect_signal("notification::removed", function()
        update_list()
    end)

    awesome.connect_signal("notification::marked_read", function()
        update_list()
    end)

    awesome.connect_signal("notification::cleared_all", function()
        update_list()
    end)

    -- Atualização inicial
    update_list()

    return list_widget
end

-- Criar painel
function notification_panel:create(screen)
    self.screen = screen or awful.screen.focused()

    local list = create_notification_list()

    -- Scrollable container
    local scrollable = wibox.widget {
        list,
        forced_width = self.width - 20,
        widget = wibox.container.scroll.vertical
    }

    -- Header com botões
    local header = wibox.widget {
        {
            {
                text = "Notificações",
                font = "MesloLGS Nerd Font Bold 13",
                fg = colors.fg,
                widget = wibox.widget.textbox
            },
            {
                {
                    text = "✓",
                    font = "MesloLGS Nerd Font Bold 12",
                    fg = colors.fg_focus,
                    widget = wibox.widget.textbox,
                    buttons = gears.table.join(
                        awful.button({}, 1, function()
                            get_notification_center():mark_all_as_read()
                        end)
                    )
                },
                {
                    text = "✕",
                    font = "MesloLGS Nerd Font Bold 12",
                    fg = colors.urgent,
                    widget = wibox.widget.textbox,
                    buttons = gears.table.join(
                        awful.button({}, 1, function()
                            get_notification_center():clear_all()
                        end)
                    )
                },
                spacing = 10,
                layout = wibox.layout.fixed.horizontal
            },
            layout = wibox.layout.align.horizontal
        },
        left = 12,
        right = 12,
        top = 10,
        bottom = 10,
        widget = wibox.container.margin
    }

    header.bg = colors.bg_focus

    -- Painel principal
    self.panel = awful.wibar {
        position = "right",
        screen = self.screen,
        width = self.width,
        visible = false,
        ontop = true,
        type = "notification_panel"
    }

    self.panel:setup {
        {
            {
                header,
                {
                    scrollable,
                    left = 8,
                    right = 8,
                    top = 8,
                    bottom = 8,
                    widget = wibox.container.margin
                },
                layout = wibox.layout.fixed.vertical
            },
            bg = colors.bg,
            widget = wibox.container.background
        },
        widget = wibox.container.margin
    }

    return self.panel
end

-- Toggle painel
function notification_panel:toggle()
    if not self.panel then
        self:create()
    end

    self.visible = not self.visible
    self.panel.visible = self.visible
end

-- Mostrar painel
function notification_panel:show()
    if not self.panel then
        self:create()
    end

    self.visible = true
    self.panel.visible = true
end

-- Esconder painel
function notification_panel:hide()
    if self.panel then
        self.visible = false
        self.panel.visible = false
    end
end

-- Conectar ao sinal de toggle
awesome.connect_signal("notification_panel::toggle", function()
    notification_panel:toggle()
end)

-- Fechar painel ao clicar fora (opcional)
root.buttons(gears.table.join(
    root.buttons(),
    awful.button({}, 1, function()
        if notification_panel.visible then
            local mouse = mouse.coords()
            if mouse.x < notification_panel.screen.geometry.width - notification_panel.width then
                notification_panel:hide()
            end
        end
    end)
))

return notification_panel
