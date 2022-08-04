ControlsDialog = dofile("./ControlsDialog.lua");

function init(plugin)
    plugin:newCommand{
        id = "on-screen-controls",
        title = "On-Screen Controls",
        group = "view_controls",
        onclick = function()
            ControlsDialog:Create("屏幕控件", plugin.preferences,
                                  function(newPreferences)
                plugin.preferences = newPreferences;
            end);
            ControlsDialog:Show();
        end
    }
end

function exit(plugin) end

