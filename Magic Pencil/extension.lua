local MagicPencil = dofile("./magicPencil.lua")

function init(plugin)
    plugin:newCommand{
        id = "MagicPencil",
        title = "魔法铅笔",
        group = "edit_fill",
        onenabled = function() return app.activeSprite ~= nil end,
        onclick = function() MagicPencil:Execute() end
    }
end

function exit(plugin) end
