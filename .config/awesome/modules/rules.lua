



local awful = require("awful")
local beautiful = require("beautiful")
local create_volatile_tag = require("modules.tags_utils").create_volatile_tag

local rules = {}


awful.rules.rules = rules

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = custom_focus_filter,
             --      focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
             --      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     placement = awful.placement.centered,
     }
    },

        ---------------------------------------------
        -----------------  My Rules -----------------
        ---------------------------------------------
-- A
--
        { rule = { class = "Alacritty" },
        properties = { titlebars_enabled = false },},

        { rule_any = { class = {"ark"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule_any = { class = {"Arandr"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- B
--

        { rule = { class = "Back In Time" }, -- Altere o class conforme necessário
            properties = { floating = true,
                callback = function(c)
                    create_volatile_tag(c, " BackUp ", 3, awful.layout.suit.tile)
                end,},},
-- C
--
-- D
--
        { rule = { class = "discord" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[2].tags[2],
        },},

        { rule = { class = "dolphin" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- E
--
-- F
--
        { rule = { class = "feh" },
        properties = { floating = true, name = "feh",
        width = 2752,     -- Defina o tamanho que deseja
        height = 1152,    -- Defina o tamanho que deseja
        x = 1424,          -- Posição x
        y = 144,          -- Posição y
        screen = 1  }},
-- G
--
        { rule_any = { class = {"gedit", "Gedit"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule_any = { class = {"gimp", "Gimp"} },
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " GIMP ", 1, awful.layout.suit.tile)
                end,},},

        { rule = { class = "Google-chrome" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[3].tags[3] },},

        { rule = { class = "gnome-calculator" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule_any = { class = {"Gnome-disks", "gnome-disks"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { class = "gpartedbin" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { name = "GPT4All" },
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " LLMs ", 1, awful.layout.suit.tile)
                end,},},

        { rule = { class = "Gnome-screenshot" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- H
--
        { rule_any = { class = {"Heroic Games Launcher", "heroic"} },
        properties = { floating = false,
        placement = awful.placement.centered },},
-- I
--
-- J
--
-- K
--
        { rule = { name = "kclock" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { name = "KDE Connect" },
        properties = { floating = true,
        placement = awful.placement.centered,
        tag = screen[3].tags[1] },},
-- L
--
        { rule_any = { name = {"lm studio", "LM Studio" } },
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " LLMs ", 1, awful.layout.suit.tile)
            end,},},

        { rule = { name = "Lutris" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { class = "Lxappearance" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- M
--
        { rule_any = { class = {"mpv"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { name = "MuPDF" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- N
--
        { rule_any = { class = {"nemo", "Nemo"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- O
--
        { rule = { name = "OBS *" }, -- Altere o class conforme necessário
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " OBS ", 3, awful.layout.suit.tile)
                end,},},

        { rule_any = { class = {"obsidian", "obsidian"} },
        properties = { floating = false,
        tag = screen[1].tags[5]       },},

        { rule = { class = "openrgb" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- P
--
        { rule_any = { class = {"pavucontrol", "Pavucontrol"} },
        properties = { floating = false,
        tag = screen[2].tags[3],
        },},

        { rule = { class = "plasma-emojier" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { class = "PrismLauncher" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule_any = { class = {"ProtonUp-Qt"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule_any = { class = {"pulseeffects", "Pulseeffects"} },
        properties = { floating = false,
        tag = screen[2].tags[3]
        },},
-- Q
--
        { rule = { class = "qt5ct" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { class = "qt6ct" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- R
--
        { rule = { class = "rambox" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[2].tags[2],
        },},
-- S
--
        { rule = { class = "Spotify" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[2].tags[3],
        },},

        { rule_any = { class = {"snappergui", "Snapper-gui"} },
        properties = { floating = true,
        placement = awful.placement.centered,},},

        { rule = { class = "steam" }, -- Altere o class conforme necessário
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " Steam ", 1, awful.layout.suit.tile.left)
            end,},},
-- T
--
        { rule = { class = "teams-for-linux" },
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " Teams ", 3, awful.layout.suit.tile.left)
        end,},},

        { rule_any = { class = {"telegram-desktop", "TelegramDesktop"} },
            properties = { floating = false,
                callback = function(c)
                    create_volatile_tag(c, " telegram ", 3, awful.layout.suit.max)
            end,},},

        { rule = { class = "Thunar" },
        properties = { floating = true, placement = awful.placement.centered },},
        { rule = { class = "thunderbird" },
        properties = { floating = false,
        placement = awful.placement.left,
        tag = screen[1].tags[4] },},

        { rule = { class = "Timeshift" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- U
--
-- V
--

        { rule_any = { class = {"virt-manager", "Virt-manager"} }, -- Altere o class conforme necessário
            properties = { floating = true,
                callback = function(c)
                    create_volatile_tag(c, " VirtManager ", 1, awful.layout.suit.tile.left)
            end,},},

        { rule_any = { class = {"code", "Code"} },     -- vsCode
        properties = { floating = true,
        placement = awful.placement.centered },},
-- W
--
-- X
--
-- Y
--
       { rule = { class = "yakuake" },
       properties = { floating = true, ontop = true, focus = true },
       callback = function(c)
           c:geometry({x=1450, y=25})
           c:connect_signal("unmanage", function() free_focus = true end)
       end },
-- Z
--

}

-- }}}


return rules