



local awful = require("awful")

local tags_utils = {}

-- Adicionar uma nova tag
function tags_utils.add_tag()
    awful.tag.add(" NewTag ", {
        screen = awful.screen.focused(),
        layout = awful.layout.suit.tile,
        volatile = true
    }):view_only()
end

-- Excluir a tag selecionada
function tags_utils.delete_tag()
    local t = awful.screen.focused().selected_tag
    if not t then return end
    t:delete()
end

-- Renomear a tag selecionada
function tags_utils.rename_tag()
    awful.prompt.run {
        prompt       = "New tag name: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end

            local t = awful.screen.focused().selected_tag
            if t then
                t.name = new_name
            end
        end
    }
end

-- Mover o cliente para uma nova tag
function tags_utils.move_to_new_tag()
    local c = client.focus
    if not c then return end

    local t = awful.tag.add(c.class, {
        screen = c.screen,
        layout = awful.layout.suit.tile,
        volatile = true
    })
    c:tags({t})
    t:view_only()
end

-- Encontrar uma tag pelo nome
function tags_utils.find_tag_by_name(screen, name)
    for _, tag in ipairs(screen.tags) do
        if tag.name:match(name) then
            return tag
        end
    end
    return nil
end

-- Criar uma tag volátil
function tags_utils.create_volatile_tag(c, tag_name, screen_index, layout)
    local screen = screen[screen_index]
    local existing_tag = tags_utils.find_tag_by_name(screen, tag_name)
    if existing_tag then
        c:move_to_tag(existing_tag)
        existing_tag:view_only()
    else
        local new_tag = awful.tag.add(tag_name, {
            screen = screen,
            layout = layout,
            volatile = true,
        })
        local tag_index = new_tag.index
        new_tag.name = tag_name .. "(" .. tag_index .. ") "
        c:move_to_tag(new_tag)
        new_tag:view_only()
    end
end

return tags_utils