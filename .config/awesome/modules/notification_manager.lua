

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local notification_manager = {}

-- Configurar o tamanho padrão das notificações
naughty.config.defaults = {
    timeout = 10, -- Tempo de exibição em segundos
    -- screen = awful.screen.focused(), -- Qual tela exibir as notificações
    screen = 1, -- Qual tela exibir as notificações
    position = "top_middle", -- Posição: 'top_right', 'top_left', 'bottom_right', 'bottom_left'
    margin = 10,
    ontop = true,
    font = "MesloLGS Nerd Font Bold 12", -- Fonte
    icon_size = 300,
    border_width = 2,
    border_color = beautiful.border_focus,
}

-- Customizar o comportamento dos botões do mouse nas notificações
-- Workaround para o bug #3944 do Awesome WM
-- Botão esquerdo (1): invoca a ação default da notificação (abre)
-- Botão direito (3): fecha/dismiss a notificação silenciosamente
naughty.connect_signal("request::display", function(n)
    local box = naughty.layout.box {
        notification = n,
        shape = beautiful.notification_shape or gears.shape.rounded_rect,
    }

    -- Sobrescreve os botões padrão do box
    box:buttons(gears.table.join(
        -- Botão esquerdo: invoca a ação default e fecha
        awful.button({ }, 1, function()
            local actions = n.actions or {}
            if #actions > 0 then
                actions[1]:invoke(n)
            end
            n:destroy(naughty.notification_closed_reason.dismissed_by_user)
        end),
        -- Botão direito: fecha silenciosamente (dismiss)
        awful.button({ }, 3, function()
            n:destroy(naughty.notification_closed_reason.silent)
        end)
    ))
end)

return notification_manager