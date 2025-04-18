-- {{{ Bibliotecas e Configurações Iniciais
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
-- }}}

-- {{{ Tratamento de Erros
require("modules.error_handling")
-- }}}

-- {{{ Importação de Módulos
local variables = require("modules.variables")
local layouts = require("modules.layouts")
local menu = require("modules.menu")
local wallpaper_manager = require("modules.wallpaper_manager")
local prompt_manager = require("modules.prompt_manager")
local taglist_buttons = require("modules.taglist_buttons")
local tasklist_buttons = require("modules.tasklist_buttons")
local wibox_manager = require("modules.wibox_manager")
local keys = require("modules.keys")
local rules = require("modules.rules")
require("modules.signals")
-- }}}

-- {{{ Configurações Globais
terminal = variables.terminal
editor = variables.editor
editor_cmd = variables.editor_cmd
modkey = variables.modkey

awful.layout.layouts = layouts.list
mylauncher = menu.mylauncher
menubar.utils.terminal = terminal -- Configurar terminal para o Menubar
mytextclock = wibox.widget.textclock()
-- }}}

-- {{{ Configuração de Telas e Widgets
awful.screen.connect_for_each_screen(function(s)
    -- Configurar o promptbox e layoutbox
    prompt_manager.create(s)

    -- Configurar Taglist
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Configurar Tasklist
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Configurar Wallpaper
    wallpaper_manager.set(s)

    -- Criar a Wibox
    wibox_manager.create(s)
end)
-- }}}

-- {{{ Configuração de Atalhos e Regras
root.keys(keys.globalkeys)
awful.rules.rules = rules.rules
-- }}}