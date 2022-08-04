KeyboardDialog = dofile("./KeyboardDialog.lua")
MenuEntryType = dofile("./NestedMenuEntryType.lua")
NestedMenuDialog = dofile("./NestedMenuDialog.lua")

local ControlsDialog = {dialog = nil, preferences = nil};

function ControlsDialog:ToggleWidgets(toggleId, widgetIds)
    local areVisible = self.dialog.data[toggleId];
    self.preferences[toggleId] = areVisible;

    for _, widgetId in ipairs(widgetIds) do
        self.dialog:modify{id = widgetId, visible = areVisible};
    end
end

function ControlsDialog:Create(dialogTitle, preferences, savePreferences)
    self.preferences = preferences;

    local data = {
        {
            text = "撤销",
            type = MenuEntryType.Action,
            onclick = function() app.command.Undo() end
        }, {
            text = "恢复",
            type = MenuEntryType.Action,
            onclick = function() app.command.Redo() end
        }, {type = MenuEntryType.NewRow}, {
            text = "复制",
            type = MenuEntryType.Action,
            onclick = function() app.command.Copy() end
        }, {
            text = "粘贴",
            type = MenuEntryType.Action,
            onclick = function() app.command.Paste() end
        }, {type = MenuEntryType.NewRow}, {
            text = "剪切",
            type = MenuEntryType.Action,
            onclick = function() app.command.Cut() end
        }, {
            text = "清除",
            type = MenuEntryType.Action,
            onclick = function() app.command.Clear() end
        }, {type = MenuEntryType.NewRow}, {
            text = "取消",
            type = MenuEntryType.Action,
            onclick = function() app.command.Cancel {type = "all"} end
        }, {type = MenuEntryType.Separator}, {
            text = "全选",
            type = MenuEntryType.Action,
            onclick = function()
                app.activeSprite.selection:selectAll()
                app.refresh()
            end
        }, {type = MenuEntryType.Separator}, {
            text = "网格",
            type = MenuEntryType.Submenu,
            data = {
                {
                    text = "切换",
                    type = MenuEntryType.Action,
                    onclick = function()
                        app.command.ShowGrid()
                    end
                }, {
                    text = "捕捉到",
                    type = MenuEntryType.Action,
                    onclick = function()
                        app.command.SnapToGrid()
                    end
                }, {type = MenuEntryType.NewRow}, {
                    text = "设置",
                    type = MenuEntryType.Action,
                    onclick = function()
                        app.command.GridSettings()
                    end
                }
            }
        }, {type = MenuEntryType.Separator}, {
            text = "帧",
            type = MenuEntryType.Submenu,
            data = {
                {
                    text = "|<",
                    type = MenuEntryType.Action,
                    onclick = function()
                        app.command.GotoFirstFrame()
                    end
                }, {
                    text = "<",
                    type = MenuEntryType.Action,
                    onclick = function()
                        app.command.GotoPreviousFrame()
                    end
                }, {
                    text = ">",
                    type = MenuEntryType.Action,
                    onclick = function()
                        app.command.GoToNextFrame()
                    end
                }, {
                    text = ">|",
                    type = MenuEntryType.Action,
                    onclick = function()
                        app.command.GoToLastFrame()
                    end
                }, {type = MenuEntryType.NewRow}, {
                    text = "+",
                    type = MenuEntryType.Action,
                    onclick = function()
                        app.command.NewFrame()
                    end
                }, {
                    text = "-",
                    type = MenuEntryType.Action,
                    onclick = function()
                        app.command.RemoveFrame()
                    end
                }
            }
        }, {type = MenuEntryType.Separator}, {
            text = "图层",
            type = MenuEntryType.Submenu,
            data = {
                {
                    text = "新建",
                    type = MenuEntryType.Action,
                    onclick = function()
                        app.command.NewLayer()
                    end
                }
            }
        }, {type = MenuEntryType.Separator}, {
            text = "保存",
            type = MenuEntryType.Action,
            onclick = function() app.command.SaveFile() end
        }, {type = MenuEntryType.Separator}, {
            text = "快捷命令",
            type = MenuEntryType.Action,
            onclick = function()
                KeyboardDialog:Create()
                KeyboardDialog:Show()
            end
        }
    }

    local onclose = function()
        KeyboardDialog:Close();

        self.preferences.x = self.dialog.bounds.x;
        self.preferences.y = self.dialog.bounds.y;
        savePreferences(self.preferences);
    end

    self.dialog = NestedMenuDialog(dialogTitle, data, onclose)
end

function ControlsDialog:Show()
    self.dialog:show{wait = false}

    if self.preferences.x and self.preferences.y then
        local bounds = self.dialog.bounds
        bounds.x = self.preferences.x
        bounds.y = self.preferences.y
        self.dialog.bounds = bounds
    end
end

return ControlsDialog
