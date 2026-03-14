--[[
--       Title:      wallpaper.lua
--       Brief:      Configuração do wallpaper
--       Path:       /home/jkyon/.config/awesome/modules/wallpaper.lua
--       Author:     John Kennedy a.k.a. jKyon
--       Created:    2026-03-14
--       Updated:    2026-03-14
--       Notes:      Reduzir isso depois
--]]


local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local wallpaper = {}

local function get_wallpaper_image()
   if type(beautiful.wallpaper) == "function" then
      return beautiful.wallpaper(screen.primary)
   end

   return beautiful.wallpaper
end

local function get_wallpaper_surface()
   local image = get_wallpaper_image()

   if not image then
      return nil
   end

   local width, height = root.size()
   local surface = image

   if type(image) == "string" then
      surface = gears.surface.load_uncached(image)
   end

   return gears.surface.crop_surface {
      surface = surface,
      ratio = width / height,
   }
end

local wallpaper_widget = wibox.widget {
   image = get_wallpaper_surface(),
   resize = true,
   upscale = true,
   downscale = true,
   widget = wibox.widget.imagebox,
}

local global_wallpaper = awful.wallpaper {
   screens = screen,
   bg = beautiful.bg_normal,
   widget = wallpaper_widget,
}

screen.connect_signal("request::wallpaper", function()
   wallpaper_widget.image = get_wallpaper_surface()
   global_wallpaper.screens = screen
end)


return wallpaper