


local awful = require("awful")

local layouts = {}

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts.list = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.floating,
}
-- }}}

return layouts