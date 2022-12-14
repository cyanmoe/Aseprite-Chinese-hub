--[[
    Record v3.x - Command Palette
    License: MIT
    Website: https://sprngr.itch.io/aseprite-record
    Source: https://github.com/sprngr/aseprite-record
]]

dofile(".lib/record-core.lua")

local snapshot = Snapshot.new()

local function take_snapshot()
    snapshot:update_sprite()
    if not snapshot:is_valid() then
        return
    end
    snapshot:save()
end

local function open_time_lapse()
    snapshot:update_sprite()
    if not snapshot:is_valid() then
        return
    end

    local path = snapshot:get_recording_image_path(0)
    if app.fs.isFile(path) then
        app.command.OpenFile { filename = path }
    else
        show_error(error_messages.snapshot_required)
    end
end

if check_api_version() then
    local main_dialog = Dialog {
        title = "Record - 命令选项板"
    }

    -- Creates the main dialog box
    main_dialog:button {
        text = "拍摄快照",
        onclick = function()
            take_snapshot()
        end
    }
    main_dialog:button {
        text = "开启延时摄影",
        onclick = function()
            open_time_lapse()
        end
    }
    main_dialog:show { wait = false }
end
