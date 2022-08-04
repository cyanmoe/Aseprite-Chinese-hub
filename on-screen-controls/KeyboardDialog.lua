Commands = dofile("./Commands.lua");

local KeyboardDialog = {dialog = nil, commandsDialog = nil, searchText = ""};

function KeyboardDialog:Create()
    self.dialog = Dialog {
        title = "键盘",
        onclose = function()
            self:CloseCommandsDialog();
            self.searchText = "";
        end
    }

    self.dialog:label{id = "textPreview", text = self.searchText}
    self:AddLetterButton("Q")
    self:AddLetterButton("W")
    self:AddLetterButton("E")
    self:AddLetterButton("R")
    self:AddLetterButton("T")
    self:AddLetterButton("Y")
    self:AddLetterButton("U")
    self:AddLetterButton("I")
    self:AddLetterButton("O")
    self:AddLetterButton("P")
    self.dialog:newrow()
    self:AddLetterButton("A")
    self:AddLetterButton("S")
    self:AddLetterButton("D")
    self:AddLetterButton("F")
    self:AddLetterButton("G")
    self:AddLetterButton("H")
    self:AddLetterButton("J")
    self:AddLetterButton("K")
    self:AddLetterButton("L")
    self.dialog:button{
        text = "<",
        onclick = function()
            self:UpdateSearchText(self.searchText:sub(1, -2));
        end
    }
    self.dialog:newrow()
    self:AddLetterButton("")
    self:AddLetterButton("Z")
    self:AddLetterButton("X")
    self:AddLetterButton("C")
    self:AddLetterButton("V")
    self:AddLetterButton("B")
    self:AddLetterButton("N")
    self:AddLetterButton("M")
    self:AddLetterButton("")
    self:AddLetterButton("")

    self.dialog:newrow()
    self.dialog:button{text = "关"}
end

function KeyboardDialog:UpdateSearchText(text)
    self.searchText = text;
    self.dialog:modify{id = "textPreview", text = self.searchText};
    -- TODO: Rename method
    self:RefreshDialogs();
end

function KeyboardDialog:AddLetterButton(letter)
    self.dialog:button{
        text = letter,
        selected = false,
        onclick = function()
            self:UpdateSearchText(self.searchText .. letter)
        end
    }
end

function KeyboardDialog:Show() self.dialog:show{wait = false}; end
function KeyboardDialog:Close() if self.dialog then self.dialog:close() end end

function KeyboardDialog:CreateCommandsDialog(commands)
    self.commandsDialog = Dialog("命令")

    for i, command in ipairs(commands) do
        self.commandsDialog:button{
            id = command,
            text = command,
            onclick = function() app.command[command]() end
        }:newrow();
    end
end

function KeyboardDialog:CloseCommandsDialog()
    if self.commandsDialog then self.commandsDialog:close() end
end

function KeyboardDialog:RefreshDialogs()
    self:CloseCommandsDialog();

    if self.searchText:len() > 0 then
        local availableCommands = Commands:Search(self.searchText);

        if #availableCommands > 0 then
            self:CreateCommandsDialog(availableCommands)
            self.commandsDialog:show{wait = false}

            local commandsDialogBounds = self.commandsDialog.bounds;
            commandsDialogBounds.x = self.dialog.bounds.x;
            commandsDialogBounds.y = self.dialog.bounds.y +
                                         self.dialog.bounds.height;
            commandsDialogBounds.width = self.dialog.bounds.width;
            self.commandsDialog.bounds = commandsDialogBounds;
        end
    end
end

return KeyboardDialog;
