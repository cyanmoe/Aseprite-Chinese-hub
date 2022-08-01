local EXPORT_DIALOG_WIDTH = 540

local ThemeEncoder = dofile("./Base64Encoder.lua")

local ThemeManager = {storage = nil}

function ThemeManager:Init(options) self.storage = options.storage end

function ThemeManager:SetCurrentTheme(theme)
    local code = ThemeEncoder:EncodeSigned(theme.name, theme.parameters,
                                           theme.colors)

    if code then self.storage.currentTheme = code end
end

function ThemeManager:GetCurrentTheme()
    if self.storage.currentTheme then
        return ThemeEncoder:DecodeSigned(self.storage.currentTheme)
    end
end

function ThemeManager:Find(name)
    for i, savedthemeCode in ipairs(self.storage.savedThemes) do
        if ThemeEncoder:DecodeName(savedthemeCode) == name then return i end
    end
end

function ThemeManager:Import(code, onimport, onerror)
    local theme = ThemeEncoder:DecodeSigned(code)

    if not theme then
        onerror()
        return
    end

    local isNameUsed = self:Find(theme.name)

    if isNameUsed then
        local overwriteConfirmation = app.alert {
            title = "配置覆盖",
            text = "该名字的配置" .. theme.name ..
                " 已经存在，要覆盖吗？",
            buttons = {"是", "否"}
        }

        if overwriteConfirmation == 1 then
            self.storage.savedThemes[isNameUsed] = code
            onimport()
        end
    else
        table.insert(self.storage.savedThemes, code)
        onimport()
    end
end

function ThemeManager:Save(theme, onsave)
    local confirmation = false

    local saveDialog = Dialog("保存")
    saveDialog --
    :entry{
        id = "name",
        label = "名称",
        text = theme.name,
        onchange = function()
            saveDialog:modify{id = "ok", enabled = #saveDialog.data.name > 0} --
        end
    } --
    :separator() --
    :button{
        id = "ok",
        text = "是",
        enabled = #theme.name > 0,
        onclick = function()
            local isNameUsed = self:Find(saveDialog.data.name)

            if not isNameUsed then
                confirmation = true
                saveDialog:close()
                return
            end

            local overwriteConfirmation = app.alert {
                title = "配置覆盖",
                text = "该名字配置" .. saveDialog.data.name ..
                    " 已经存在，要覆盖吗？",
                buttons = {"是", "否"}
            }

            if overwriteConfirmation == 1 then
                confirmation = true
                saveDialog:close()
            end
        end
    } --
    :button{text = "取消"} --
    :show()

    if confirmation then
        theme.name = saveDialog.data.name
        onsave()

        local code = ThemeEncoder:EncodeSigned(theme.name, theme.parameters,
                                               theme.colors)

        local nameUsed = ThemeManager:Find(theme.name)

        if nameUsed then
            self.storage.savedThemes[nameUsed] = code
        else
            table.insert(self.storage.savedThemes, code)
        end
    end
end

function ThemeManager:Load(onload, onreset)
    local browseDialog = Dialog("加载")

    for index, savedthemeCode in ipairs(self.storage.savedThemes) do
        local theme = ThemeEncoder:DecodeSigned(savedthemeCode)
        local loadButtonId = "saved-theme-load-" .. tostring(index)
        local exportButtonId = "saved-theme-export-" .. tostring(index)
        local deleteButtonId = "saved-theme-delete-" .. tostring(index)

        browseDialog --
        :button{
            id = loadButtonId,
            label = theme.name,
            text = "加载",
            onclick = function()
                local confirmation = app.alert {
                    title = "正加载主题",
                    text = "未保存的更改将丢失，您要继续吗？",
                    buttons = {"是", "否"}
                }

                if confirmation == 1 then
                    browseDialog:close()
                    onload(theme)
                end
            end
        } --
        :button{
            id = exportButtonId,
            text = "导出",
            onclick = function()
                browseDialog:close()
                local isFirstOpen = true

                local exportDialog = Dialog {
                    title = "导出 " .. theme.name,
                    onclose = function()
                        if not isFirstOpen then
                            browseDialog:show()
                        end
                    end
                }
                exportDialog --
                :entry{label = "代码", text = savedthemeCode} --
                :separator() --
                :button{text = "关闭"} --

                -- Open and close to initialize bounds
                exportDialog:show{wait = false}
                exportDialog:close()

                isFirstOpen = false

                local bounds = exportDialog.bounds
                bounds.x = bounds.x - (EXPORT_DIALOG_WIDTH - bounds.width) / 2
                bounds.width = EXPORT_DIALOG_WIDTH
                exportDialog.bounds = bounds

                exportDialog:show()
            end
        } --
        :button{
            id = deleteButtonId,
            text = "删除",
            onclick = function()
                local confirmation = app.alert {
                    title = "删除 " .. theme.name,
                    text = "你确定吗",
                    buttons = {"是", "否"}
                }

                if confirmation == 1 then
                    table.remove(self.storage.savedThemes, index)

                    browseDialog:close()
                    self:Load(onload, onreset)

                    -- browseDialog --
                    -- :modify{id = loadButtonId, visible = false} --
                    -- :modify{id = exportButtonId, visible = false} --
                    -- :modify{id = deleteButtonId, visible = false} --
                    -- :modify{
                    --     id = "separator",
                    --     visible = #self.storage.savedThemes > 0
                    -- }
                end
            end
        }
    end

    if #self.storage.savedThemes > 0 then
        browseDialog:separator{id = "separator"}
    end

    browseDialog --
    :button{
        text = "导入",
        onclick = function()
            browseDialog:close()
            local isFirstOpen = true

            local importDialog = Dialog {
                title = "导入",
                onclose = function()
                    if not isFirstOpen then
                        self:Load(onload, onreset)
                    end
                end
            }
            importDialog --
            :entry{id = "code", label = "代码"} --
            :separator{id = "separator"} --
            :button{
                text = "导入",
                onclick = function()
                    local onimport = function()
                        importDialog:close()
                    end
                    local onerror = function()
                        importDialog:modify{
                            id = "separator",
                            text = "不正确的代码"
                        }
                    end
                    self:Import(importDialog.data.code, onimport, onerror)
                end
            } --
            :button{text = "取消"} --

            -- Open and close to initialize bounds
            importDialog:show{wait = false}
            importDialog:close()

            isFirstOpen = false

            local bounds = importDialog.bounds
            bounds.x = bounds.x - (EXPORT_DIALOG_WIDTH - bounds.width) / 2
            bounds.width = EXPORT_DIALOG_WIDTH
            importDialog.bounds = bounds

            importDialog:show()
        end
    } --
    :button{
        text = "重置为默认",
        onclick = function()
            local confirmation = app.alert {
                title = "重置主题",
                text = "未保存的更改将丢失，您要继续吗？",
                buttons = {"是", "否"}
            }

            if confirmation == 1 then
                browseDialog:close()
                onreset()
            end
        end
    }

    browseDialog --
    :separator() --
    :button{text = "关闭"} --
    :show()
end

return ThemeManager
