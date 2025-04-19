


local naughty = require("naughty")

local notify_manager = {}

-- Configurar o tamanho padrão das notificações
naughty.config.defaults = {
    timeout = 10, -- Tempo de exibição em segundos
    -- screen = awful.screen.focused(), -- Qual tela exibir as notificações
    screen = 1, -- Qual tela exibir as notificações
    position = "top_middle", -- Posição: 'top_right', 'top_left', 'bottom_right', 'bottom_left'
    margin = 10,
    ontop = true,
    font = "MesloLGS Nerd Font Bold 10", -- Fonte
    icon_size = 300,
    border_width = 2,
}

return notify_manager