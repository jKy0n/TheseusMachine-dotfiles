--[[
        Title:      keys.lua
        Brief:      Configuration of keybindings for AwesomeWM
        Path:       /home/jkyon/.config/awesome/modules/keys.lua
        Author:     John Kennedy a.k.a. jKyon
        Created:    2025-07-13
        Updated:    2026-06-29
        Notes:
                Custom keybindings for AwesomeWM.
                Provides a set of global and client-specific keybindings to enhance user interaction and workflow.
                Atalhos personalizados para o AwesomeWM.
                Fornece um conjunto de atalhos globais e específicos do cliente para melhorar a interação do usuário
                e o fluxo de trabalho.
--]]


------------------------------------------------------------------------------------
---------------------------------  Load Libraries  ---------------------------------

local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local gears = require("gears")
local tags_utils = require("modules.tags_utils")

local volume_widget = require("awesome-wm-widgets.wpctl-widget.volume")

------------------------------------------------------------------------------------
----------------------------------  Keys Module  -----------------------------------

local keys = {
    globalkeys = globalkeys,
    clientkeys = clientkeys
}

------------------------------------------------------------------------------------
-------------------------------  Global keybindings  -------------------------------

globalkeys = gears.table.join(

------------------------------------------------------------------------------------
------------------------------- awesome Control Keys -------------------------------

-- Help pop-up for theses keys below = Super + S
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
            {description="show help", group="awesome"}),

-- Restart awesome (if needed) = Super + Control + R
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

-- Lock screen = Super + Control + Escape
    -- awful.key({ modkey, "Control" }, "Escape", function () awful.util.spawn("light-locker-command -l") end),

-- Unminimize client (show all minimized clients) = Super + Control + N
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


------------------------------------------------------------------------------------
-------------------------------  Focus Change Keys  --------------------------------

-- Focus change to Right (Next) = Super + K
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),

-- Focus change to Left (previous) = Super + J
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

-- Focus change to Right (Next) Screen = Super + Control + J
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),

-- Focus change to Left (Previous) Screen = Super + Control + K
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),


-- Focus change to urgent client = Super + U
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),


------------------------------------------------------------------------------------
----------------------------  Layout Manipulation Keys  ----------------------------

-- Layout change to next = Super + Space
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1) end,
        {description = "select next", group = "layout"}),

-- Layout change to previous = Super + Shift + Space
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end,
        {description = "select previous", group = "layout"}),


-- Client Swap to Right (Next) = Super + Shift + K
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  1) end,
        {description = "swap with next client by index", group = "client"}),

-- Client Swap to Left (Previous) = Super + Shift + J
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx( -1) end,
        {description = "swap with previous client by index", group = "client"}),


------------------------------------------------------------------------------------
---------------------------------- Terminal Keys -----------------------------------

-- Terminal (with tmux) = Super + Return
    awful.key({ modkey, }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal (with tmux)", group = "launcher"}),

-- Terminal Floating (without tmux) = Super + Shift + Enter
    awful.key({ modkey, "Shift" }, "Return", function ()
                awful.spawn.with_shell("NO_TMUX=1 alacritty --class floating-terminal") end,
            {description = "open a quick floating terminal", group = "launcher"}),

-- Terminal Floating (without tmux) = Super + Control + Enter
    awful.key({ modkey, "Control" }, "Return", function ()
                awful.spawn.with_shell( "NO_TMUX=1 alacritty" ) end,
              {description = "open a terminal without tmux", group = "launcher"}),


------------------------------------------------------------------------------------
-------------------------------- Tags Manipulation ---------------------------------

-- Tag return to previous tag = Super + Escape
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
            {description = "go back", group = "tag"}),


-- Tag change to Right (next) = Super + Right
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
                {description = "view next", group = "tag"}),
-- Tag change to Left (previous) = Super + Left
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),


-- Tag Increase mastrer size = Super + L
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
-- Tag decrease mastrer size = Super + H
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),


-- Tag increase the number of master clients = Super + Shift + H
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
-- Tag decrease the number of master clients = Super + Shift + L
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),


-- Tag increase the number of columns = Super + Control + H
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
-- Tag decrease the number of columns = Super + Control + L
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),


-- Create new tag = Super + A
    awful.key({ modkey,           }, "a", tags_utils.add_tag,
        {description = "add a tag", group = "tag"}),

-- Delete the current tag = Super + Alt + A
    awful.key({ modkey, "Mod1"   }, "a", tags_utils.delete_tag,
        {description = "delete the current tag", group = "tag"}),

-- Rename the current tag = Super + Shift + R
    awful.key({ modkey, "Shift"   }, "r", tags_utils.rename_tag,
        {description = "rename the current tag", group = "tag"}),

-- Create new tag with current window = Super + Control + A
    awful.key({ modkey, "Control"   }, "a", tags_utils.move_to_new_tag,
        {description = "add a tag with the focused client", group = "tag"}),


------------------------------------------------------------------------------------
----------------------------------- Prompt Keys ------------------------------------

-- Prompt = Super + R
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

-- Prompt a Lua code = Super + X
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


------------------------------------------------------------------------------------
-------------------------------- Rofi Launcher Keys --------------------------------

-- Rofi Launcher = Super + P
    awful.key({ modkey, }, "p",
        function () awful.util.spawn("rofi  -config /home/jkyon/.config/rofi/config.rasi \
                                            -modes \"drun,run,file-browser-extended,window,emoji,calc\" -show drun \
                                            -theme /home/jkyon/.config/rofi/theme.rasi")
            end,
            {description = "show rofi launcher", group = "launcher"}),


-- Rofi Recoll = Super + I
    awful.key({ modkey, }, "i",
        function () awful.util.spawn("rofi -config /home/jkyon/.config/rofi/config.rasi \
                                        -modi \"recoll:/home/jkyon/.config/rofi/scripts/recoll\" -show recoll \
                                        -theme /home/jkyon/.config/rofi/theme-recoll.rasi")
        end,
        {description = "show rofi recoll", group = "launcher"}),


-- Rofi Emojis = Super + O
    awful.key({ modkey, }, "o",
        function () awful.util.spawn("rofi  -config /home/jkyon/.config/rofi/config.rasi \
                                            -modes \"drun,emoji\" -show emoji \
                                            -emoji-format \"<span font_family=\'NotoColorEmoji\' size=\'xx-large\'>{emoji}</span>  <span weight=\'bold\'>{name}</span>\" \
                                            -theme /home/jkyon/.config/rofi/theme-emoji.rasi")
            end,
            {description = "show rofi emojis", group = "launcher"}),


-- Rofi Task Switcher = Super + Tab
    awful.key({ modkey, }, "Tab",
        function () awful.util.spawn("rofi  -config /home/jkyon/.config/rofi/config.rasi \
                                            -show window \
                                            -window-format \"{t}\" \
                                            -kb-row-down 'Alt+Tab,Alt+Down,Down' \
                                            -kb-row-up 'Alt+ISO_Left_Tab,Alt+Up,Up' \
                                            -kb-accept-entry '!Alt-Tab,!Alt+Down,!Alt+ISO_Left_Tab,!Alt+Up,Return' \
                                            -me-select-entry 'MouseSecondary' \
                                            -me-accept-entry 'MousePrimary' \
                                            -show-icons -theme /home/jkyon/.config/rofi/theme-tab.rasi")
            end,
            {description = "show rofi task switcher", group = "launcher"}),


------------------------------------------------------------------------------------
----------------------------  Applications keybindings  ----------------------------

-- File Manager (Dolphin) = super + E
    awful.key({ modkey, }, "e", function () awful.util.spawn("dolphin") end,
        {description = "open file manager", group = "launcher"}),

-- Web Browser (Firefox) = super + W
    awful.key({ modkey, }, "w", function () awful.util.spawn("firefox") end,
        {description = "open web browser", group = "launcher"}),

-- Code Editor (Visual Studio Code) = super + V
    awful.key({ modkey, }, "v", function () awful.util.spawn("code")    end,
        {description = "open code editor", group = "launcher"}),

-- Calculator (Gnome Calculator) = super + C
    awful.key({ modkey, }, "c", function () awful.util.spawn("gnome-calculator")    end,
        {description = "open calculator", group = "launcher"}),


------------------------------------------------------------------------------------
---------------------------  Startup usual Applications  ---------------------------

-- Startup All Applications = Super + Shift + Pause
    awful.key({ modkey, "Shift" }, "Pause", function () require("scripts.autostart").run() end,
        {description = "open viamar pc startup apps", group = "launcher"})
)

------------------------------------------------------------------------------------
----------------------------------  Client Keys  -----------------------------------

clientkeys = gears.table.join(

------------------------------------------------------------------------------------
-------------------------------  Audio Control Keys  -------------------------------

-- Increase volume
    awful.key({}, "XF86AudioRaiseVolume", function() volume_widget:inc(5) end),
-- Decrease volume
    awful.key({}, "XF86AudioLowerVolume", function() volume_widget:dec(5) end),

-- Togglw Mute
    awful.key({}, "XF86AudioMute", function() volume_widget:toggle() end),

-- Play song
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause") end),
-- Stop song
    awful.key({}, "XF86AudioStop", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause") end),

-- Previous song
    awful.key({}, "XF86AudioPrev", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous") end),
-- Next song
    awful.key({}, "XF86AudioNext", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next") end),


------------------------------------------------------------------------------------
--------------------------------  Screenshot Keys  ---------------------------------

-- Screenshot selected region = Print Screen
    awful.key({}, "Print", function()
        awful.spawn.with_shell("maim -s | satty --filename - --copy-command 'xclip -selection clipboard -t image/png'")
    end),

-- Screenshot selected region and save to clipboard = Ctrl + Shift + Print Screen
    awful.key({ "Control", "Shift" }, "Print", function()
        awful.spawn.with_shell("maim -s | xclip -selection clipboard -t image/png")
    end),

-- Open satty GUI (all screen) = Super + Print Screen
    awful.key({ modkey }, "Print", function()
        awful.spawn.with_shell("maim | satty --filename - --copy-command 'xclip -selection clipboard -t image/png'")
    end),


------------------------------------------------------------------------------------
------------------------------  Client Function Keys  ------------------------------

-- Lock Screen = Super + Control + Escape
    -- awful.key({ modkey, "Control" }, "Escape", function () awful.util.spawn("light-locker-command --lock") end),

-- Centralize window = Super + Shift + O
    awful.key({ modkey, "Shift" }, "o", function()
        if client.focus then
            awful.placement.centered(client.focus, { honor_workarea = true })
        end
    end, {description = "centralize window", group = "client"}),

-- Quit/close Client = Super + Alt + Q
    awful.key({ modkey, "Mod1"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),

-- Toggle floating orientation client = Super + Control + Space
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),

-- Move client do master = Super + Control + Shift + Return
            awful.key({ modkey, "Control", "Shift" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
            {description = "move to master", group = "client"}),

-- Keep on top toggle client = Super + T
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),

-- Client minimize (hide from view) = Super + N
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

-- Client (un)maximize - Super + M
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),

-- Client (un)maximize vertically - Super + Control + M
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),

-- Client (un)maximize horizontally - Super + Shift + M
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),

-- Client fullscreen toggle - Super + F
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"})
)

------------------------------------------------------------------------------------
------------------------------  Keybinds by Numebers  ------------------------------

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,

-- View tag only = Super + {number}
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),

-- Toggle tag display = Super + Control + {number}
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),

-- Move client to tag = Super + Shift + {number}
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

-- Toggle tag on focused client = Super + Control + Shift + {number}
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