local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local variables = {}

-- Tema
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/jkyon/theme.lua")

-- Terminal e editor
variables.terminal = "alacritty"
variables.editor = os.getenv("EDITOR") or "nvim"
variables.editor_cmd = variables.terminal .. " -e " .. variables.editor

-- Modkey (tecla modificadora)
variables.modkey = "Mod4"

-- Keyboard map indicator and switcher
variables.mykeyboardlayout = awful.widget.keyboardlayout()

return variables