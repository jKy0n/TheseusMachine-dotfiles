

local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local gears = require("gears")
local tags_utils = require("modules.tags_utils")

local keys = {
    globalkeys = globalkeys,
    clientkeys = clientkeys
}

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
    -- awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    --           {description = "quit awesome", group = "awesome"}),


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

    awful.key({ modkey,           }, "a", tags_utils.add_tag,
        {description = "add a tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "a", tags_utils.delete_tag,
        {description = "delete the current tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "r", tags_utils.rename_tag,
        {description = "rename the current tag", group = "tag"}),
    awful.key({ modkey, "Control"   }, "a", tags_utils.move_to_new_tag,
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

return keys