--
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local widget_path = os.getenv("HOME") .. "/.config/awesome/jkyon-widgets/"
package.path = package.path .. ";" .. widget_path .. "?.lua"

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local common = require("awful.widget.common")

local free_focus = true
local function custom_focus_filter(c) return free_focus and awful.client.focus.filter(c) end

-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/jkyon/.config/awesome/themes/jkyon/theme.lua")

-- local lain = require("lain")
-- local mycpu = lain.widget.cpu()
-- local mymem = lain.widget.mem()
-- local mytemp = lain.widget.temp()

local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")

-- local todo_widget = require("awesome-wm-widgets.todo-widget.todo")
local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")

local internet_widget = require("jkyon-widgets.internet_widget")
local dnd_widget = require("jkyon-widgets.DoNotDisturb_widget")
local portage_checker = require("jkyon-widgets.portage_update_checker")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")




-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
------------------------------- Error handling ------------------------------

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


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end) 
end
-- }}}

------------------------------- Error handling ------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init("/home/jkyon/.config/awesome/themes/jkyon/theme.lua")

-- beautiful.layout_machi = machi.get_icon()

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
-- myawesomemenu = {
--    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
-- --   { "restart", awesome.restart },
-- --   { "quit", function() awesome.quit() end },
-- }

-- mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                     { "Apps" },
--                                     { "open terminal", terminal }
--                                   }
--                         })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- -- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock(' %a, %d %b - %H:%M ', 60)
-- mytextclock = wibox.widget.textclock()


-------------------- Widgets --------------------


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


-- local cpu = lain.widget.cpu {
--     settings = function()
--         widget:set_markup("CPU " .. cpu_now.usage .. "%")
--     end
-- }

-- local mem = lain.widget.mem {
--     settings = function()
--         widget:set_markup("RAM " .. mem_now.perc .. "%")
--     end
-- }

-- local temp = lain.widget.temp({
--     settings = function()
--         widget:set_markup("Temp " .. coretemp_now .. "°C ")
--     end
-- })


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

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

---------------------------------------------------------------------
---------------------------------------------------------------------
-------------------  Tags Manipulation Functions  -------------------

local function add_tag()
    awful.tag.add(" NewTag ", {
        screen = awful.screen.focused(),
        layout = awful.layout.suit.tile,
        volatile = true
    }):view_only()
end 

local function delete_tag()
    local t = awful.screen.focused().selected_tag
    if not t then return end
    t:delete()
end

local function rename_tag()
    awful.prompt.run {
        prompt       = "New tag name: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end

            local t = awful.screen.focused().selected_tag
            if t then
                t.name = new_name
            end
        end
    }
end

local function move_to_new_tag()
    local c = client.focus
    if not c then return end

    local t = awful.tag.add(c.class,{screen= c.screen, layout = awful.layout.suit.tile, volatile = true })
    c:tags({t})
    t:view_only()
end

-- Função auxiliar para verificar se uma tag já existe
local function find_tag_by_name(screen, name)
    for _, tag in ipairs(screen.tags) do
        if tag.name:match(name) then
            return tag
        end
    end
    return nil
end

-- Regras para criar tags voláteis
local function create_volatile_tag(c, tag_name, screen_index, layout)
    local screen = screen[screen_index]
    local existing_tag = find_tag_by_name(screen, tag_name)
    if existing_tag then
        c:move_to_tag(existing_tag)
        existing_tag:view_only()
    else
        local new_tag = awful.tag.add(tag_name, {
            screen = screen,
            layout = layout,
            volatile = true,
        })
        local tag_index = new_tag.index
        new_tag.name = tag_name .. "(" .. tag_index .. ") "
        c:move_to_tag(new_tag)
        new_tag:view_only()
    end
end

-------------------  Tags Manipulation Functions  -------------------


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
------------------------------ Tags Organization ----------------------------


awful.tag.add(" emerge (1) ", {
    layout = awful.layout.suit.tile.left,
    screen = 1,
    selected = false
})

awful.tag.add(" Code (2) ", {
    layout = awful.layout.suit.tile.left,
    screen = 1,
    selected = true
})

awful.tag.add(" Mail (3) ", {
    layout = awful.layout.suit.tile,
    screen = 1,
    selected = false
})

awful.tag.add(" Notes (4) ", {
    layout = awful.layout.suit.tile.left,
    screen = 1,
    selected = false
})

awful.tag.add(" Finances (5) ", {
    layout = awful.layout.suit.tile.left,
    screen = 1,
    selected = false
})

awful.tag.add(" Goddess (6) ", {
    layout = awful.layout.suit.tile.bottom,
    screen = 1,
    selected = false
})

awful.tag.add(" Telegram (7) ", {
    layout = awful.layout.suit.tile.bottom,
    screen = 1,
    selected = false
})



    ------------------ Second Monitor ------------------


awful.tag.add(" Monitor (1) ", {
layout = awful.layout.suit.tile.bottom,
screen = 2,
selected = true
})

awful.tag.add(" Chat (2) ", {    
layout = awful.layout.suit.tile.bottom,
screen = 2,
selected = false
})

awful.tag.add(" Sound (3) ", {
layout = awful.layout.suit.tile.bottom,
screen = 2,
selected = false
})


    ------------------ Third Monitor ------------------


awful.tag.add(" Monitor (1) ", {
    layout = awful.layout.suit.tile,
    screen = 3,
    selected = false
})

awful.tag.add(" Search (2) ", {
    layout = awful.layout.suit.tile,
    screen = 3,
    selected = true
})

awful.tag.add(" Media (3) ", {
    layout = awful.layout.suit.tile,
    screen = 3,
    selected = false
})


------------------------------ Tags Organization ----------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


        awful.screen.connect_for_each_screen(function(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = {
             shape  = gears.shape.rounded_bar,
        },
   }

   
-------------------------------------------------------------------------------------
--------------------------------  Wibox única  --------------------------------------
-------------------------------------------------------------------------------------

--     -- Create the wibox
--     s.mywibox = awful.wibar({ position = "top", screen = s, opacity = 0.8, border_width = 3, shape = gears.shape.rounded_rect 	 })

--     -- Add widgets to the wibox
--     s.mywibox:setup {
--         layout = wibox.layout.align.horizontal,
--         { -- Left widgets
--             layout = wibox.layout.fixed.horizontal,
-- --            mylauncher,
--             tbox_separator_space,
--             s.mylayoutbox,
--             tbox_separator_space,
--             tbox_separator_space,
--             s.mytaglist,
--             tbox_separator_space,
--             s.mypromptbox,
--             tbox_separator_space,

--         },

--         s.mytasklist, -- Middle widget

--         { -- Right widgets
--             layout = wibox.layout.fixed.horizontal,
-- --            mykeyboardlayout,

--             internet_widget,

--                     tbox_separator_space,

--             awful.widget.watch('bash -c "nice -n 19 sh /home/jkyon/ShellScript/dwmBlocksUpdates"', 3600),

--                     -- tbox_separator_space,
-- ------------------------------------------------------------------------------------------------            
--             -- wibox.widget.textbox(' | '),
-- ------------------------------------------------------------------------------------------------
--                     tbox_separator_space,
          
--             wibox.widget.textbox('  '),
--             wibox.widget.textbox('CPU '),
--             -- cpu.widget,
--             awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuUsage"', 1),
--                     tbox_separator_space,
--             wibox.widget.textbox('  '),
--             awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuTemp"', 1),
--                     tbox_separator_space,
-- ------------------------------------------------------------------------------------------------            
--             wibox.widget.textbox(' | '),
-- ------------------------------------------------------------------------------------------------
--                     tbox_separator_space,
           
--             cpu_widget(),
           
--                     tbox_separator_space,
-- ------------------------------------------------------------------------------------------------            
--             wibox.widget.textbox(' | '),
-- ------------------------------------------------------------------------------------------------
--             wibox.widget.textbox('   '),  --  
--             mem.widget,
--             ram_widget({ color_used = '#8aadf4', color_buf = '#1e2030' }),
-- ------------------------------------------------------------------------------------------------            
--             wibox.widget.textbox(' | '),
-- ------------------------------------------------------------------------------------------------
            
--             wibox.widget.textbox(' 󰢮 '),  --  

--            wibox.widget.textbox(' GPU '),
--            awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0usage-fast.sh"', 1),
--                  tbox_separator_space,
--            awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0freq.sh"', 1),
--                  tbox_separator_space,
--            wibox.widget.textbox('  '),
--            awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0temp.sh"', 1),
            
-- --            tbox_separator_space,
-- --            wibox.widget.textbox(' | '),
-- --            tbox_separator_space,

-- --          wibox.widget.textbox('GPU1: '),
-- --          awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu1freq.sh"', 1),
-- --                  tbox_separator_space,
-- --          wibox.widget.textbox('  '),
-- --          awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu1temp.sh"', 1),
            
--                     tbox_separator_space,
-- ------------------------------------------------------------------------------------------------            
--             wibox.widget.textbox(' | '),
-- ------------------------------------------------------------------------------------------------            
--             wibox.widget.textbox(' 󰚥 '),
--             wibox.widget.textbox(' PSU '),
--             awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-PSU-monitor.sh"', 1),
--                     tbox_separator_space,
-- ------------------------------------------------------------------------------------------------            
--             wibox.widget.textbox(' | '),
-- ------------------------------------------------------------------------------------------------
--                     tbox_separator_space,

--             volume_widget({ 
--                 widget_type = 'arc',
--                 thickness   = 2 ,
--                 step        = 5 ,
--                 mixer_cmd   = 'pavucontrol',
--                 device      = '@DEFAULT_SINK@',
--                 tooltip     = false
--                 }),
            
--                     tbox_separator_space,
            
--             -- todo_widget(),
            
--                     tbox_separator_space,
--                     tbox_separator_space,
            
--             wibox.widget.systray(),
            
--                     tbox_separator_space,

--             -- weather_widget({
--             --   api_key='3adf0fe30d03af8c1d09c7dda3b196dd',
--             --   coordinates = {24.0124, -46.4039},
--             --   }),

--             --  weather_curl_widget({
--             --     api_key = '3adf0fe30d03af8c1d09c7dda3b196dd',
--             --     coordinates = {24.012499355220648, -46.403999855263514},
--             --     time_format_12h = true,
--             --     units = 'imperial',
--             --     both_units_widget = true,
--             --     font_name = 'Carter One',
--             --     icons = 'VitalyGorbachev',
--             --     icons_extension = '.svg',
--             --     show_hourly_forecast = true,
--             --     show_daily_forecast = true,
--             -- }),
--             -- weather_widget({ api_key = '3adf0fe30d03af8c1d09c7dda3b196dd', coordinates = {45.5017, -73.5673}, }),
--             mytextclock,

--                     tbox_separator_space,

--             logout_menu_widget{
--                 -- font = 'Noto Sans semibold 9',
--                  font = 'MesloLGS Nerd Font Bold 10',
--                  onlogout   =  function() awesome.quit() end,
--                 --  onlock     =  function() awful.spawn.with_shell('xscreensaver-command -lock') end,
--                  onsuspend  =  function() awful.spawn.with_shell("systemctl suspend") end,
--                  onreboot   =  function() awful.spawn.with_shell("systemctl reboot") end,
--                  onpoweroff =  function() awful.spawn.with_shell("systemctl poweroff") end,
--             },
--                     tbox_separator_space
--         },
--     }

-- -- }}}
-- end)


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------


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


                internet_widget,
                        tbox_separator_space,

                portage_checker,
                        tbox_separator_space,

                -- awful.widget.watch('bash -c "nice -n 19 sh /home/jkyon/ShellScript/dwmBlocksUpdates"', 3600),

                        -- tbox_separator_space,
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

                -- volume_widget({ 
                --     widget_type = 'arc',
                --     thickness   = 2 ,
                --     step        = 5 ,
                --     mixer_cmd   = 'pavucontrol',
                --     device      = '@DEFAULT_SINK@',
                --     tooltip     = false
                --     }),
                
                --         tbox_separator_space,
                
                -- -- todo_widget(),
                
                --         tbox_separator_space,
                --         tbox_separator_space,
                
                -- wibox.widget.systray(),
                
                        -- tbox_separator_space,

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
            
                cpu_icon,   --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/CPU-usage-monitor.sh"', 1),
                        tbox_separator_space,
                temp_icon,  --    
                awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/CPU-temp-monitor.sh"', 1),
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

                -- volume_widget({ 
                --     widget_type = 'arc',
                --     thickness   = 2 ,
                --     step        = 5 ,
                --     mixer_cmd   = 'pavucontrol',
                --     device      = '@DEFAULT_SINK@',
                --     tooltip     = false
                --     }),
                
                --         tbox_separator_space,
                
                -- -- todo_widget(),
                
                --         tbox_separator_space,
                --         tbox_separator_space,
                
                -- wibox.widget.systray(),
                
                        tbox_separator_space,
                dnd_widget,
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

    end
    -- }}}
end)


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


-- {{{ Mouse bindings
root.buttons(gears.table.join(
    -- awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),


    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),

    -- Super + p = Rofi Launcher
    awful.key({ modkey, }, "p",
        --   function () awful.util.spawn("rofi -config ~/.config/rofi/config -show combi -combi-modi \"window,run\" -modi combi -icon-theme \"Papirus\" -show-icons -theme ~/.config/rofi/config.rasi") end),
        function () awful.util.spawn("rofi  -config /home/jkyon/.config/rofi.jkyon/config.rasi \
                                            -modes \"drun,run,file-browser-extended,window,emoji,calc\" -show drun \
                                            -icon-theme \"Papirus\" -show-icons \
                                            -theme /home/jkyon/.config/rofi.jkyon/theme.rasi") 
            end,
            {description = "show rofi launcher", group = "launcher"}),


    -- Super + o = Rofi emojis
    awful.key({ modkey, }, "o",
        --   function () awful.util.spawn("rofi -config ~/.config/rofi/config -show combi -combi-modi \"window,run\" -modi combi -icon-theme \"Papirus\" -show-icons -theme ~/.config/rofi/config.rasi") end),
        function () awful.util.spawn("rofi  -config /home/jkyon/.config/rofi/config.rasi \
                                            -modes \"drun,emoji\" -show emoji \
                                            -emoji-format \"<span font_family=\'NotoColorEmoji\' size=\'xx-large\'>{emoji}</span>  <span weight=\'bold\'>{name}</span>\" \
                                            -theme /home/jkyon/.config/rofi.jkyon/theme-emoji.rasi") 
            end,
            {description = "show rofi emojis", group = "launcher"}),


    -- alt + tab = Task Switcher
    awful.key({ "Mod1", }, "Tab",
        function () awful.util.spawn("rofi  -config /home/jkyon/.config/rofi.jkyon/config.rasi \
                                            -show window \
                                            -window-format \"{t}\" \
                                            -kb-row-down 'Alt+Tab,Alt+Down,Down' \
                                            -kb-row-up 'Alt+ISO_Left_Tab,Alt+Up,Up' \
                                            -kb-accept-entry '!Alt-Tab,!Alt+Down,!Alt+ISO_Left_Tab,!Alt+Up,Return' \
                                            -me-select-entry 'MouseSecondary' \
                                            -me-accept-entry 'MousePrimary' \
                                            -modi combi -icon-theme \"Papirus\" \
                                            -show-icons -theme /home/jkyon/.config/rofi.jkyon/theme-tab.rasi") 
            end,
            {description = "show rofi task switcher", group = "launcher"}),


---------------------  Tags Manipulation keybinds  ---------------------
------------------------------------------------------------------------

    awful.key({ modkey,           }, "a", add_tag,
        {description = "add a tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "a", delete_tag,
        {description = "delete the current tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "r", rename_tag,
        {description = "rename the current tag", group = "tag"}),
    awful.key({ modkey, "Control"   }, "a", move_to_new_tag,
        {description = "add a tag with the focused client", group = "tag"})

------------------------------------------------------------------------ 
------------------------------------------------------------------------     
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

        -- Audio control
    awful.key({}, "XF86AudioRaiseVolume", function() volume_widget:inc(5) end),
    awful.key({}, "XF86AudioLowerVolume", function() volume_widget:dec(5) end),
    awful.key({}, "XF86AudioMute", function() volume_widget:toggle() end),

    awful.key({}, "XF86AudioPrev", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous") end),
    awful.key({}, "XF86AudioNext", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next") end),
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause") end),
    awful.key({}, "XF86AudioStop", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause") end),

        -- Screenshot / Printscreen
    awful.key({}, "Print", function () awful.util.spawn("flameshot gui") end),
    awful.key({ "Shift" }, "Print", function () awful.util.spawn("flameshot screen") end),
    awful.key({ "Control" }, "Print", function () awful.util.spawn("flameshot full") end),

        -- Lock screen
    awful.key({ modkey, "Control" }, "Escape", function () awful.util.spawn("light-locker-command --lock") end),
    
        -- Centralize window --
    awful.key({ modkey, "Shift" }, "o", function()
        if client.focus then
            awful.placement.centered(client.focus, { honor_workarea = true })
        end
    end, {description = "centralize window", group = "client"}),


    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    -- awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    --           {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end



clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}


awful.rules.rules = rules

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = custom_focus_filter,
             --      focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
             --      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     placement = awful.placement.centered,
     }
    },



        ---------------------------------------------
        -----------------  My Rules ----------------- 
        ---------------------------------------------
-- A
--
        { rule = { class = "Alacritty" },
        properties = { titlebars_enabled = false },},

        { rule_any = { class = {"ark"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule_any = { class = {"Arandr"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- B
--

        { rule = { class = "Back In Time" }, -- Altere o class conforme necessário
            properties = { floating = true,
                callback = function(c)
                    create_volatile_tag(c, " BackUp ", 3, awful.layout.suit.tile)
                end,},},
-- C
--
-- D
--
        { rule = { class = "discord" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[2].tags[2], 
        },},
       
        { rule = { class = "dolphin" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- E
--
-- F
--
        { rule = { class = "feh" },
        properties = { floating = true, name = "feh",
        width = 2752,     -- Defina o tamanho que deseja
        height = 1152,    -- Defina o tamanho que deseja
        x = 1424,          -- Posição x
        y = 144,          -- Posição y
        screen = 1  }},
-- G
--
        { rule_any = { class = {"gedit", "Gedit"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { class = "Google-chrome" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[3].tags[3] },},
        
        { rule = { class = "gnome-calculator" },
        properties = { floating = true,
        placement = awful.placement.centered },},
        
        { rule_any = { class = {"Gnome-disks", "gnome-disks"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
        
        { rule = { class = "gpartedbin" },
        properties = { floating = true,
        placement = awful.placement.centered },},
        
        { rule = { name = "GPT4All" },
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " LLMs ", 1, awful.layout.suit.tile)
                end,},},

        { rule = { class = "Gnome-screenshot" },
        properties = { floating = true,
        placement = awful.placement.centered },},        
-- H
--
        { rule_any = { class = {"Heroic Games Launcher", "heroic"} },
        properties = { floating = false,
        placement = awful.placement.centered },},
-- I
--
-- J
--
-- K
--
        { rule = { name = "kclock" },
        properties = { floating = true,
        placement = awful.placement.centered },},    

        { rule = { name = "KDE Connect" },
        properties = { floating = true,
        placement = awful.placement.centered,
        tag = screen[3].tags[1] },},    
-- L
--
        { rule_any = { name = {"lm studio", "LM Studio" } },
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " LLMs ", 1, awful.layout.suit.tile)
            end,},},

        { rule = { name = "Lutris" },
        properties = { floating = true,
        placement = awful.placement.centered },},
    
        { rule = { class = "Lxappearance" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- M
--
        { rule_any = { class = {"mpv"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { name = "MuPDF" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- N
--      
        { rule_any = { class = {"nemo", "Nemo"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- O
--
        { rule = { name = "OBS *" }, -- Altere o class conforme necessário
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " OBS ", 3, awful.layout.suit.tile)
                end,},},

        { rule_any = { class = {"obsidian", "obsidian"} },
        properties = { floating = false,
        tag = screen[1].tags[4]       },},

        { rule = { class = "openrgb" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- P
--        
        { rule_any = { class = {"pavucontrol", "Pavucontrol"} },
        properties = { floating = false,
        tag = screen[2].tags[3],
        },},
        
        { rule = { class = "plasma-emojier" },
        properties = { floating = true,
        placement = awful.placement.centered },},
        
        { rule = { class = "PrismLauncher" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule_any = { class = {"ProtonUp-Qt"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule_any = { class = {"pulseeffects", "Pulseeffects"} },
        properties = { floating = false,
        tag = screen[2].tags[3]
        },},
-- Q
-- 
        { rule = { class = "qt5ct" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { class = "qt6ct" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- R
--      
        { rule = { class = "rambox" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[2].tags[2],
        },},
-- S
--
        { rule = { class = "Spotify" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[2].tags[3],
        },},

        { rule_any = { class = {"snappergui", "Snapper-gui"} },
        properties = { floating = true,
        placement = awful.placement.centered,},},

        { rule = { class = "steam" }, -- Altere o class conforme necessário
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " Steam ", 1, awful.layout.suit.tile.left)
            end,},},
-- T
--  
        { rule = { class = "teams-for-linux" },
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " Teams ", 3, awful.layout.suit.tile.left)
        end,},},
        
        { rule_any = { class = {"telegram-desktop", "TelegramDesktop"} },
            properties = { floating = true,
                callback = function(c)
                    create_volatile_tag(c, " telegram ", 3, awful.layout.suit.tile.left)
            end,},},

        { rule = { class = "Thunar" },
        properties = { floating = true, placement = awful.placement.centered },},
        { rule = { class = "thunderbird" },
        properties = { floating = false,
        placement = awful.placement.left,
        tag = screen[1].tags[3] },},
        
        { rule = { class = "Timeshift" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- U
--
-- V
--

        { rule_any = { class = {"virt-manager", "Virt-manager"} }, -- Altere o class conforme necessário
            properties = { floating = true,
                callback = function(c)
                    create_volatile_tag(c, " VirtManager ", 1, awful.layout.suit.tile.left)
            end,},},

        { rule_any = { class = {"code", "Code"} },     -- vsCode
        properties = { floating = true,
        placement = awful.placement.centered },},
-- W
--
-- X
--
-- Y
--
       { rule = { class = "yakuake" },
       properties = { floating = true, ontop = true, focus = true },
       callback = function(c)
           c:geometry({x=1450, y=25})
           c:connect_signal("unmanage", function() free_focus = true end)
       end },
-- Z
-- 
                
}

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end


    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end) 
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)



-- jKyon Adds --

-- Notifications adjustments
beautiful.notification_font = "MesloLGS Nerd Font 12"


-- Run garbage collector regularly to prevent memory leaks
gears.timer {
    timeout = 30,
    autostart = true,
    callback = function() collectgarbage() end
}


-- Adjust screen layout
awful.spawn.with_shell("sh /home/jkyon/.screenlayout/screenlayout.sh")
-- Set wallpaper
awful.spawn.with_shell("feh --no-xinerama --bg-fill ~/Pictures/Wallpapers/LinuxWallpapers/BlueNebula8K.jpg")

-- Start awesome target on systemd
awful.spawn.easy_async_with_shell(
    "systemctl --user --no-block start lockScreen.service",
    function(stdout, stderr, exit_reason, exit_code) end
)

-- Start some programs at startup
awful.spawn.with_shell("sh /home/jkyon/.config/awesome/autorun.sh")