local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local lain = require("lain")
local mycpu = lain.widget.cpu()
local mymem = lain.widget.mem()
local mytemp = lain.widget.temp()

local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")

local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")

local widget_path = os.getenv("HOME") .. "/.config/awesome/jkyon-widgets/"

local internet_widget = require("jkyon-widgets.internet_widget")
local dnd_widget = require("jkyon-widgets/DoNotDisturb-Widget")

local wibox_manager = {}

tbox_separator_space = wibox.widget.textbox (" ")
-- tbox_separator_pipe = wibox.widget.textbox (" | ")
-- tbox_separator_dash = wibox.widget.textbox (" - ")

local function styled_textbox(text, font_size, margins)
    return wibox.widget {
        text = text,
        font = 'MesloLGS Nerd Font ' .. font_size,
        widget = wibox.widget.textbox,
        margins = margins
    }
end

local cpu_icon = styled_textbox('  ', 11, 2)
local mem_icon = styled_textbox('   ', 11, 2)
local gpu_icon = styled_textbox(' 󰢮 ', 16, 1)
local temp_icon = styled_textbox('  ', 11, 1)
local psu_icon = styled_textbox(' 󰚥 ', 11, 1)


local cpu = lain.widget.cpu {
    settings = function()
        widget:set_markup("CPU " .. cpu_now.usage .. "%")
    end
}

local mem = lain.widget.mem {
    settings = function()
        widget:set_markup("RAM " .. mem_now.perc .. "%")
    end
}

local temp = lain.widget.temp({
    settings = function()
        widget:set_markup("Temp " .. coretemp_now .. "°C ")
    end
})


-- Função para criar a wibox para uma tela
function wibox_manager.create(s, mylauncher, mykeyboardlayout, mytextclock)
    -- Criar a wibox


    -- Create the wibox monitor 1
    s.mywibox = awful.wibar({   position = "top", 
                                screen = s, 
                                opacity = 0.8, 
                                border_width = 3, 
                                shape = gears.shape.rounded_rect 
    })

-------------------------------------------------------------------------------------
----------------------------------  Wibox 1  ----------------------------------------
-------------------------------------------------------------------------------------

    -- Configuração da wibox para cada monitor
    if s.index == 1 then
    -- Primeiro monitor
        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
    --            mylauncher,
                tbox_separator_space,
                s.mylayoutbox,
                tbox_separator_space,
                tbox_separator_space,
                s.mytaglist,
                tbox_separator_space,
                s.mypromptbox,
                tbox_separator_space,

            },

            s.mytasklist, -- Middle widget

            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
    --            mykeyboardlayout,

                internet_widget,

                        tbox_separator_space,

                awful.widget.watch('bash -c "nice -n 19 sh /home/jkyon/ShellScript/dwmBlocksUpdates"', 3600),

                        -- tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                -- wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                        tbox_separator_space,
            
                    cpu_icon,
                -- wibox.widget.textbox('  '),
                wibox.widget.textbox('CPU '),
                -- cpu.widget,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuUsage"', 1),
                        tbox_separator_space,
                        tbox_separator_space,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/awesomeWidget-CPU-freq-monitor.sh"', 1),
                        tbox_separator_space,
                -- wibox.widget.textbox('  '),
                    temp_icon,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuTemp"', 1),
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                        tbox_separator_space,
            
                cpu_widget(),
            
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                -- wibox.widget.textbox('   '),
                mem_icon,

                mem.widget,
                ram_widget({ color_used = '#8aadf4', color_buf = '#1e2030' }),
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                
                -- wibox.widget.textbox(' 󰢮 '),
                gpu_icon,

            wibox.widget.textbox('GPU '),
            awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0usage-fast.sh"', 1),
                    tbox_separator_space,
            awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0freq.sh"', 1),
                    tbox_separator_space,
            -- wibox.widget.textbox('  '),
                temp_icon,
            awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0temp.sh"', 1),
                
    --            tbox_separator_space,
    --            wibox.widget.textbox(' | '),
    --            tbox_separator_space,

    --          wibox.widget.textbox('GPU1: '),
    --          awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu1freq.sh"', 1),
    --                  tbox_separator_space,
    --          wibox.widget.textbox('  '),
    --          awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu1temp.sh"', 1),
                
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------            
                -- wibox.widget.textbox(' 󰚥 '),
                    psu_icon,
                wibox.widget.textbox(' PSU '),
                awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-PSU-monitor.sh"', 1),
                        tbox_separator_space,
                        -- wibox.widget.textbox('  '),
                    temp_icon,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/awesomeWidget-PSU-temp-monitor.sh"', 1),
                        tbox_separator_space,

    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                        tbox_separator_space,

                volume_widget({ 
                    widget_type = 'arc',
                    thickness   = 2 ,
                    step        = 5 ,
                    mixer_cmd   = 'pavucontrol',
                    device      = '@DEFAULT_SINK@',
                    tooltip     = false
                    }),
                
                        tbox_separator_space,
                
                -- todo_widget(),
                
                        tbox_separator_space,
                dnd_widget,
                        tbox_separator_space,
                
                wibox.widget.systray(),
                
                        tbox_separator_space,

                mytextclock,

                        tbox_separator_space,

                logout_menu_widget{
                    font = 'MesloLGS Nerd Font Bold 10',
                    onlogout   =  function() awful.spawn.with_shell("loginctl terminate-user $USER") end,
                    onlock     =  function() awful.spawn.with_shell('light-locker-command --lock') end,
                    onsuspend  =  function() awful.spawn.with_shell("systemctl suspend") end,
                    onreboot   =  function() awful.spawn.with_shell("systemctl reboot") end,
                    onpoweroff =  function() awful.spawn.with_shell("systemctl poweroff") end,
                },
                        tbox_separator_space
            },
        }


-------------------------------------------------------------------------------------
----------------------------------  Wibox 2  ----------------------------------------
-------------------------------------------------------------------------------------


    elseif s.index == 2 then
        -- Segundo monitor
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
    --            mylauncher,
                tbox_separator_space,
                s.mylayoutbox,
                tbox_separator_space,
                tbox_separator_space,
                s.mytaglist,
                tbox_separator_space,
                s.mypromptbox,
                tbox_separator_space,

            },

            s.mytasklist, -- Middle widget

            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
    --            mykeyboardlayout,

                internet_widget,

                --         tbox_separator_space,

                -- awful.widget.watch('bash -c "nice -n 19 sh /home/jkyon/ShellScript/dwmBlocksUpdates"', 3600),

                        -- tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                -- wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                        tbox_separator_space,
                        tbox_separator_space,
                        tbox_separator_space,
            
                -- wibox.widget.textbox('  '),
                cpu_icon,
                wibox.widget.textbox('CPU '),
                -- cpu.widget,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuUsage"', 1),
                --         tbox_separator_space,
                -- wibox.widget.textbox('  '),
                -- awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuTemp"', 1),
                --         tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
    --             wibox.widget.textbox(' | '),
    -- ------------------------------------------------------------------------------------------------
    --                     tbox_separator_space,
            
    --             cpu_widget(),
            
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                -- wibox.widget.textbox('   '),  --  
                mem_icon,
                mem.widget,
                -- ram_widget({ color_used = '#8aadf4', color_buf = '#1e2030' }),
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                
                -- wibox.widget.textbox(' 󰢮 '),  --  
                gpu_icon,

            wibox.widget.textbox(' GPU '),
            awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0usage-fast.sh"', 1),
            --         tbox_separator_space,
            -- awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0freq.sh"', 1),
            --         tbox_separator_space,
            -- wibox.widget.textbox('  '),
            -- awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0temp.sh"', 1),
                
    --            tbox_separator_space,
    --            wibox.widget.textbox(' | '),
    --            tbox_separator_space,

    --          wibox.widget.textbox('GPU1: '),
    --          awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu1freq.sh"', 1),
    --                  tbox_separator_space,
    --          wibox.widget.textbox('  '),
    --          awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu1temp.sh"', 1),
                
                        -- tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
    --             wibox.widget.textbox(' | '),
    -- ------------------------------------------------------------------------------------------------            
    --             wibox.widget.textbox(' 󰚥 '),
    --             wibox.widget.textbox(' PSU '),
    --             awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-PSU-monitor.sh"', 1),
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                        tbox_separator_space,

                volume_widget({ 
                    widget_type = 'arc',
                    thickness   = 2 ,
                    step        = 5 ,
                    mixer_cmd   = 'pavucontrol',
                    device      = '@DEFAULT_SINK@',
                    tooltip     = false
                    }),
                
                --         tbox_separator_space,
                
                -- -- todo_widget(),
                
                --         tbox_separator_space,
                --         tbox_separator_space,
                
                -- wibox.widget.systray(),
                
                        tbox_separator_space,

                mytextclock,

                        tbox_separator_space,

                logout_menu_widget{
                    font = 'MesloLGS Nerd Font Bold 10',
                    onlogout   =  function() awful.spawn.with_shell("loginctl terminate-user $USER") end,
                    onlock     =  function() awful.spawn.with_shell('light-locker-command --lock') end,
                    onsuspend  =  function() awful.spawn.with_shell("systemctl suspend") end,
                    onreboot   =  function() awful.spawn.with_shell("systemctl reboot") end,
                    onpoweroff =  function() awful.spawn.with_shell("systemctl poweroff") end,
                },
                        tbox_separator_space
            },
        }

-------------------------------------------------------------------------------------
----------------------------------  Wibox 3  ----------------------------------------
-------------------------------------------------------------------------------------        

    elseif s.index == 3 then
        -- Segundo monitor
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
    --            mylauncher,
                tbox_separator_space,
                s.mylayoutbox,
                tbox_separator_space,
                tbox_separator_space,
                s.mytaglist,
                tbox_separator_space,
                s.mypromptbox,
                tbox_separator_space,

            },

            s.mytasklist, -- Middle widget

            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
    --            mykeyboardlayout,

                internet_widget,
                -- dnd_widget,

                        tbox_separator_space,

                awful.widget.watch('bash -c "nice -n 19 sh /home/jkyon/ShellScript/dwmBlocksUpdates"', 3600),

                        -- tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                -- wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                        tbox_separator_space,
            
                -- wibox.widget.textbox('  '),
                cpu_icon,
                wibox.widget.textbox('CPU '),
                -- cpu.widget,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuUsage"', 1),
                        tbox_separator_space,
                        tbox_separator_space,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/awesomeWidget-CPU-freq-monitor.sh"', 1),
                        tbox_separator_space,
                -- wibox.widget.textbox('  '),
                temp_icon,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuTemp"', 1),
    --                     tbox_separator_space,
    -- ------------------------------------------------------------------------------------------------            
    --             wibox.widget.textbox(' | '),
    -- ------------------------------------------------------------------------------------------------
    --                     tbox_separator_space,
            
    --             cpu_widget(),
            
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                -- wibox.widget.textbox('   '),  --  
                mem_icon,
                mem.widget,
                -- ram_widget({ color_used = '#8aadf4', color_buf = '#1e2030' }),
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                
                -- wibox.widget.textbox(' 󰢮 '),  --  
                gpu_icon,

            wibox.widget.textbox(' GPU '),
            awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0usage-fast.sh"', 1),
                    tbox_separator_space,
            awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0freq.sh"', 1),
                    tbox_separator_space,
            -- wibox.widget.textbox('  '),
            temp_icon,
            awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0temp.sh"', 1),
                
    --            tbox_separator_space,
    --            wibox.widget.textbox(' | '),
    --            tbox_separator_space,

    --          wibox.widget.textbox('GPU1: '),
    --          awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu1freq.sh"', 1),
    --                  tbox_separator_space,
    --          wibox.widget.textbox('  '),
    --          awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu1temp.sh"', 1),
                
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------            
                -- wibox.widget.textbox(' 󰚥 '),
                psu_icon,
                wibox.widget.textbox(' PSU '),
                awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-PSU-monitor.sh"', 1),
                        tbox_separator_space,
                -- wibox.widget.textbox('  '),
                temp_icon,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/awesomeWidget-PSU-temp-monitor.sh"', 1),
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                        tbox_separator_space,

                volume_widget({ 
                    widget_type = 'arc',
                    thickness   = 2 ,
                    step        = 5 ,
                    mixer_cmd   = 'pavucontrol',
                    device      = '@DEFAULT_SINK@',
                    tooltip     = false
                    }),
                
                --         tbox_separator_space,
                
                -- -- todo_widget(),
                
                --         tbox_separator_space,
                --         tbox_separator_space,
                
                -- wibox.widget.systray(),
                
                        tbox_separator_space,

                mytextclock,

                        tbox_separator_space,

                logout_menu_widget{
                    font = 'MesloLGS Nerd Font Bold 10',
                    onlogout   =  function() awful.spawn.with_shell("loginctl terminate-user $USER") end,
                    onlock     =  function() awful.spawn.with_shell('light-locker-command --lock') end,
                    onsuspend  =  function() awful.spawn.with_shell("systemctl suspend") end,
                    onreboot   =  function() awful.spawn.with_shell("systemctl reboot") end,
                    onpoweroff =  function() awful.spawn.with_shell("systemctl poweroff") end,
                },
                        tbox_separator_space
            },
        }

    end -- Fechar o bloco principal `if`
end -- Fechar a função `wibox_manager.create`


return wibox_manager