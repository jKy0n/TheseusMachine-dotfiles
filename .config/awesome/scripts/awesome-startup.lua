--[[
--       Title:      awesome-startup.lua
--       Brief:      Script de inicialização para o Awesome WM
--       Path:       /home/jkyon/.config/awesome/scripts/awesome-startup.lua
--       Author:     John Kennedy a.k.a. jKyon
--       Created:    2025-03-04
--       Updated:    2026-03-14
--       Notes:      Inicializa os terminais nas tags corretas em cada monitor
--]]



local awful = require("awful")


-- Cada spawn abre uma janela separada; use once para nao duplicar ao reiniciar o Awesome.
-- Em Awesome, screens sao indexadas em 1, 2, 3... (0 e invalido).
-- Abre htop no monitor 3, tag 1
awful.spawn("alacritty -e htop", {tag = screen[2].tags[1]})

-- -- Abre btop e tmux no monitor 1, tag 1
awful.spawn("alacritty -e btop", {tag = screen[1].tags[1]})
awful.spawn("alacritty -e tmux", {tag = screen[1].tags[1]})

-- -- Abre radeontop e sensors-watch no monitor 2, tag 1
awful.spawn("alacritty -e radeontop --color --transparency", {tag = screen[3].tags[1]})
awful.spawn("alacritty -e nice --adjustment=19 watch --color --interval 1 sensors", {tag = screen[3].tags[1]})

-- Abre ssh para viamar-pc e crisnote no monitor 1, tag 2
awful.spawn("alacritty -e ssh crisnote", {tag = screen[1].tags[2]})
awful.spawn("alacritty -e ssh viamar-pc", {tag = screen[1].tags[2]})
