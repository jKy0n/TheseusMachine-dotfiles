

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
-- load jkyon monitors
local cpu_monitor = require("jkyon-widgets.cpu_monitor")
local ram_monitor = require("jkyon-widgets.ram_monitor")
local gpu_monitor = require("jkyon-widgets.gpu_monitor")
local psu_monitor = require("jkyon-widgets.psu_monitor")


-------------------- Widgets Handler --------------------

tbox_separator_space = wibox.widget.textbox (" ")
-- tbox_separator_pipe = wibox.widget.textbox (" | ")
-- tbox_separator_dash = wibox.widget.textbox (" - ")


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

                cpu_monitor({ "usage", "freq", "temp" }),   --   CPU monitor

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                cpu_widget(),   --   CPU usage bars widget

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                ram_monitor({ "usage_available" }),   --   RAM monitor

                ram_widget({ color_used = '#8aadf4', color_buf = '#1e2030' }), --   RAM usage disc widget

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                gpu_monitor({ "usage", "freq", "temp" }),   -- 󰢮  GPU monitor

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                psu_monitor({ "power", "usage", "temp" }),  -- 󰚥  PSU monitor

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
        -- Segundo monitor (monitor à esquerda)
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

                cpu_monitor({ "usage" }),  --   CPU monitor

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                ram_monitor({ "usage_available" }),  --   RAM monitor

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                gpu_monitor({ "usage" }),   -- 󰢮  GPU monitor

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                psu_monitor({ "power", "usage" }),  -- 󰚥  PSU monitor

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

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
        -- Terceiro monitor (monitor à direita)
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

    ------------------------------------------------------------------------------------------------
                        -- wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                cpu_monitor({ "usage", "temp" }),  --   CPU monitor

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                ram_monitor({ "usage_available" }),   --   RAM monitor

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                gpu_monitor({ "usage", "temp" }),   -- 󰢮  GPU monitor

    ------------------------------------------------------------------------------------------------
                        wibox.widget.textbox(' | '),
    ------------------------------------------------------------------------------------------------

                psu_monitor({ "power", "usage", "temp" }),  -- 󰚥  PSU monitor

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