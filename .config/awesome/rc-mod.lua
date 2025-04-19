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
local notify_manager = require("modules.notify_manager")
local wallpaper_manager = require("modules.wallpaper_manager")
local prompt_manager = require("modules.prompt_manager")
local taglist_buttons = require("modules.taglist_buttons")
local tasklist_buttons = require("modules.tasklist_buttons")
local wibox_manager = require("modules.wibox_manager")
local signals = require("modules.signals")
local keys = require("modules.keys")
local rules = require("modules.rules")
local tags_manager = require("modules.tags_manager")
require("modules.signals")
local clock_calendar = require("modules.clock_calendar")

-- }}}

-- {{{ Configurações Globais
terminal = variables.terminal
editor = variables.editor
editor_cmd = variables.editor_cmd
modkey = variables.modkey

-- Configurar layouts
awful.layout.layouts = layouts.list

-- Configurar menu e launcher
mylauncher = menu.mylauncher
menubar.utils.terminal = terminal -- Configurar terminal para o Menubar

-- Widgets globais
mytextclock = clock_calendar.mytextclock
mykeyboardlayout = variables.mykeyboardlayout
-- }}}

-- {{{ Configuração de Telas e Widgets
-- Configurar as tags
tags_manager.create(s)

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
        buttons = tasklist_buttons,
        style   = {
            shape  = gears.shape.rounded_bar,
       },
    }

    -- Configurar Wallpaper
    wallpaper_manager.set(s)

    -- Criar a Wibox
    wibox_manager.create(s, mylauncher, mykeyboardlayout, mytextclock)
end)
-- }}}

-- {{{ Configuração de Atalhos e Regras
root.keys(keys.globalkeys)
awful.rules.rules = rules.rules
-- }}}

-- {{{ Inicialização
-- Executar comandos de inicialização
awful.spawn.with_shell("sh /home/jkyon/.config/awesome/autorun.sh")
-- }}}