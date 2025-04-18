


local beautiful = require("beautiful")
local gears = require("gears")

local wallpaper_manager = {}

-- Função para definir o papel de parede
function wallpaper_manager.set(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wp = beautiful.wallpaper
        -- Se o wallpaper for uma função, chamá-la com a tela
        if type(wp) == "function" then
            wp = wp(s)
        end
        gears.wallpaper.maximized(wp, s, true)
    end
end

-- Reconectar o papel de parede quando a geometria da tela mudar
screen.connect_signal("property::geometry", wallpaper_manager.set)

return wallpaper_manager