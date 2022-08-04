SortOptions = dofile("./SortOptions.lua")

local ColorList = {}

function ColorList:LoadColorsFromImage(image)
    for pixel in image:pixels() do
        local color = Color(pixel())

        -- Skip fully transparent pixels
        if color.alpha == 0 then goto skipPixel end

        for i, colorEntry in ipairs(self) do
            if colorEntry.color.rgbaPixel == color.rgbaPixel then
                self[i].count = self[i].count + 1
                goto skipPixel
            end
        end

        table.insert(self, {color = color, count = 1})

        ::skipPixel::
    end

    return self
end

function ColorList:GetColors(sortOption)
    local colors = {}
    for _, color in ipairs(self) do table.insert(colors, color) end

    table.sort(colors, self:GetSortFunction(sortOption))

    return colors
end

function ColorList:GetSortFunction(sortOption)
    if sortOption == SortOptions.UsageDesc then
        return function(a, b) return a.count > b.count end
    elseif sortOption == SortOptions.UsageAsc then
        return function(a, b) return a.count < b.count end
    elseif sortOption == SortOptions.ValueDesc then
        return function(a, b) return a.color.value > b.color.value end
    elseif sortOption == SortOptions.ValueAsc then
        return function(a, b) return a.color.value < b.color.value end
    end
end

function ColorList:SortPalette(colorEntries)
    local colorMode = app.activeImage.spec.colorMode

    if app.activeImage.spec.colorMode == ColorMode.INDEXED then
        -- Changing format to RGB temporarily to preserve color in the image
        app.command.ChangePixelFormat {format = "rgb"}

        self:CopyToPalette(colorEntries, colorMode)

        app.command.ChangePixelFormat {format = "indexed"}
    else
        self:CopyToPalette(colorEntries, colorMode)
    end
end

function ColorList:CopyToPalette(colorEntries, colorMode)
    local palette = app.activeSprite.palettes[1]

    local notUsedPaletteColors = self:GetNotUsedPaletteColors(colorEntries,
                                                              palette, colorMode)
    local paletteIndex = 0

    if colorMode == ColorMode.INDEXED then
        -- In the INDEXED mode the first colors is transparent, we don't want to move it
        paletteIndex = 1;
    end

    -- Add "paletteIndex" to accomodate for the ommited transparent color in the INDEXED mode
    palette:resize(#colorEntries + #notUsedPaletteColors + paletteIndex)

    for _, colorEntry in ipairs(colorEntries) do
        palette:setColor(paletteIndex, colorEntry.color)
        paletteIndex = paletteIndex + 1
    end

    for _, color in ipairs(notUsedPaletteColors) do
        palette:setColor(paletteIndex, color)
        paletteIndex = paletteIndex + 1
    end
end

function ColorList:GetNotUsedPaletteColors(colorEntries, palette, colorMode)
    local notUsedPaletteColors = {}
    local startIndex = 0;

    if colorMode == ColorMode.INDEXED then
        -- In the INDEXED mode the first colors is transparent, we don't want to move it
        startIndex = 1;
    end

    for i = startIndex, #palette - 1 do
        local paletteColor = palette:getColor(i)
        local paletteColorUsed = false

        for _, colorEntry in ipairs(colorEntries) do
            if paletteColor.rgbaPixel == colorEntry.color.rgbaPixel then
                paletteColorUsed = true
                break
            end
        end

        if not paletteColorUsed then
            table.insert(notUsedPaletteColors, paletteColor)
        end
    end

    return notUsedPaletteColors
end

function ColorList:Clear()
    for i, _ in ipairs(self) do self[i] = nil end

    return self
end

return ColorList
