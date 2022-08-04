ScaleDialog = dofile("./scale/ScaleDialog.lua");
TweenDialog = dofile("./tween/TweenDialog.lua");
ColorAnalyzerDialog = dofile("./color-analyzer/ColorAnalyzerDialog.lua");

function init(plugin)
    plugin:newCommand{
        id = "advanced-scaling",
        title = "高级缩放",
        group = "sprite_size",
        onenabled = function() return app.activeSprite ~= nil end,
        onclick = function()
            -- Check is UI available
            if not app.isUIAvailable then return end

            local dialog = ScaleDialog("高级缩放")
            dialog:show{wait = false}
        end
    }

    plugin:newCommand{
        id = "add-inbetween-frame",
        title = "添加中间帧",
        group = "cel_delete",
        onenabled = function() return app.activeSprite ~= nil end,
        onclick = function()
            -- Check is UI available
            if not app.isUIAvailable then return end

            local dialog = TweenDialog("添加中间帧")
            dialog:show{wait = true}
        end
    }

    plugin:newCommand{
        id = "color-analyzer",
        title = "分析颜色",
        group = "sprite_color",
        onenabled = function() return app.activeSprite ~= nil end,
        onclick = function()
            -- Check are UI and sprite available
            if not app.isUIAvailable then return end
            if app.activeSprite == nil then return end

            ColorAnalyzerDialog:Create("分析颜色")
            ColorAnalyzerDialog:Show()
        end
    }
end

function exit(plugin) end

