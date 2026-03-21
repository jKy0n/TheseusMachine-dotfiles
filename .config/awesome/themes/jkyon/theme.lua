--[[
--       Title:      theme.lua
--       Brief:      Tema personalizado para AwesomeWM, baseado na paleta de cores do tema Catppuccinno Frappé
--       Path:       /home/jkyon/.config/awesome/themes/jkyon/theme.lua
--       Author:     John Kennedy a.k.a. jKyon
--       Created:    2025-03-04
--       Updated:    2026-03-19
--       Notes:
--]]


-- local beautiful = require("beautiful")
-- local theme_assets = require("beautiful.theme_assets")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local color_palette = require("themes.jkyon.color_palette")

-------------------------------------------------------
---------- Variáveis de configuração do tema ----------

local font = "MesloLGS Nerd Font Bold 8"

local wallpaper = "/home/jkyon/Pictures/Wallpapers/LinuxWallpapers/BlueNebula8K.jpg"

-------------------------------------------------------
------------------------ Theme ------------------------

local theme = {}

-- fonte do Awesome --
theme.font              =   font

-- Basicamente bg é fundo e fg é texto --
-- Cor de fundo da Wibar --
theme.bg_normal         =   color_palette.base
theme.bg_focus          =   color_palette.blue
theme.bg_urgent         =   color_palette.red
theme.bg_minimize       =   color_palette.crust
theme.bg_systray        =   color_palette.base

-- Cor do texto da Wibar --
theme.fg_normal         =   color_palette.text
theme.fg_focus          =   color_palette.mantle
theme.fg_urgent         =   color_palette.mantle
theme.fg_minimize       =   color_palette.overlay0

-- Cor da borda das janelas/Clients --
theme.border_normal     =   color_palette.mantle
theme.border_focus      =   color_palette.blue
theme.border_active     =   color_palette.blue
theme.border_marked     =   color_palette.red

-- Cor do texto dos Tags --
theme.taglist_fg_empty  =   color_palette.overlay0

-- Tamanho do gap entre as janelas --
theme.useless_gap       =   dpi(2)

-- Tamanho da borda das janelas --
theme.border_width      =   dpi(3)

-- Cantos arredondados para a taglist e notificações --
theme.taglist_shape = gears.shape.rounded_rect
theme.notification_shape = gears.shape.rounded_rect

-- Ícones dos layouts --
theme.layout_floating   =   themes_path.."default/layouts/floatingw.png"
theme.layout_max        =   themes_path.."default/layouts/maxw.png"
theme.layout_tile       =   themes_path.."default/layouts/tilew.png"
theme.layout_tileleft   =   themes_path.."default/layouts/tileleftw.png"
theme.layout_tiletop    =   themes_path.."default/layouts/tiletopw.png"
theme.layout_tilebottom =   themes_path.."default/layouts/tilebottomw.png"

-- Wallpaper --
theme.wallpaper = wallpaper

return theme