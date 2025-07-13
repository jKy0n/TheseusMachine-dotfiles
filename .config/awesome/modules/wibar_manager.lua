


local awful = require("awful")
local gears = require("gears")
local wibar = require("modules.wibar")


local wibar_manager = {}


function wibar_manager.setup(taglist_buttons, tasklist_buttons)


    awful.screen.connect_for_each_screen(function(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))


    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = {
             shape  = gears.shape.rounded_bar,
        },
   }

   

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------


    -- Create the wibox monitor 1
    s.mywibox = awful.wibar({   position = "top", 
                                screen = s, 
                                opacity = 0.8, 
                                border_width = 3, 
                                shape = gears.shape.rounded_rect 
    })

-------------------------------------------------------------------------------------
----------------------------------  Wibox 1  ----------------------------------------
-------------------------------------------------------------------------------------

    -- add widgets to the wibox
    wibar.setup(s)

    end)
end

return wibar_manager