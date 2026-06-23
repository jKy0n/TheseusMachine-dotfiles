--[[
	    Title:      autostart.lua
	    Brief:      Script de inicialização para o Awesome WM
	    Path:       /home/jkyon/.config/awesome/scripts/autostart.lua
	    Author:     John Kennedy a.k.a. jKyon
	    Created:    2025-03-04
	    Updated:    2026-06-23
	    Notes:      Inicializa os terminais nas tags corretas em cada monitor.
	                Uso: require("scripts.autostart").run()
--]]

local awful = require("awful")

local M = {}

-- Caminho para o script de inicialização dos aplicativos
local start_apps_script = "/home/jkyon/.config/awesome/scripts/apps-autostart.sh"

-- Helper: retorna a tag de um screen/tag index, ou nil se não existir
local function get_tag(screen_idx, tag_idx)
	local s = screen[screen_idx]
	if s and s.tags then
		return s.tags[tag_idx]
	end
	return nil
end

function M.run()
	-- Define tamanho das tags para os monitores 1 e 3, onde as janelas de monitoramento serão abertas.
	local screen_1_tag_1 = get_tag(1, 1)
	if screen_1_tag_1 then
		screen_1_tag_1.master_width_factor = 0.55
		screen_1_tag_1.master_count = 1
	end

	local screen_3_tag_1 = get_tag(3, 1)
	if screen_3_tag_1 then
		screen_3_tag_1.master_width_factor = 0.65
		screen_3_tag_1.master_count = 1
	end

	-- Cada spawn abre uma janela separada.
	-- Em Awesome, screens sao indexadas em 1, 2, 3... (0 e invalido).

	-- Monitor 2: Tag 1 - htop
	local s2t1 = get_tag(2, 1)
	if s2t1 then
		awful.spawn("alacritty -e htop", {tag = s2t1})
	end

	-- Monitor 1: Tag 1 - btop e tmux
	if screen_1_tag_1 then
		awful.spawn("alacritty -e /home/jkyon/.config/awesome/scripts/tmux-autostart.sh", {tag = screen_1_tag_1})
		awful.spawn("alacritty -e btop", {tag = screen_1_tag_1})
	end

	-- Monitor 1: Tag 2 - ssh para Viamar-PC + CrisNote + Builder
	local s1t2 = get_tag(1, 2)
	if s1t2 then
		awful.tag.incnmaster(-1, nil, true)
		awful.spawn("alacritty -e ssh crisnote", {tag = s1t2})
		awful.spawn("alacritty -e ssh viamar-pc", {tag = s1t2})
		awful.spawn("alacritty -e ssh builder", {tag = s1t2})
	end

	-- Monitor 3: Tag 1 - radeontop e sensors-watch
	if screen_3_tag_1 then
		awful.spawn("alacritty -e nice --adjustment=19 watch --color --interval 2 --differences sensors", {tag = screen_3_tag_1})
		awful.spawn("alacritty -o font.size=20 -e radeontop --color --transparency", {tag = screen_3_tag_1})
	end

	awful.spawn(start_apps_script)
end

return M