


local awful = require("awful")
local gears = require("gears")

local prompt_manager = {}

-- Função para criar o promptbox e layoutbox para uma tela
function prompt_manager.create(s)
    -- Criar um promptbox para a tela
    s.my_promptbox = awful.widget.prompt()

    -- Criar um layoutbox para a tela
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))
end

return prompt_manager