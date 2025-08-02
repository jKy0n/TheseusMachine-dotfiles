

local awful = require("awful")
local wibox = require("wibox")



-- load awesome-wm-widgets
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")

-- local todo_widget = require("awesome-wm-widgets.todo-widget.todo")
local volume_widget = require('awesome-wm-widgets.wpctl-widget.volume')
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")

-- load jkyon-widgets
local internet_widget = require("jkyon-widgets.internet_widget")
local dnd_widget = require("jkyon-widgets.DoNotDisturb_widget")
local portage_checker = require("jkyon-widgets.portage_update_checker")

-------------------- Widgets Handler --------------------
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

local cpu_icon = styled_textbox('  ', 11, 2)
local mem_icon = styled_textbox('   ', 11, 2)
local gpu_icon = styled_textbox(' 󰢮 ', 16, 1)
local temp_icon = styled_textbox('  ', 11, 1)
local psu_icon = styled_textbox(' 󰚥 ', 11, 1)


-- Create a textclock widget
mytextclock = wibox.widget.textclock(' %a, %d %b - %H:%M ', 60)

local cw = calendar_widget({
    theme = 'naughty',
    placement = 'top_right',
    start_sunday = false,
    radius = 8,
--  with customized next/previous (see table above)
    previous_month_button = 1,
    next_month_button = 3,
})
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end)




local wibar = {}

function  wibar.setup(s)
    


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


                internet_widget,
                        tbox_separator_space,

                portage_checker,
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                -- wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                        tbox_separator_space,
            
                    cpu_icon,   --     
                wibox.widget.textbox('CPU '),
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/CPU-usage-monitor.sh"', 1),
                        tbox_separator_space,
                        tbox_separator_space,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/CPU-freq-monitor.sh"', 1),
                        tbox_separator_space,

                    temp_icon,  --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/CPU-temp-monitor.sh"', 1),
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

                    mem_icon,   --    
                wibox.widget.textbox('RAM '),
                        tbox_separator_space,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/RAM-usage-monitor.sh"', 1),
                        tbox_separator_space,
                ram_widget({ color_used = '#8aadf4', color_buf = '#1e2030' }),
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                
                    gpu_icon,   --      󰢮
                wibox.widget.textbox('GPU '),
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/GPU-usage-monitor.sh"', 1),
                    tbox_separator_space,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/GPU-freq-monitor.sh"', 1),
                    tbox_separator_space,

                    temp_icon,      --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/GPU-temp-monitor.sh"', 1),
                    tbox_separator_space,
                    
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------            

                psu_icon,  --    󰚥
                wibox.widget.textbox(' PSU '),
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/PSU-usage-monitor.sh"', 1),
                        tbox_separator_space,

                temp_icon, --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/PSU-temp-monitor.sh"', 1),

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
                    onlock     =  function() awful.spawn.with_shell('dm-tool lock') end,
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

    ------------------------------------------------------------------------------------------------            
                -- wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                        tbox_separator_space,
                        tbox_separator_space,
                        tbox_separator_space,
            
                cpu_icon,   --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/CPU-usage-monitor.sh"', 1),
                --         tbox_separator_space,
                -- wibox.widget.textbox('  '),
                -- awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuTemp"', 1),
            
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                mem_icon,   --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/RAM-usage-monitor.sh"', 1),
                -- mem.widget,
                -- ram_widget({ color_used = '#8aadf4', color_buf = '#1e2030' }),
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                
                gpu_icon,   --      󰢮
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/GPU-usage-monitor.sh"', 1),
            --         tbox_separator_space,
            -- awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0freq.sh"', 1),
            --         tbox_separator_space,
            -- wibox.widget.textbox('  '),
            -- awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0temp.sh"', 1),
                           
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
                        -- tbox_separator_space,

                mytextclock,

                        tbox_separator_space,

                logout_menu_widget{
                    font = 'MesloLGS Nerd Font Bold 10',
                    onlogout   =  function() awful.spawn.with_shell("loginctl terminate-user $USER") end,
                    onlock     =  function() awful.spawn.with_shell('dm-tool lock') end,
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
            
                cpu_icon,   --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/CPU-usage-monitor.sh"', 1),
                        tbox_separator_space,
                temp_icon,  --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/CPU-temp-monitor.sh"', 1),
            
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                mem_icon,   --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/RAM-usage-monitor.sh"', 1),
                -- mem.widget,
                -- ram_widget({ color_used = '#8aadf4', color_buf = '#1e2030' }),
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                
                gpu_icon,  --      󰢮
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/GPU-usage-monitor.sh"', 1),
                    tbox_separator_space,
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/GPU-freq-monitor.sh"', 1),
                    tbox_separator_space,
                temp_icon,  --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/GPU-temp-monitor.sh"', 1),
                
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------            

                psu_icon,   --    󰚥
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/PSU-usage-monitor.sh"', 1),
                        tbox_separator_space,
                temp_icon,  --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/PSU-temp-monitor.sh"', 1),
                        tbox_separator_space,
    ------------------------------------------------------------------------------------------------            
                wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------
                
                        tbox_separator_space,
                dnd_widget,
                        tbox_separator_space,

                mytextclock,

                        tbox_separator_space,

                logout_menu_widget{
                    font = 'MesloLGS Nerd Font Bold 10',
                    onlogout   =  function() awful.spawn.with_shell("loginctl terminate-user $USER") end,
                    onlock     =  function() awful.spawn.with_shell('dm-tool lock') end,
                    onsuspend  =  function() awful.spawn.with_shell("systemctl suspend") end,
                    onreboot   =  function() awful.spawn.with_shell("systemctl reboot") end,
                    onpoweroff =  function() awful.spawn.with_shell("systemctl poweroff") end,
                },
                        tbox_separator_space
            },
        }

    end
    -- }}}
end

return wibar