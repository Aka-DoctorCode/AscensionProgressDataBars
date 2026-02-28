-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Config.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
-------------------------------------------------------------------------------

---@type AscensionBars
local AB = LibStub("AceAddon-3.0"):GetAddon("AscensionBars")
local L = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

-------------------------------------------------------------------------------
-- CONSTANTS & COLORS (From AscensionNotes / AscensionTalentManager)
-------------------------------------------------------------------------------
local COLORS = {
    primary           = { 0.498, 0.075, 0.925, 1.0 },  -- #7f13ec
    gold              = { 1.000, 0.800, 0.200, 1.0 },  -- #ffcc33
    background_dark   = { 0.020, 0.020, 0.031, 0.95 }, -- #050508
    surface_dark      = { 0.047, 0.039, 0.082, 1.0 },  -- #0c0a15
    surface_highlight = { 0.165, 0.141, 0.239, 1.0 },  -- #2a243d
    black_detail      = { 0.0, 0.0, 0.0, 1.0 },        -- #000000
    white_detail      = { 1, 1, 1, 1 },                -- #ffffff
    text_light        = { 0.886, 0.910, 0.941, 1.0 },  -- #e2e8f0
    text_dim          = { 0.580, 0.640, 0.720, 1.0 },  -- #9ca3af

    -- Sidebar
    sidebar_bg        = { 0.10, 0.10, 0.10, 0.95 }, -- #191919
    sidebar_hover     = { 0.20, 0.20, 0.20, 0.5 },  -- #333333
    sidebar_accent    = { 0.00, 0.48, 1.00, 0.95 }, -- #007bff
    sidebar_active    = { 0.00, 0.40, 1.00, 0.2 },  -- #0066ff
    minimize          = "Interface\\Buttons\\ui-panel-hidebutton-disabled",
    maximize          = "Interface\\Buttons\\ui-panel-hidebutton-up",
}

-- "Interface\\ChatFrame\\ChatFrameBackground" --
-- "Interface\\Tooltips\\UI-Tooltip-Border"
-- "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up"
-- "Interface\\Buttons\\UI-Panel-MinimizeButton-Up"
-- "Interface\\Buttons\\UI-Panel-MinimizeButton-Down"
-- "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight"
-- "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up"
-- "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight"
-- "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down"

local FILES = {

    bgfile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgefile = "Interface\\Tooltips\\UI-Tooltip-Border",
    arrow = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up",
    close = "Interface\\Buttons\\UI-Panel-CloseButton",
}

local configFrame = nil
local isMinimized = false
local normalWidth, normalHeight = 600, 500
local activeTab = nil
local tabs = {}
local panels = {}

-------------------------------------------------------------------------------
-- UTILS
-------------------------------------------------------------------------------
local function cleanBlockOrders(profile, block)
    local temp = {}
    for k, bar in pairs(profile.bars) do
        if bar.block == block then
            table.insert(temp, { key = k, order = bar.order or 99 })
        end
    end
    table.sort(temp, function(a, b) return a.order < b.order end)
    for i, data in ipairs(temp) do
        profile.bars[data.key].order = i
    end
end

local function getBlockCount(profile, block)
    local count = 0
    for _, bar in pairs(profile.bars) do
        if bar.block == block then count = count + 1 end
    end
    return count
end
local function cleanTextBlockOrders(profile, block)
    local temp = {}
    for k, bar in pairs(profile.bars) do
        if bar.textBlock == block then
            table.insert(temp, { key = k, order = bar.textOrder or 99 })
        end
    end
    table.sort(temp, function(a, b) return a.order < b.order end)
    for i, data in ipairs(temp) do
        profile.bars[data.key].textOrder = i
    end
end

local function getTextBlockCount(profile, block)
    local count = 0
    for _, bar in pairs(profile.bars) do
        if bar.textBlock == block then count = count + 1 end
    end
    return count
end
-------------------------------------------------------------------------------
-- GUI FACTORY
-------------------------------------------------------------------------------

local function CreateHeader(parent, text, yOffset)
    local header = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    header:SetPoint("TOPLEFT", 15, yOffset)
    header:SetText(text)
    header:SetTextColor(unpack(COLORS.gold))

    local divider = parent:CreateTexture(nil, "ARTWORK")
    divider:SetHeight(1)
    divider:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
    divider:SetPoint("RIGHT", parent, "RIGHT", -5, 0)
    divider:SetColorTexture(unpack(COLORS.surface_highlight))

    return header, yOffset - 25
end

local function CreateLabel(parent, text, yOffset)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    label:SetPoint("TOPLEFT", 15, yOffset)
    label:SetText(text)
    label:SetTextColor(unpack(COLORS.text_light))
    return label, yOffset - 20
end

local function CreateCheckbox(parent, text, tooltip, getter, setter, yOffset, xOffset)
    xOffset = xOffset or 15
    local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    cb.Text:SetFontObject("GameFontHighlightLarge")
    cb:SetPoint("TOPLEFT", xOffset, yOffset)
    cb:SetSize(24, 24)
    cb.text = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    cb.text:SetPoint("LEFT", cb, "RIGHT", 5, 0)
    cb.text:SetText(text)
    cb.text:SetTextColor(unpack(COLORS.text_light))

    cb:SetChecked(getter())
    cb:SetScript("OnClick", function(self)
        setter(self:GetChecked())
    end)

    if tooltip then
        cb:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(text, 1, 1, 1)
            GameTooltip:AddLine(tooltip, nil, nil, nil, true)
            GameTooltip:Show()
        end)
        cb:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    return cb, yOffset - 30
end

local function CreateSlider(parent, text, minVal, maxVal, step, getter, setter, yOffset, xOffset)
    xOffset = xOffset or 15
    local sliderName = "AscensionBarsSlider_" .. tostring(math.random(1000000, 9999999))
    local slider = CreateFrame("Slider", sliderName, parent, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", xOffset, yOffset - 15)
    slider:SetWidth(180)
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)

    local val = getter() or minVal

    slider.text = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    slider.text:SetPoint("BOTTOM", slider, "TOP", 0, 3)
    slider.text:SetText(text .. ": " .. (math.floor(val * 100) / 100))

    _G[sliderName .. "Low"]:SetText(minVal)
    _G[sliderName .. "High"]:SetText(maxVal)

    slider:SetValue(val)

    slider:SetScript("OnValueChanged", function(self, value)
        setter(value)
        self.text:SetText(text .. ": " .. math.floor(value * 100) / 100)
    end)

    return slider, yOffset - 50
end

local function CreateColorPicker(parent, text, getter, setter, yOffset, xOffset, hasAlpha)
    xOffset = xOffset or 15
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(20, 20)
    btn:SetPoint("TOPLEFT", xOffset, yOffset)

    local tex = btn:CreateTexture(nil, "OVERLAY")
    tex:SetAllPoints()
    tex:SetColorTexture(getter())
    btn.tex = tex

    local bg = btn:CreateTexture(nil, "BACKGROUND")
    bg:SetPoint("TOPLEFT", -1, 1)
    bg:SetPoint("BOTTOMRIGHT", 1, -1)
    bg:SetColorTexture(1, 1, 1, 1)

    local label = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    label:SetPoint("LEFT", btn, "RIGHT", 10, 0)
    label:SetText(text)

    local function ColorCallback(restore)
        local r, g, b, a
        if restore then
            r, g, b, a = unpack(restore)
        else
            if ColorPickerFrame.GetColorRGB then
                r, g, b = ColorPickerFrame:GetColorRGB()
            end
            if ColorPickerFrame.GetColorAlpha then
                a = ColorPickerFrame:GetColorAlpha()
            elseif ColorPickerFrame.GetColorOpacity then
                a = 1 - (ColorPickerFrame:GetColorOpacity() or 0)
            end
        end
        local finalA = a or 1
        setter(r or 1, g or 1, b or 1, finalA)
        btn.tex:SetColorTexture(r or 1, g or 1, b or 1, finalA)
    end

    btn:SetScript("OnClick", function()
        local r, g, b, a = getter()
        local finalA = a or 1
        local info = {
            swatchFunc = function() ColorCallback() end,
            opacityFunc = function() ColorCallback() end,
            cancelFunc = function() ColorCallback({ r or 1, g or 1, b or 1, finalA }) end,
            hasOpacity = hasAlpha,
            opacity = finalA,
            r = r or 1,
            g = g or 1,
            b = b or 1
        }
        if ColorPickerFrame.SetupColorPickerAndShow then
            ColorPickerFrame:SetupColorPickerAndShow(info)
        else
            -- Fallback for older legacy versions
            ColorPickerFrame.func = info.swatchFunc
            ColorPickerFrame.opacityFunc = info.opacityFunc
            ColorPickerFrame.cancelFunc = info.cancelFunc
            ColorPickerFrame.hasOpacity = info.hasOpacity
            ColorPickerFrame.opacity = info.opacity
            if ColorPickerFrame.SetColorRGB then
                ColorPickerFrame:SetColorRGB(info.r, info.g, info.b)
            end
            ColorPickerFrame:Show()
        end
    end)

    return btn, yOffset - 30
end

local function CreateDropdown(parent, text, options, getter, setter, yOffset, xOffset)
    xOffset = xOffset or 15
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(150, 40)
    frame:SetPoint("TOPLEFT", xOffset, yOffset)

    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    label:SetPoint("TOPLEFT", 0, 0)
    label:SetText(text)

    local dd = CreateFrame("Button", nil, frame, "BackdropTemplate")
    dd:SetSize(150, 24)
    dd:SetPoint("BOTTOMLEFT", 0, 0)
    dd:SetBackdrop({ bgFile = FILES.bgfile, edgeFile = FILES.edgefile, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 } })
    dd:SetBackdropColor(unpack(COLORS.surface_highlight))
    dd:SetBackdropBorderColor(unpack(COLORS.black_detail))

    local ddText = dd:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    ddText:SetPoint("LEFT", 10, 0)
    ddText:SetPoint("RIGHT", -20, 0)
    ddText:SetJustifyH("LEFT")

    local function getOptionLabel(val)
        for _, opt in ipairs(options) do
            if opt.value == val then return opt.label end
        end
        return tostring(val)
    end
    ddText:SetText(getOptionLabel(getter()))

    local arrow = dd:CreateTexture(nil, "OVERLAY")
    arrow:SetSize(20, 20)
    arrow:SetPoint("RIGHT", -5, 0)
    arrow:SetTexture(FILES.arrow)
    arrow:SetDesaturated(true)

    local list = CreateFrame("Frame", nil, dd, "BackdropTemplate")
    list:SetPoint("TOPLEFT", dd, "BOTTOMLEFT", 0, -2)
    list:SetWidth(150)
    list:SetFrameStrata("DIALOG")
    list:Hide()
    list:SetBackdrop({ bgFile = FILES.bgfile, edgeFile = FILES.edgefile, edgeSize = 12, insets = { left = 2, right = 2, top = 2, bottom = 2 } })
    list:SetBackdropColor(unpack(COLORS.surface_dark))
    list:SetBackdropBorderColor(unpack(COLORS.surface_highlight))

    dd:SetScript("OnClick", function()
        if list:IsShown() then list:Hide() else list:Show() end
    end)

    list:SetHeight(#options * 20 + 10)
    for i, opt in ipairs(options) do
        local btn = CreateFrame("Button", nil, list, "BackdropTemplate")
        btn:SetSize(140, 20)
        btn:SetPoint("TOPLEFT", 5, -5 - ((i - 1) * 20))
        btn:SetBackdrop({ bgFile = FILES.bgfile })
        btn:SetBackdropColor(unpack(COLORS.surface_dark))

        local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        btnText:SetPoint("LEFT", 5, 0)
        btnText:SetText(opt.label)

        btn:SetScript("OnEnter", function(self) self:SetBackdropColor(unpack(COLORS.surface_highlight)) end)
        btn:SetScript("OnLeave", function(self) self:SetBackdropColor(unpack(COLORS.surface_dark)) end)
        btn:SetScript("OnClick", function()
            setter(opt.value)
            ddText:SetText(opt.label)
            list:Hide()
        end)
    end

    return frame, yOffset - 45
end

-- Create a scroll child for a panel
local function CreateScrollPanel(parent)
    local scrollName = "AscensionBarsScrollPanel_" .. tostring(math.random(1000000, 9999999))
    local scrollFrame = CreateFrame("ScrollFrame", scrollName, parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 5, -5)
    scrollFrame:SetPoint("BOTTOMRIGHT", -25, 5)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(scrollFrame:GetWidth(), 800) -- Will grow as needed
    scrollFrame:SetScrollChild(content)

    -- Fix mousewheel scrolling for the scrollframe
    scrollFrame:EnableMouseWheel(true)
    scrollFrame.ScrollBar = _G[scrollName .. "ScrollBar"]
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local scrollBar = self.ScrollBar
        if not scrollBar then return end
        local scrollStep = 50
        local minVal, maxVal = scrollBar:GetMinMaxValues()
        local currentVal = scrollBar:GetValue()
        local newVal = currentVal - (delta * scrollStep)

        if newVal < minVal then newVal = minVal end
        if newVal > maxVal then newVal = maxVal end

        scrollBar:SetValue(newVal)
    end)

    return scrollFrame, content
end

-------------------------------------------------------------------------------
-- CONFIG FRAME TABS
-------------------------------------------------------------------------------

local function CleanupContent(p)
    if not p then return end
    local children = { p:GetChildren() }
    for _, child in ipairs(children) do
        child:Hide()
        child:ClearAllPoints()
    end
    local regions = { p:GetRegions() }
    for _, region in ipairs(regions) do
        if region.Hide then region:Hide() end
    end
end

local function BuildLayoutTab(panel)
    local p = panel.content
    CleanupContent(p)
    local prof = AB and AB.db and AB.db.profile
    if not prof then return end

    -- Use a stable width to prevent overlapping columns if GetWidth() returns 0 or too small
    local panelWidth = 600
    local colWidth = (panelWidth - 80) / 3
    local curY = -15

    local _, curY = CreateHeader(p, "Global Positioning", curY)
    curY = curY - 8
    CreateSlider(p, "Global Blocks Offset", -100, 100, 1,
        function() return prof.yOffset end,
        function(v)
            prof.yOffset = v; AB:UpdateDisplay()
        end,
        curY)
    CreateSlider(p, "Global Bar Height", 1, 50, 1,
        function() return prof.globalBarHeight end,
        function(v)
            prof.globalBarHeight = v
            for k, b in pairs(prof.bars) do b.freeHeight = v end
            AB:UpdateDisplay()
        end,
        curY, 210)
    curY = curY - 60

    local _, curY = CreateHeader(p, "Bar Management", curY)
    local startY = curY

    local blocks = {
        { name = "Top Block",    key = "TOP",    x = 10 },
        { name = "Bottom Block", key = "BOTTOM", x = 10 + colWidth + 5 },
        { name = "Free Mode",    key = "FREE",   x = 10 + (colWidth + 5) * 2 }
    }

    local maxBottomY = startY

    for _, block in ipairs(blocks) do
        local bY = startY
        local label = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        label:SetPoint("TOPLEFT", block.x, bY)
        label:SetText(block.name)
        label:SetTextColor(unpack(COLORS.primary))
        bY = bY - 25

        local barKeys = { "XP", "Rep", "Honor", "HouseXp", "Azerite" }
        local barNames = { "Experience", "Reputation", "Honor", "House XP", "Azerite" }

        local sortedBars = {}
        for i, key in ipairs(barKeys) do
            if prof.bars[key].block == block.key then
                table.insert(sortedBars, { key = key, name = barNames[i] })
            end
        end
        table.sort(sortedBars, function(a, b) return prof.bars[a.key].order < prof.bars[b.key].order end)

        for _, barData in ipairs(sortedBars) do
            local key = barData.key
            local name = barData.name

            local barHeader = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
            barHeader:SetPoint("TOPLEFT", block.x + 5, bY)
            barHeader:SetText(name)
            bY = bY - 20

            local cbEn
            cbEn, bY = CreateCheckbox(p, "Enable", nil,
                function() return prof.bars[key].enabled end,
                function(v)
                    prof.bars[key].enabled = v; AB:UpdateDisplay()
                end,
                bY, block.x + 10)

            local ddBlock
            ddBlock, bY = CreateDropdown(p, "Anchor",
                { { label = "Top", value = "TOP" }, { label = "Bottom", value = "BOTTOM" }, { label = "Free", value = "FREE" } },
                function() return prof.bars[key].block end,
                function(v)
                    local oldBlock = prof.bars[key].block
                    prof.bars[key].block = v
                    cleanBlockOrders(prof, oldBlock)
                    prof.bars[key].order = math.max(1, getBlockCount(prof, v))
                    AB:UpdateDisplay()
                    panel:UpdateLayout()
                end,
                bY, block.x + 10)

            local orderOptions = {}
            local count = getBlockCount(prof, prof.bars[key].block)
            for j = 1, count do table.insert(orderOptions, { label = tostring(j), value = j }) end
            local ddOrder
            ddOrder, bY = CreateDropdown(p, "Order", orderOptions,
                function() return prof.bars[key].order end,
                function(v)
                    local oldOrder = prof.bars[key].order
                    local newOrder = v
                    local bK = prof.bars[key].block
                    if oldOrder == newOrder then return end
                    for k, bar in pairs(prof.bars) do
                        if k ~= key and bar.block == bK then
                            if oldOrder < newOrder then
                                if bar.order > oldOrder and bar.order <= newOrder then bar.order = bar.order - 1 end
                            else
                                if bar.order >= newOrder and bar.order < oldOrder then bar.order = bar.order + 1 end
                            end
                        end
                    end
                    prof.bars[key].order = newOrder
                    AB:UpdateDisplay()
                    panel:UpdateLayout()
                end,
                bY, block.x + 10)

            if prof.textLayoutMode == "INDIVIDUAL_LINES" then
                local slTX, slTY
                slTX, bY = CreateSlider(p, "Txt X", -500, 500, 1,
                    function() return prof.bars[key].textX or 0 end,
                    function(v)
                        prof.bars[key].textX = v; AB:UpdateDisplay()
                    end,
                    bY, block.x + 15)
                slTY, bY = CreateSlider(p, "Txt Y", -500, 500, 1,
                    function() return prof.bars[key].textY or 0 end,
                    function(v)
                        prof.bars[key].textY = v; AB:UpdateDisplay()
                    end,
                    bY, block.x + 15)
            end

            if block.key == "FREE" then
                local slW, slH, slX, slY
                slW, bY = CreateSlider(p, "Width", 50, 2000, 1,
                    function() return prof.bars[key].freeWidth end,
                    function(v)
                        prof.bars[key].freeWidth = v; AB:UpdateDisplay()
                    end,
                    bY, block.x + 15)
                slH, bY = CreateSlider(p, "Height", 2, 100, 1,
                    function() return prof.bars[key].freeHeight or 15 end,
                    function(v)
                        prof.bars[key].freeHeight = v; AB:UpdateDisplay()
                    end,
                    bY, block.x + 15)
                slX, bY = CreateSlider(p, "Pos X", -1000, 1000, 1,
                    function() return prof.bars[key].freeX end,
                    function(v)
                        prof.bars[key].freeX = v; AB:UpdateDisplay()
                    end,
                    bY, block.x + 15)
                slY, bY = CreateSlider(p, "Pos Y", -1000, 1000, 1,
                    function() return prof.bars[key].freeY end,
                    function(v)
                        prof.bars[key].freeY = v; AB:UpdateDisplay()
                    end,
                    bY, block.x + 15)
            end
            bY = bY - 15
        end

        if #sortedBars == 0 then
            local empty = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
            empty:SetPoint("TOPLEFT", block.x + 10, bY)
            empty:SetText("(Empty)")
            empty:SetTextColor(0.5, 0.5, 0.5, 1)
            bY = bY - 20
        end

        if bY < maxBottomY then maxBottomY = bY end
    end

    p:SetHeight(math.abs(maxBottomY) + 50)
end

local function BuildAppearanceTab(panel)
    local p = panel.content
    CleanupContent(p)
    local curY = -15
    local prof = AB and AB.db and AB.db.profile
    if not prof then return end

    local _, curY = CreateHeader(p, "Text & Font", curY)

    local ddLayout
    ddLayout, curY = CreateDropdown(p, "Layout Mode",
        { { label = "All in one line", value = "SINGLE_LINE" }, { label = "Multiple lines", value = "INDIVIDUAL_LINES" } },
        function() return prof.textLayoutMode end,
        function(v)
            prof.textLayoutMode = v; AB:UpdateDisplay(); panel:UpdateLayout()
        end,
        curY)

    if prof.textLayoutMode == "INDIVIDUAL_LINES" then
        local cbFollow
        cbFollow, curY = CreateCheckbox(p, "Text follows its Bar", "If disabled, text will anchor to the global center.",
            function() return prof.textFollowBar end,
            function(v)
                prof.textFollowBar = v; AB:UpdateDisplay()
            end,
            curY, 25)
    end

    local slSize, cpGlobal
    slSize, curY = CreateSlider(p, "Font Size", 8, 32, 1,
        function() return prof.textSize end,
        function(v)
            prof.textSize = v; AB:UpdateDisplay()
        end,
        curY)
    cpGlobal, curY = CreateColorPicker(p, "Global Text Color",
        function()
            local c = prof.textColor; return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            prof.textColor.r = r; prof.textColor.g = g; prof.textColor.b = b; prof.textColor.a = a; AB:UpdateDisplay()
        end,
        curY, 15, true)

    local _, headerY = CreateHeader(p, "Text Group Positions", curY)
    local startY = headerY
    local colWidth = 190
    local maxColumnBottom = startY

    for i = 1, 3 do
        local key = "T" .. i
        local xOff = 15 + (i - 1) * colWidth
        local colY = startY

        local gSet = prof.textGroups[key]
        if not gSet then
            prof.textGroups[key] = { detached = true, x = 0, y = -25 * i }
            gSet = prof.textGroups[key]
        end

        local cbDetach
        cbDetach, colY = CreateCheckbox(p, "Detach " .. i,
            "Anchor group " .. i .. " globally instead of to the bars.",
            function() return gSet.detached end,
            function(v)
                gSet.detached = v; AB:UpdateDisplay(); panel:UpdateLayout()
            end,
            colY, xOff)

        if gSet.detached then
            local slX, slY
            slX, colY = CreateSlider(p, "Group " .. i .. " X", -1000, 1000, 1,
                function() return gSet.x end,
                function(v)
                    gSet.x = v; AB:UpdateDisplay()
                end,
                colY, xOff + 5)
            slY, colY = CreateSlider(p, "Group " .. i .. " Y", -1000, 1000, 1,
                function() return gSet.y end,
                function(v)
                    gSet.y = v; AB:UpdateDisplay()
                end,
                colY, xOff + 5)
        end
        if colY < maxColumnBottom then maxColumnBottom = colY end
    end
    curY = maxColumnBottom - 10

    local _, curY = CreateHeader(p, "Text Management", curY)
    local startY = curY
    local panelWidth = 600
    local colWidth = (panelWidth - 80) / 3

    local textBlocks = {
        { name = "Group 1", key = "T1", x = 10 },
        { name = "Group 2", key = "T2", x = 10 + colWidth + 5 },
        { name = "Group 3", key = "T3", x = 10 + (colWidth + 5) * 2 }
    }

    local maxBottomY = curY
    for _, block in ipairs(textBlocks) do
        local bY = startY
        local label = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        label:SetPoint("TOPLEFT", block.x, bY)
        label:SetText(block.name)
        label:SetTextColor(unpack(COLORS.primary))
        bY = bY - 25

        local sortedTexts = {}
        for k, b in pairs(prof.bars) do
            if b.textBlock == block.key then
                table.insert(sortedTexts, { key = k, order = b.textOrder or 0, name = k })
            end
        end
        table.sort(sortedTexts, function(a, b) return a.order < b.order end)

        for i, textData in ipairs(sortedTexts) do
            local key = textData.key
            local name = textData.name

            local textHeader = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
            textHeader:SetPoint("TOPLEFT", block.x + 5, bY)
            textHeader:SetText(name)
            bY = bY - 20

            local ddTBlock
            ddTBlock, bY = CreateDropdown(p, "Anchor",
                { { label = "Group 1", value = "T1" }, { label = "Group 2", value = "T2" }, { label = "Group 3", value = "T3" } },
                function() return prof.bars[key].textBlock or "T1" end,
                function(v)
                    local oldBlock = prof.bars[key].textBlock or "T1"
                    prof.bars[key].textBlock = v
                    cleanTextBlockOrders(prof, oldBlock)
                    prof.bars[key].textOrder = math.max(1, getTextBlockCount(prof, v))
                    AB:UpdateDisplay()
                    panel:UpdateLayout()
                end,
                bY, block.x + 10)

            local orderOptions = {}
            local count = getTextBlockCount(prof, block.key)
            for j = 1, count do table.insert(orderOptions, { label = tostring(j), value = j }) end
            local ddTOrder
            ddTOrder, bY = CreateDropdown(p, "Order", orderOptions,
                function() return prof.bars[key].textOrder or 1 end,
                function(v)
                    local oldOrder = prof.bars[key].textOrder or 1
                    local newOrder = v
                    local bK = prof.bars[key].textBlock or "T1"
                    if oldOrder == newOrder then return end
                    for k, bar in pairs(prof.bars) do
                        if k ~= key and (bar.textBlock or "T1") == bK then
                            if oldOrder < newOrder then
                                if (bar.textOrder or 0) > oldOrder and (bar.textOrder or 0) <= newOrder then
                                    bar.textOrder = (bar.textOrder or 0) - 1
                                end
                            else
                                if (bar.textOrder or 0) >= newOrder and (bar.textOrder or 0) < oldOrder then
                                    bar.textOrder = (bar.textOrder or 0) + 1
                                end
                            end
                        end
                    end
                    prof.bars[key].textOrder = newOrder
                    AB:UpdateDisplay()
                    panel:UpdateLayout()
                end,
                bY, block.x + 10)

            bY = bY - 15
        end

        if #sortedTexts == 0 then
            local empty = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
            empty:SetPoint("TOPLEFT", block.x + 10, bY)
            empty:SetText("(Empty)")
            empty:SetTextColor(0.5, 0.5, 0.5, 1)
            bY = bY - 20
        end
        if bY < maxBottomY then maxBottomY = bY end
    end

    panel.content:SetHeight(math.abs(maxBottomY) + 20)
end

local function BuildBehaviorTab(panel)
    local p = panel.content
    CleanupContent(p)
    local curY = -15
    local prof = AB and AB.db and AB.db.profile
    if not prof then return end

    local _, curY = CreateHeader(p, "Auto-Hide Logic", curY)

    local cbMouse, cbCombat, cbMax
    cbMouse, curY = CreateCheckbox(p, "Show on Mouseover", nil,
        function() return prof.showOnMouseover end,
        function(v)
            prof.showOnMouseover = v; AB:UpdateDisplay()
        end,
        curY)
    cbCombat, curY = CreateCheckbox(p, "Hide in Combat", nil,
        function() return prof.hideInCombat end,
        function(v)
            prof.hideInCombat = v; AB:UpdateDisplay()
        end,
        curY)
    cbMax, curY = CreateCheckbox(p, "Hide at Max Level", nil,
        function() return prof.hideAtMaxLevel end,
        function(v)
            prof.hideAtMaxLevel = v; AB:UpdateDisplay()
        end,
        curY)

    local _, curY = CreateHeader(p, "Data Display", curY)
    local cbPct, cbAbs, cbSpark
    cbPct, curY = CreateCheckbox(p, "Show Percentage", nil,
        function() return prof.showPercentage end,
        function(v)
            prof.showPercentage = v; AB:UpdateDisplay()
        end,
        curY)
    cbAbs, curY = CreateCheckbox(p, "Show Absolute Values", nil,
        function() return prof.showAbsoluteValues end,
        function(v)
            prof.showAbsoluteValues = v; AB:UpdateDisplay()
        end,
        curY)
    cbSpark, curY = CreateCheckbox(p, "Show Spark", nil,
        function() return prof.sparkEnabled end,
        function(v)
            prof.sparkEnabled = v; AB:UpdateDisplay()
        end,
        curY)

    panel.content:SetHeight(math.abs(curY) + 20)
end

local function BuildColorsTab(panel)
    local p = panel.content
    CleanupContent(p)
    local curY = -15
    local prof = AB and AB.db and AB.db.profile
    if not prof then return end

    -- XP
    local _, curY = CreateHeader(p, "Experience", curY)
    local cbClass, cpXP, cbRested, cpRested
    cbClass, curY = CreateCheckbox(p, "Use Class Color", nil,
        function() return prof.useClassColorXP end,
        function(v)
            prof.useClassColorXP = v; AB:UpdateDisplay(); panel:UpdateLayout()
        end,
        curY)

    if not prof.useClassColorXP then
        cpXP, curY = CreateColorPicker(p, "Custom XP Color",
            function()
                local c = prof.xpBarColor; return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                prof.xpBarColor.r = r; prof.xpBarColor.g = g; prof.xpBarColor.b = b; prof.xpBarColor.a = a; AB
                    :UpdateDisplay()
            end,
            curY, 25, true)
    end

    cbRested, curY = CreateCheckbox(p, "Show Rested Bar", nil,
        function() return prof.showRestedBar end,
        function(v)
            prof.showRestedBar = v; AB:UpdateDisplay(); panel:UpdateLayout()
        end,
        curY)

    if prof.showRestedBar then
        cpRested, curY = CreateColorPicker(p, "Rested Color",
            function()
                local c = prof.restedBarColor; return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                prof.restedBarColor.r = r; prof.restedBarColor.g = g; prof.restedBarColor.b = b; prof.restedBarColor.a =
                    a; AB:UpdateDisplay()
            end,
            curY, 25, true)
    end

    -- Reputation
    local _, curY = CreateHeader(p, "Reputation", curY)
    local cbReact, cpRep
    cbReact, curY = CreateCheckbox(p, "Use Reaction Colors", nil,
        function() return prof.useReactionColorRep end,
        function(v)
            prof.useReactionColorRep = v; AB:UpdateDisplay(); panel:UpdateLayout()
        end,
        curY)
    if not prof.useReactionColorRep then
        cpRep, curY = CreateColorPicker(p, "Custom Rep Color",
            function()
                local c = prof.repBarColor; return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                prof.repBarColor.r = r; prof.repBarColor.g = g; prof.repBarColor.b = b; prof.repBarColor.a = a; AB
                    :UpdateDisplay()
            end,
            curY, 25, true)
    else
        -- Standing Colors (shown when using reaction colors so each standing can be customized)
        local labels = {
            L["HATED"], L["HOSTILE"], L["UNFRIENDLY"], L["NEUTRAL"], L["FRIENDLY"],
            L["HONORED"], L["REVERED"], L["EXALTED"], L["PARAGON"], L["MAXED"], L["RENOWN"]
        }
        local startY = curY
        local colWidth = 190
        local lowestY = startY
        for i = 1, 11 do
            local col = (i - 1) % 3
            local row = math.floor((i - 1) / 3)
            local xOff = 15 + col * colWidth
            local yPos = startY - (row * 35)

            local _, nextY = CreateColorPicker(p, labels[i] or ("Rank " .. i),
                function()
                    local c = prof.repColors[i]; if not c then return 1, 1, 1, 1 end; return c.r, c.g, c.b, c.a
                end,
                function(r, g, b, a)
                    if not prof.repColors[i] then prof.repColors[i] = {} end
                    local c = prof.repColors[i]; c.r = r; c.g = g; c.b = b; c.a = a; AB:UpdateDisplay()
                end,
                yPos, xOff + 10, true) -- Reduced xOff for the button to accommodate labels better
            if nextY < lowestY then lowestY = nextY end
        end
        curY = lowestY - 10
    end

    -- Honor
    local _, curY = CreateHeader(p, "Honor", curY)
    local cpHonor
    cpHonor, curY = CreateColorPicker(p, "Honor Color",
        function()
            local c = prof.honorColor; if not c then return 0.8, 0.2, 0.2, 1 end; return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not prof.honorColor then prof.honorColor = {} end; local c = prof.honorColor; c.r = r; c.g = g; c.b = b; c.a =
                a; AB:UpdateDisplay()
        end,
        curY, 15, true)

    -- House Favor
    local _, curY = CreateHeader(p, "House Favor", curY)
    local cpHouse, cpHReward, slHRewardY
    cpHouse, curY = CreateColorPicker(p, "House XP Color",
        function()
            local c = prof.houseXpColor; if not c then return 0.9, 0.5, 0, 1 end; return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not prof.houseXpColor then prof.houseXpColor = {} end; local c = prof.houseXpColor; c.r = r; c.g = g; c.b =
                b; c.a = a; AB:UpdateDisplay()
        end,
        curY, 15, true)
    cpHReward, curY = CreateColorPicker(p, "House Reward Color",
        function()
            local c = prof.houseRewardTextColor; if not c then return 0.9, 0.5, 0, 1 end; return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not prof.houseRewardTextColor then prof.houseRewardTextColor = {} end; local c = prof
                .houseRewardTextColor; c.r = r; c.g = g; c.b = b; c.a = a; AB:UpdateDisplay()
        end,
        curY, 15, true)

    slHRewardY, curY = CreateSlider(p, "House Reward Y Offset", -1000, 500, 5,
        function() return prof.houseRewardTextYOffset or -40 end,
        function(v)
            prof.houseRewardTextYOffset = v; AB:UpdateDisplay()
        end,
        curY, 15)

    -- Azerite
    local _, curY = CreateHeader(p, "Azerite", curY)
    local cpAzerite
    cpAzerite, curY = CreateColorPicker(p, "Azerite Color",
        function()
            local c = prof.azeriteColor; if not c then return 0.9, 0.8, 0.5, 1 end; return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not prof.azeriteColor then prof.azeriteColor = {} end; local c = prof.azeriteColor; c.r = r; c.g = g; c.b =
                b; c.a = a; AB:UpdateDisplay()
        end,
        curY, 15, true)

    panel.content:SetHeight(math.abs(curY) + 20)
end

local function BuildParagonTab(panel)
    local p = panel.content
    CleanupContent(p)
    local curY = -15
    local prof = AB and AB.db and AB.db.profile
    if not prof then return end

    local _, curY = CreateHeader(p, "Alert Styling", curY)
    local cbTop, cbSplit
    cbTop, curY = CreateCheckbox(p, "Show On Top", nil,
        function() return prof.paragonOnTop end,
        function(v)
            prof.paragonOnTop = v; AB:UpdateDisplay()
        end,
        curY)
    cbSplit, curY = CreateCheckbox(p, "Split Lines", nil,
        function() return prof.splitParagonText end,
        function(v)
            prof.splitParagonText = v; AB:UpdateDisplay()
        end,
        curY)

    local slSize, slYOffset
    slSize, curY = CreateSlider(p, "Text Size", 10, 40, 1,
        function() return prof.paragonTextSize end,
        function(v)
            prof.paragonTextSize = v; AB:UpdateDisplay()
        end,
        curY)
    slYOffset, curY = CreateSlider(p, "Vertical Offset Y", -1000, 500, 5,
        function() return prof.paragonTextYOffset end,
        function(v)
            prof.paragonTextYOffset = v; AB:UpdateDisplay()
        end,
        curY)

    local cpAlert
    cpAlert, curY = CreateColorPicker(p, "Alert Color",
        function()
            local c = prof.paragonPendingColor; return c.r, c.g, c.b, 1
        end,
        function(r, g, b, a)
            local c = prof.paragonPendingColor; c.r = r; c.g = g; c.b = b; AB:UpdateDisplay()
        end,
        curY, 15, false)

    panel.content:SetHeight(math.abs(curY) + 20)
end

-------------------------------------------------------------------------------
-- MAIN CONFIG WINDOW
-------------------------------------------------------------------------------

local function SelectTab(index)
    activeTab = index
    for i, t in ipairs(tabs) do
        if i == index then
            t:SetBackdropColor(unpack(COLORS.sidebar_active))
        else
            t:SetBackdropColor(0, 0, 0, 0)
        end
    end
    for i, p in ipairs(panels) do
        if i == index then
            -- Rebuild layout continuously for dynamic conditions
            if p.UpdateLayout then
                p:UpdateLayout()
            end
            p:Show()
        else
            p:Hide()
        end
    end
end

local function CreateTabButton(parent, label, index)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(140, 30)
    btn:SetPoint("TOPLEFT", 10, -50 - ((index - 1) * 35))

    btn:SetBackdrop({ bgFile = FILES.bgfile, edgeFile = FILES.edgefile, edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 } })
    btn:SetBackdropColor(0, 0, 0, 0)
    btn:SetBackdropBorderColor(0, 0, 0, 0)

    local text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    text:SetPoint("LEFT", 15, 0)
    text:SetText(label)

    btn:SetScript("OnClick", function() SelectTab(index) end)
    btn:SetScript("OnEnter", function(self)
        if activeTab ~= index then self:SetBackdropColor(unpack(COLORS.sidebar_hover)) end
    end)
    btn:SetScript("OnLeave", function(self)
        if activeTab ~= index then self:SetBackdropColor(0, 0, 0, 0) end
    end)

    table.insert(tabs, btn)
    return btn
end

local function CreateConfigFrame()
    if configFrame then return end

    configFrame = CreateFrame("Frame", "AscensionBarsConfigFrame", UIParent, "BackdropTemplate")
    configFrame:SetSize(750, 500)
    configFrame:SetPoint("CENTER")
    configFrame:SetMovable(true)
    configFrame:EnableMouse(true)
    configFrame:RegisterForDrag("LeftButton")
    configFrame:SetFrameStrata("HIGH")

    configFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    configFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    configFrame:SetBackdrop({
        bgFile = FILES.bgfile,
        edgeFile = FILES.edgefile,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    configFrame:SetBackdropColor(unpack(COLORS.background_dark))
    configFrame:SetBackdropBorderColor(unpack(COLORS.surface_highlight))

    configFrame:SetResizable(true)
    if configFrame.SetResizeBounds then
        configFrame:SetResizeBounds(500, 400, 1200, 1000)
    else
        configFrame:SetMinResize(500, 400)
        configFrame:SetMaxResize(1200, 1000)
    end

    local resizeBtn = CreateFrame("Button", nil, configFrame)
    resizeBtn:SetSize(16, 16)
    resizeBtn:SetPoint("BOTTOMRIGHT", -4, 4)
    resizeBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeBtn:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resizeBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    resizeBtn:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            configFrame:StartSizing("BOTTOMRIGHT")
        end
    end)
    resizeBtn:SetScript("OnMouseUp", function(self, button)
        configFrame:StopMovingOrSizing()
    end)

    local title = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    title:SetPoint("TOPLEFT", 15, -15)
    title:SetText("Ascension Bars")
    title:SetTextColor(unpack(COLORS.gold))

    local titleSep = configFrame:CreateTexture(nil, "ARTWORK")
    titleSep:SetHeight(1)
    titleSep:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 10, -40)
    titleSep:SetPoint("RIGHT", configFrame, "RIGHT", -10, 0)
    titleSep:SetColorTexture(unpack(COLORS.surface_highlight))
    -- Close button
    local closeBtn = CreateFrame("Button", nil, configFrame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", 0, 0)
    closeBtn:SetScript("OnClick", function() configFrame:Hide() end)

    local minimizeBtn = CreateFrame("Button", nil, configFrame)
    minimizeBtn:SetSize(24, 24)
    minimizeBtn:SetPoint("RIGHT", closeBtn, "LEFT", -5, 0)
    minimizeBtn:SetNormalTexture(COLORS.minimize)
    minimizeBtn:SetHighlightTexture(COLORS.minimize, "ADD")

    local function UpdateMinimizeState()
        if isMinimized then
            configFrame:SetSize(300, 40)
            for i, child in ipairs({ configFrame:GetChildren() }) do
                if child ~= minimizeBtn and child ~= closeBtn then
                    child:Hide()
                end
            end
            minimizeBtn:SetNormalTexture(COLORS.maximize)
        else
            configFrame:SetSize(normalWidth, normalHeight)
            for i, child in ipairs({ configFrame:GetChildren() }) do
                child:Show()
            end
            SelectTab(activeTab or 1)
            minimizeBtn:SetNormalTexture(COLORS.minimize)
        end
    end

    minimizeBtn:SetScript("OnClick", function()
        isMinimized = not isMinimized
        UpdateMinimizeState()
    end)

    -- Sidebar Separator
    local sep = configFrame:CreateTexture(nil, "ARTWORK")
    sep:SetWidth(1)
    sep:SetPoint("TOPLEFT", 160, -45)
    sep:SetPoint("BOTTOMLEFT", 160, 75)
    sep:SetColorTexture(unpack(COLORS.surface_highlight))

    local btnReset = CreateFrame("Button", nil, configFrame, "UIPanelButtonTemplate")
    btnReset:SetSize(130, 24)
    btnReset:SetPoint("BOTTOMLEFT", 15, 40)
    btnReset:SetText((L and L["FACTION_STANDINGS_RESET"]) or "Reset Defaults")
    btnReset:SetScript("OnClick", function()
        if AB and AB.db then
            AB.db:ResetProfile()
            if AB.UpdateDisplay then AB:UpdateDisplay() end
            SelectTab(1)
        end
    end)

    local cbConfig = CreateFrame("CheckButton", nil, configFrame, "UICheckButtonTemplate")
    cbConfig:SetPoint("BOTTOMLEFT", 15, 12)
    cbConfig:SetSize(24, 24)
    cbConfig.text = cbConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    cbConfig.text:SetPoint("LEFT", cbConfig, "RIGHT", 5, 0)
    cbConfig.text:SetText((L and L["CONFIG_MODE"]) or "Config Mode")

    cbConfig:SetScript("OnShow", function(self)
        if AB and AB.state then self:SetChecked(AB.state.isConfigMode) end
    end)
    cbConfig:SetScript("OnClick", function(self)
        if AB and AB.state then
            AB.state.isConfigMode = self:GetChecked()
            if AB.UpdateDisplay then AB:UpdateDisplay() end
        end
    end)

    local tabNames = { "Bars Layout", "Text Layout", "Behavior", "Colors", "Paragon Alerts" }
    local buildFuncs = { BuildLayoutTab, BuildAppearanceTab, BuildBehaviorTab, BuildColorsTab, BuildParagonTab }

    for i, name in ipairs(tabNames) do
        CreateTabButton(configFrame, name, i)

        local panel = CreateFrame("Frame", nil, configFrame)
        panel:SetPoint("TOPLEFT", sep, "TOPRIGHT", 0, 0)
        panel:SetPoint("BOTTOMRIGHT", -10, 15)
        panel:Hide()

        local scrollFrame, content = CreateScrollPanel(panel)
        panel.scrollFrame = scrollFrame
        panel.content = content
        panel.UpdateLayout = buildFuncs[i]

        table.insert(panels, panel)
    end

    SelectTab(1)
    configFrame:Hide()
end

function AB:ToggleConfig()
    if not configFrame then
        CreateConfigFrame()
    end
    if configFrame then
        if configFrame:IsShown() then
            configFrame:Hide()
        else
            configFrame:Show()
        end
    end
end
