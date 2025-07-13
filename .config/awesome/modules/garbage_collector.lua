

local gears = require("gears")


local garbage_collector = {}


-- Run garbage collector regularly to prevent memory leaks
gears.timer {
    timeout = 30,
    autostart = true,
    callback = function() collectgarbage() end
}

return garbage_collector