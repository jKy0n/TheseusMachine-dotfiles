

local beautiful = require("beautiful")
local naughty = require("naughty")

local notification_manager = {}

-- Configurar o tamanho padrão das notificações
-- O handler request::display está em notification_center.lua
naughty.config.defaults = {
    timeout = 10, -- Tempo de exibição em segundos
    screen = 1, -- Qual tela exibir as notificações
    position = "top_middle", -- Posição: 'top_right', 'top_left', 'bottom_right', 'bottom_left'
    margin = 10,
    ontop = true,
    font = "MesloLGS Nerd Font Bold 12", -- Fonte
    icon_size = 300,
    border_width = 2,
    border_color = beautiful.border_focus,
}

return notification_manager