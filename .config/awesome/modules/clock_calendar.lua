



local wibox = require("wibox")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")

local clock_calendar = {}

-- Criar o widget de relógio
clock_calendar.mytextclock = wibox.widget.textclock(' %a, %d %b - %H:%M ', 60)

-- Configurar o widget de calendário
local cw = calendar_widget({
    theme = 'naughty',
    placement = 'top_right',
    start_sunday = false,
    radius = 8,
    previous_month_button = 1,
    next_month_button = 3,
})

-- Conectar o calendário ao relógio
clock_calendar.mytextclock:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then cw.toggle() end
end)

return clock_calendar