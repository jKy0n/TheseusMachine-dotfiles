
local awful = require("awful")


local tags = {}

awful.tag.add(" emerge (1) ", {
    layout = awful.layout.suit.tile.left,
    screen = 1,
    selected = false
})

awful.tag.add(" Code (2) ", {
    layout = awful.layout.suit.tile.left,
    screen = 1,
    selected = true
})

awful.tag.add(" Mail (3) ", {
    layout = awful.layout.suit.tile,
    screen = 1,
    selected = false
})

awful.tag.add(" Notes (4) ", {
    layout = awful.layout.suit.tile.left,
    screen = 1,
    selected = false
})

awful.tag.add(" Finances (5) ", {
    layout = awful.layout.suit.tile.left,
    screen = 1,
    selected = false
})

awful.tag.add(" Goddess (6) ", {
    layout = awful.layout.suit.tile.bottom,
    screen = 1,
    selected = false
})

awful.tag.add(" Telegram (7) ", {
    layout = awful.layout.suit.tile.bottom,
    screen = 1,
    selected = false
})


    ------------------ Second Monitor ------------------


awful.tag.add(" Monitor (1) ", {
layout = awful.layout.suit.tile.bottom,
screen = 2,
selected = true
})

awful.tag.add(" Chat (2) ", {    
layout = awful.layout.suit.tile.bottom,
screen = 2,
selected = false
})

awful.tag.add(" Sound (3) ", {
layout = awful.layout.suit.tile.bottom,
screen = 2,
selected = false
})


    ------------------ Third Monitor ------------------


awful.tag.add(" Monitor (1) ", {
    layout = awful.layout.suit.tile,
    screen = 3,
    selected = false
})

awful.tag.add(" Search (2) ", {
    layout = awful.layout.suit.tile,
    screen = 3,
    selected = true
})

awful.tag.add(" Media (3) ", {
    layout = awful.layout.suit.tile,
    screen = 3,
    selected = false
})


return tags