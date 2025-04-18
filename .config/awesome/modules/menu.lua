

local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

local variables = require("modules.variables")

local menu = {}

-- {{{ Menu
-- Create a launcher widget and a main menu
menu.myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", variables.terminal .. " -e man awesome" }, -- Corrigido
    { "edit config", variables.editor_cmd .. " " .. awesome.conffile }, -- Corrigido
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

menu.mymainmenu = awful.menu({
    items = {
        { "awesome", menu.myawesomemenu, beautiful.awesome_icon },
        { "open terminal", variables.terminal } -- Corrigido
    }
})

menu.mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = menu.mymainmenu
})

-- Menubar configuration
menu.menu_bar = require("menubar")
menu.menu_bar.utils.terminal = variables.terminal -- Set the terminal for applications that require it
-- }}}

return menu