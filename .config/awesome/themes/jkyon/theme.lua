---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local gears = require("gears")
local beautiful = require("beautiful")

local theme = {}

-- fonte do Awesome --
theme.font              =   "MesloLGS Nerd Font Bold 8"

-- Basicamente bg é fundo e fg é texto --
-- Cor de fundo da Wibar --
theme.bg_normal         =   "#1e2030"
theme.bg_focus          =   "#8aadf4"
theme.bg_urgent         =   "#ed8796"
theme.bg_minimize       =   "#181926"
theme.bg_systray        =   theme.bg_normal

-- Cor do texto da Wibar --
theme.fg_normal         =   "#cad3f5"
theme.fg_focus          =   "#1e2030"
theme.fg_urgent         =   "#1e2030"
theme.fg_minimize       =   "#6e738d"

-- Cor da borda das janelas/Clients --
theme.border_normal     =   "#1e2030"
theme.border_focus      =   "#8aadf4"
theme.border_active     =   "#8aadf4"
theme.border_marked     =   "#ed8796"

-- Cor do texto dos Tags --
theme.taglist_fg_empty  =   "#6e738d"

-- Tamanho do gap entre as janelas --
theme.useless_gap       =   dpi(2)

-- Tamanho da borda das janelas --
theme.border_width      =   dpi(3)


-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)


-- You can use your own layout icons like this:
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"


theme.taglist_shape = gears.shape.rounded_rect
theme.notification_shape = gears.shape.rounded_rect

return theme