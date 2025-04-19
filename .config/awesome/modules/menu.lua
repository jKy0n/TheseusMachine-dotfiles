local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

local variables = require("modules.variables")

local menu = {}

-- {{{ Menu
menu.myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", variables.terminal .. " -e man awesome" },
    { "edit config", variables.editor_cmd .. " " .. (awesome.conffile or "~/.config/awesome/rc.lua") },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

menu.mymainmenu = awful.menu({
    items = {
        { "awesome", menu.myawesomemenu, beautiful.awesome_icon or default_icon },
        { "open terminal", variables.terminal }
    }
})

menu.mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon or default_icon,
    menu = menu.mymainmenu
})

menu.menu_bar = require("menubar")
menu.menu_bar.utils.terminal = variables.terminal

return menu