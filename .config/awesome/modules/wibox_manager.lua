



local awful = require("awful")
local wibox = require("wibox")

local wibox_manager = {}

-- Função para criar a wibox para uma tela
function wibox_manager.create(s)
    -- Criar a wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Configurar os widgets da wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.my_promptbox, -- Atualizado para refletir o nome correto
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end

return wibox_manager