


local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local variables = {}

-- Tema
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Terminal e editor
variables.terminal = "alacritty"
variables.editor = os.getenv("EDITOR") or "nvim"
variables.editor_cmd = variables.terminal .. " -e " .. variables.editor

-- Modkey (tecla modificadora)
variables.modkey = "Mod4"

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

return variables