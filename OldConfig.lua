-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: OldConfig.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local colors = ascensionBars.colors
local files = ascensionBars.files
local menuStyle = ascensionBars.menuStyle

-------------------------------------------------------------------------------
-- UTILS
-------------------------------------------------------------------------------

local function getActualBlock(bar, blockField)
    local val = bar[blockField]
    if blockField == "textBlock" and not val then return "T1" end
    if blockField == "block" and not val then return "TOP" end
    return val
end

local function cleanOrders(profile, blockField, orderField, block)
    if not profile or not profile.bars then return end
    
    local temp = {}
    for k, bar in pairs(profile.bars) do
        if getActualBlock(bar, blockField) == block then
            table.insert(temp, { key = k, order = bar[orderField] or 99 })
        end
    end
    
    table.sort(temp, function(a, b) return a.order < b.order end)
    
    for i, data in ipairs(temp) do
        profile.bars[data.key][orderField] = i
    end
end

local function getCount(profile, blockField, block)
    local count = 0
    for _, bar in pairs(profile.bars) do
        if getActualBlock(bar, blockField) == block then
            count = count + 1
        end
    end
    return count
end

-------------------------------------------------------------------------------
-- STYLE HELPER
-------------------------------------------------------------------------------

local function getStyle(elementID)
    if not ascensionBars.db or not ascensionBars.db.profile then return {} end
    return ascensionBars.db.profile.elementStyles and ascensionBars.db.profile.elementStyles[elementID] or {}
end

-------------------------------------------------------------------------------
-- UI FACTORY (refactored with options table)
-------------------------------------------------------------------------------

local function createHeader(args)
    local elementID = args.elementID
    local parent = args.parent
    local text = args.text
    local yOffset = args.yOffset
    
    ascensionBars.registeredElements = ascensionBars.registeredElements or {}
    ascensionBars.registeredElements[elementID] = "Header"
    
    local style = getStyle(elementID)
    local headerColor = style.uiHeaderColor or menuStyle.uiHeaderColor or colors.gold
    local headerSpacing = style.headerSpacing or menuStyle.headerSpacing or 32
    local dividerSpacing = style.dividerSpacing or menuStyle.dividerSpacing or 8

    local header = parent:CreateFontString(nil, "OVERLAY", menuStyle.headerFont)
    header.elementID = elementID
    header:SetPoint("TOPLEFT", style.contentPadding or menuStyle.contentPadding, yOffset)
    header:SetText(text)
    header:SetTextColor(unpack(headerColor))

    local divider = parent:CreateTexture(nil, "ARTWORK")
    divider:SetHeight(1)
    divider:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -dividerSpacing)
    divider:SetPoint("RIGHT", parent, "RIGHT", -8, 0)
    divider:SetColorTexture(unpack(colors.surfaceHighlight)) -- #2A243D

    return header, yOffset - headerSpacing
end

local function createLabel(args)
    local elementID = args.elementID
    local parent = args.parent
    local text = args.text
    local yOffset = args.yOffset
    local xOffset = args.xOffset
    
    ascensionBars.registeredElements = ascensionBars.registeredElements or {}
    ascensionBars.registeredElements[elementID] = "Label"
    
    local style = getStyle(elementID)
    local textColor = style.textLight or colors.textLight -- #E2E8F0
    local labelSpacing = style.labelSpacing or menuStyle.labelSpacing or 16
    local actualX = style.contentPadding or xOffset or menuStyle.contentPadding

    local label = parent:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    label.elementID = elementID
    label:SetPoint("TOPLEFT", actualX, yOffset)
    label:SetText(text)
    label:SetTextColor(unpack(textColor))

    return label, yOffset - labelSpacing
end

local function createCheckbox(args)
    local elementID = args.elementID
    local parent = args.parent
    local text = args.text
    local tooltip = args.tooltip
    local getter = args.getter
    local setter = args.setter
    local yOffset = args.yOffset
    local xOffset = args.xOffset
    
    ascensionBars.registeredElements = ascensionBars.registeredElements or {}
    ascensionBars.registeredElements[elementID] = "Checkbox"
    
    local style = getStyle(elementID)
    local actualParent = parent or menuStyle.contentPanel
    local checkboxSize = style.checkboxSize or menuStyle.checkboxSize or 24
    local checkboxSpacing = style.checkboxSpacing or menuStyle.checkboxSpacing or 24
    local labelColor = style.textColor or colors.textLight -- #E2E8F0

    local checkbox = CreateFrame("CheckButton", nil, actualParent, "UICheckButtonTemplate")
    checkbox.elementID = elementID
    checkbox:SetSize(checkboxSize, checkboxSize)
    local actualX = style.contentPadding or xOffset or 16
    checkbox:SetPoint("TOPLEFT", actualParent, "TOPLEFT", actualX, yOffset or -16)

    local label = checkbox.Text
    label:SetFontObject("GameFontHighlight")
    label:SetPoint("LEFT", checkbox, "RIGHT", 8, 0)
    label:SetText(text or "")
    label:SetTextColor(unpack(labelColor))

    if getter then
        checkbox:SetChecked(getter())
    end

    checkbox:SetScript("OnClick", function(self)
        if setter then
            setter(self:GetChecked())
        end
    end)

    if tooltip then
        checkbox:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(text or "", 1, 1, 1) -- #FFFFFF
            GameTooltip:AddLine(tooltip, 1, 0.82, 0, true) -- #FFD100
            GameTooltip:Show()
        end)
        checkbox:SetScript("OnLeave", GameTooltip_Hide)
    end

    return checkbox, yOffset - checkboxSpacing
end

local function createSlider(args)
    local elementID = args.elementID
    local parent = args.parent
    local text = args.text
    local minVal, maxVal = args.minVal, args.maxVal
    local step = args.step or 1
    local getter, setter = args.getter, args.setter
    local width = args.width or menuStyle.sliderWidth
    local yOffset, xOffset = args.yOffset, args.xOffset
    
    ascensionBars.registeredElements = ascensionBars.registeredElements or {}
    ascensionBars.registeredElements[elementID] = "Slider"
    
    local style = getStyle(elementID)
    local sliderSpacing = style.sliderSpacing or menuStyle.sliderSpacing or 56
    local actualX = style.contentPadding or xOffset or menuStyle.contentPadding

    local sliderName = "AscensionBarsSlider_" .. tostring(math.random(1000000, 9999999))
    local slider = CreateFrame("Slider", sliderName, parent, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", actualX, yOffset - 16)
    slider:SetWidth(width)
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)

    local val = getter() or minVal
    slider.text = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    slider.text:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 0, 4)
    slider.text:SetText(text)
    slider.text:SetTextColor(unpack(colors.textDim)) -- #94A3B7

    -- Modern EditBox with proper height
    local editBox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    editBox:SetSize(48, menuStyle.editBoxHeight or 24)
    editBox:SetPoint("LEFT", slider, "RIGHT", 32, 0) -- Indented to the right of slider
    editBox:SetAutoFocus(false)
    editBox:SetJustifyH("CENTER")
    editBox:SetText(tostring(math.floor(val * 100) / 100))

    local function updateValue(inputValue)
        local numericValue = tonumber(inputValue)
        if numericValue then
            numericValue = math.max(minVal, math.min(maxVal, numericValue))
            slider:SetValue(numericValue)
            setter(numericValue)
        end
    end

    editBox:SetScript("OnEnterPressed", function(self)
        updateValue(self:GetText())
        self:ClearFocus()
    end)

    -- Styled buttons using standard heights
    local btnSize = menuStyle.editBoxHeight or 24
    local buttonMinus = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    buttonMinus:SetSize(btnSize, btnSize)
    buttonMinus:SetText("-")
    buttonMinus:SetPoint("RIGHT", editBox, "LEFT", -4, 0)
    buttonMinus:SetScript("OnClick", function() updateValue(slider:GetValue() - step) end)

    local buttonPlus = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    buttonPlus:SetSize(btnSize, btnSize)
    buttonPlus:SetText("+")
    buttonPlus:SetPoint("LEFT", editBox, "RIGHT", 4, 0)
    buttonPlus:SetScript("OnClick", function() updateValue(slider:GetValue() + step) end)

    slider:SetValue(val)
    slider:SetScript("OnValueChanged", function(_, value)
        editBox:SetText(tostring(math.floor(value * 100) / 100))
        setter(value)
    end)

    return slider, yOffset - sliderSpacing
end

local function createColorPicker(args)
    local elementID = args.elementID
    local parent = args.parent
    local text = args.text
    local getter = args.getter
    local setter = args.setter
    local yOffset = args.yOffset
    local xOffset = args.xOffset
    local hasAlpha = args.hasAlpha
    ascensionBars.registeredElements = ascensionBars.registeredElements or {}
    ascensionBars.registeredElements[elementID] = "ColorPicker"
    local style = getStyle(elementID)
    local actualX = style.contentPadding or xOffset or menuStyle.contentPadding
    local pickerSize = style.colorPickerSize or menuStyle.colorPickerSize or 20
    local pickerSpacing = style.colorPickerSpacing or menuStyle.colorPickerSpacing
    local button = CreateFrame("Button", nil, parent)

    button.elementID = elementID
    button:SetSize(pickerSize, pickerSize)
    button:SetPoint("TOPLEFT", actualX, yOffset)

    local texture = button:CreateTexture(nil, "OVERLAY")
    texture:SetAllPoints()
    texture:SetColorTexture(getter())
    button.tex = texture

    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetPoint("TOPLEFT", -1, 1)
    background:SetPoint("BOTTOMRIGHT", 1, -1)
    background:SetColorTexture(1, 1, 1, 1)

    local label = button:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    label:SetPoint("LEFT", button, "RIGHT", 10, 0)
    label:SetText(text)

    local function colorCallback(restore)
        local r, g, b, a
        if restore then
            r, g, b, a = unpack(restore)
        else
            if ColorPickerFrame.GetColorRGB then
                r, g, b = ColorPickerFrame:GetColorRGB()
            end
            a = (ColorPickerFrame.GetColorAlpha and ColorPickerFrame:GetColorAlpha()) or
                (ColorPickerFrame.GetColorOpacity and 1 - ColorPickerFrame:GetColorOpacity()) or 1
        end
        local finalAlpha = a or 1
        setter(r or 1, g or 1, b or 1, finalAlpha)
        button.tex:SetColorTexture(r or 1, g or 1, b or 1, finalAlpha)
    end

    button:SetScript("OnClick", function()
        local r, g, b, a = getter()
        local currentAlpha = a or 1
        local info = {
            swatchFunc = function() colorCallback() end,
            opacityFunc = function() colorCallback() end,
            cancelFunc = function() colorCallback({ r or 1, g or 1, b or 1, currentAlpha }) end,
            hasOpacity = hasAlpha,
            opacity = currentAlpha,
            r = r or 1,
            g = g or 1,
            b = b or 1
        }

        if ColorPickerFrame.SetupColorPickerAndShow then
            ColorPickerFrame:SetupColorPickerAndShow(info)
        else
            ColorPickerFrame.func = info.swatchFunc
            ColorPickerFrame.opacityFunc = info.opacityFunc
            ColorPickerFrame.cancelFunc = info.cancelFunc
            ColorPickerFrame.hasOpacity = info.hasOpacity
            ColorPickerFrame.opacity = info.opacity
            if ColorPickerFrame.SetColorRGB then ColorPickerFrame:SetColorRGB(info.r, info.g, info.b) end
            ColorPickerFrame:Show()
        end
    end)
    return button, yOffset - pickerSpacing
end

local function createDropdown(args)
    local elementID = args.elementID
    local parent = args.parent
    local text = args.text
    local options = args.options
    local getter = args.getter
    local setter = args.setter
    local yOffset = args.yOffset
    local xOffset = args.xOffset
    
    ascensionBars.registeredElements = ascensionBars.registeredElements or {}
    ascensionBars.registeredElements[elementID] = "Dropdown"
    
    local style = getStyle(elementID)
    local actualX = style.contentPadding or xOffset or menuStyle.contentPadding
    local dropWidth = style.dropdownWidth or menuStyle.dropdownWidth or 140
    local dropHeight = style.dropdownHeight or menuStyle.dropdownHeight or 44

    local frame = CreateFrame("Frame", nil, parent)
    frame.elementID = elementID
    frame:SetSize(dropWidth, dropHeight)
    frame:SetPoint("TOPLEFT", actualX, yOffset)

    -- The label now has more space due to the increased dropHeight
    local label = frame:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    label:SetPoint("TOPLEFT", 0, 0)
    label:SetText(text)
    label:SetTextColor(unpack(colors.textLight)) -- #E2E8F0

    local dropdown = CreateFrame("Button", nil, frame, "BackdropTemplate")
    dropdown:SetSize(dropWidth, 24) -- Button height remains standard
    dropdown:SetPoint("BOTTOMLEFT", 0, 0) -- Stays at the bottom of the 44px frame
    dropdown:SetBackdrop({
        bgFile = files.bgFile,
        edgeFile = files.edgeFile,
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    dropdown:SetBackdropColor(unpack(colors.surfaceHighlight)) -- #2A243D
    dropdown:SetBackdropBorderColor(unpack(colors.blackDetail)) -- #000000

    local dropdownText = dropdown:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    dropdownText:SetPoint("LEFT", 10, 0)
    dropdownText:SetPoint("RIGHT", -20, 0)
    dropdownText:SetJustifyH("LEFT")

    local function getLabel(val)
        for _, opt in ipairs(options) do
            if opt.value == val then return opt.label end
        end
        return tostring(val)
    end
    dropdownText:SetText(getLabel(getter()))

    local arrow = dropdown:CreateTexture(nil, "OVERLAY")
    arrow:SetSize(20, 20)
    arrow:SetPoint("RIGHT", -5, 0)
    arrow:SetTexture(files.arrow)
    arrow:SetDesaturated(true)

    local list = CreateFrame("Frame", nil, dropdown, "BackdropTemplate")
    list:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 0, -2)
    list:SetWidth(150)
    list:SetFrameStrata("DIALOG")
    list:Hide()
    list:SetBackdrop({
        bgFile = files.bgFile,
        edgeFile = files.edgeFile,
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    list:SetBackdropColor(unpack(colors.surfaceDark)) -- #0C0A15
    list:SetBackdropBorderColor(unpack(colors.surfaceHighlight)) -- #2A243D

    dropdown:SetScript("OnClick", function()
        if list:IsShown() then
            list:Hide()
        else
            list:Show()
        end
    end)

    list:SetHeight(#options * 20 + 10)

    for i, opt in ipairs(options) do
        local button = CreateFrame("Button", nil, list, "BackdropTemplate")
        button:SetSize(140, 20)
        button:SetPoint("TOPLEFT", 5, -5 - ((i - 1) * 20))
        button:SetBackdrop({ bgFile = files.bgFile })
        button:SetBackdropColor(unpack(colors.surfaceDark)) -- #0C0A15

        local buttonTextLocal = button:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
        buttonTextLocal:SetPoint("LEFT", 5, 0)
        buttonTextLocal:SetText(opt.label)

        button:SetScript("OnEnter", function(self)
            self:SetBackdropColor(unpack(colors.surfaceHighlight)) -- Resaltado sutil de fondo
        end)
        button:SetScript("OnLeave", function(self)
            self:SetBackdropColor(unpack(colors.surfaceDark)) -- Color original
        end)
        button:SetScript("OnClick", function()
            setter(opt.value)
            dropdownText:SetText(opt.label)
            list:Hide()
        end)
    end

    return frame, yOffset - (menuStyle.dropdownHeight + 16)
end


local function createScrollPanel(args)
    local elementID = args.elementID
    local parent = args.parent
    ascensionBars.registeredElements = ascensionBars.registeredElements or {}
    ascensionBars.registeredElements[elementID] = "ScrollPanel"
    local scrollName = "AscensionBarsScrollPanel_" .. tostring(math.random(1000000, 9999999))
    local scrollFrame = CreateFrame("ScrollFrame", scrollName, parent, "UIPanelScrollFrameTemplate")
    scrollFrame.elementID = elementID
    scrollFrame:SetPoint("TOPLEFT", 5, -5)
    scrollFrame:SetPoint("BOTTOMRIGHT", -25, 5)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(scrollFrame:GetWidth(), 800)
    scrollFrame:SetScrollChild(content)
    scrollFrame:EnableMouseWheel(true)
    scrollFrame.ScrollBar = _G[scrollName .. "ScrollBar"]

    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local scrollBar = self.ScrollBar
        if not scrollBar then return end
        local minVal, maxVal = scrollBar:GetMinMaxValues()
        local currentVal = scrollBar:GetValue()
        local newVal = currentVal - delta * 50
        if newVal < minVal then newVal = minVal end
        if newVal > maxVal then newVal = maxVal end
        scrollBar:SetValue(newVal)
    end)
    -- Modernizing the ScrollBar visual
    local scrollBar = scrollFrame.ScrollBar
    if scrollBar then
        -- Set standard button transparency
        if scrollBar.ScrollUpButton then scrollBar.ScrollUpButton:SetAlpha(0.7) end
        if scrollBar.ScrollDownButton then scrollBar.ScrollDownButton:SetAlpha(0.7) end
        
        -- Style the thumb (the part you drag)
        local thumb = scrollBar:GetThumbTexture()
        if thumb then
            local r, g, b = unpack(colors.surfaceHighlight)
thumb:SetVertexColor(r, g, b, 0.8)
        end
        
        -- Safely hide the background track and borders
        local regions = { scrollBar:GetRegions() }
        for _, region in ipairs(regions) do
            if region:IsObjectType("Texture") then
                -- We only hide background textures, not the thumb itself
                if region ~= thumb then
                    region:SetAlpha(0)
                end
            end
        end
    end

    return scrollFrame, content
end

-------------------------------------------------------------------------------
-- LAYOUT HELPER
-------------------------------------------------------------------------------

local layoutModel = {}
function layoutModel:new(parent, startY)
    local obj = { parent = parent, y = startY or -15 }
    setmetatable(obj, { __index = layoutModel })
    return obj
end

function layoutModel:header(elementID, text)
    local h, newY = createHeader { elementID = elementID, parent = self.parent, text = text, yOffset = self.y }
    self.y = newY
    return h
end

function layoutModel:label(elementID, text, xOffset)
    local l, newY = createLabel { elementID = elementID, parent = self.parent, text = text, yOffset = self.y, xOffset = xOffset }
    self.y = newY
    return l
end

function layoutModel:checkbox(elementID, text, tooltip, getter, setter, xOffset)
    local cb, newY = createCheckbox {
        elementID = elementID, parent = self.parent, text = text, tooltip = tooltip,
        getter = getter, setter = setter, yOffset = self.y, xOffset = xOffset
    }
    self.y = newY
    return cb
end

function layoutModel:slider(elementID, text, minVal, maxVal, step, getter, setter, width, xOffset)
    local s, newY = createSlider {
        elementID = elementID, parent = self.parent, text = text, minVal = minVal, maxVal = maxVal, step = step,
        getter = getter, setter = setter, width = width, yOffset = self.y, xOffset = xOffset
    }
    self.y = newY
    return s
end

function layoutModel:colorPicker(elementID, text, getter, setter, xOffset, hasAlpha)
    local cp, newY = createColorPicker {
        elementID = elementID, parent = self.parent, text = text, getter = getter, setter = setter,
        yOffset = self.y, xOffset = xOffset, hasAlpha = hasAlpha
    }
    self.y = newY
    return cp
end

function layoutModel:dropdown(elementID, text, options, getter, setter, xOffset)
    local dd, newY = createDropdown {
        elementID = elementID, parent = self.parent, text = text, options = options,
        getter = getter, setter = setter, yOffset = self.y, xOffset = xOffset
    }
    self.y = newY
    return dd
end

function layoutModel:beginSection()
    local section = CreateFrame("Frame", nil, self.parent, "BackdropTemplate")
    section:SetPoint("TOPLEFT", 8, self.y + 8)
    section:SetPoint("RIGHT", -8, 0)
    section:SetBackdrop({
        bgFile = files.bgFile,
        edgeFile = files.edgeFile,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    section:SetBackdropColor(unpack(colors.surfaceDark)) -- #0C0A15
    section:SetBackdropBorderColor(unpack(colors.surfaceHighlight)) -- #2A243D
    self.currentSection = section
    self.y = self.y - 8
end

function layoutModel:endSection()
    if self.currentSection then
        self.currentSection:SetPoint("BOTTOM", 0, self.y)
        self.currentSection = nil
        self.y = self.y - 16
    end
end

-------------------------------------------------------------------------------
-- BAR & TEXT CONTROL BUILDERS
-------------------------------------------------------------------------------

local function createBarControls(layout, profile, barKey, displayName, panel, controlWidth, xOffset)
    local bar = profile.bars[barKey]

    layout:label("BarHeader_" .. barKey, displayName, xOffset + 5)
    layout:checkbox("EnableBarCheckbox_" .. barKey, Locales["ENABLE"], nil,
        function() return bar.enabled end,
        function(v)
            bar.enabled = v; ascensionBars:updateDisplay()
        end,
        xOffset + 10)

    layout:dropdown("AnchorDropdown_" .. barKey, Locales["ANCHOR"],
        {
            { label = Locales["TOP"],    value = "TOP" },
            { label = Locales["BOTTOM"], value = "BOTTOM" },
            { label = Locales["FREE"],   value = "FREE" }
        },
        function() return bar.block end,
        function(v)
            local oldBlock = bar.block
            bar.block = v
            cleanOrders(profile, "block", "order", oldBlock)
            bar.order = math.max(1, getCount(profile, "block", v))
            ascensionBars:updateDisplay()
            if panel and panel.UpdateLayout then panel:UpdateLayout() end
        end,
        xOffset + 10)

    local orderOptions = {}
    local count = getCount(profile, "block", bar.block)
    for j = 1, count do
        table.insert(orderOptions, { label = tostring(j), value = j })
    end
    layout:dropdown("OrderDropdown_" .. barKey, Locales["ORDER"], orderOptions,
        function() return bar.order or 1 end,
        function(v)
            local oldOrder = bar.order or 1
            if oldOrder == v then return end
            
            -- We shift the target element by a fraction to force the sorting algorithm 
            -- to naturally position it correctly without collisions.
            local targetOrder = (v > oldOrder) and (v + 0.5) or (v - 0.5)
            bar.order = targetOrder
            cleanOrders(profile, "block", "order", bar.block or "TOP")
            
            ascensionBars:updateDisplay()
            if panel and panel.UpdateLayout then panel:UpdateLayout() end
        end,
        xOffset + 10)

    if profile.textLayoutMode == "INDIVIDUAL_LINES" then
        layout:slider("TextXSlider_" .. barKey, Locales["TXT_X"], -500, 500, 1,
            function() return bar.textX or 0 end,
            function(v)
                bar.textX = v; ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)

        layout:slider("TextYSlider_" .. barKey, Locales["TXT_Y"], -500, 500, 1,
            function() return bar.textY or 0 end,
            function(v)
                bar.textY = v; ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)
    end

    if bar.block == "FREE" then
        layout:slider("WidthSlider_" .. barKey, Locales["WIDTH"], 50, 2000, 1,
            function() return bar.freeWidth end,
            function(v)
                bar.freeWidth = v; ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)

        layout:slider("HeightSlider_" .. barKey, Locales["HEIGHT"], 2, 100, 1,
            function() return bar.freeHeight or 15 end,
            function(v)
                bar.freeHeight = v; ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)

        layout:slider("PosXSlider_" .. barKey, Locales["POS_X"], -1000, 1000, 1,
            function() return bar.freeX end,
            function(v)
                bar.freeX = v; ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)

        layout:slider("PosYSlider_" .. barKey, Locales["POS_Y"], -1000, 1000, 1,
            function() return bar.freeY end,
            function(v)
                bar.freeY = v; ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)
    end

    layout.y = layout.y - 15
end

local function createTextControls(layout, profile, barKey, panel, xOffset)
    local bar = profile.bars[barKey]

    layout:label("TextHeader_" .. barKey, barKey, xOffset + 5)
    layout:dropdown("TextAnchorDropdown_" .. barKey, Locales["ANCHOR"],
        {
            { label = Locales["GROUP_1"], value = "T1" },
            { label = Locales["GROUP_2"], value = "T2" },
            { label = Locales["GROUP_3"], value = "T3" }
        },
        function() return bar.textBlock or "T1" end,
        function(v)
            local oldBlock = bar.textBlock or "T1"
            bar.textBlock = v
            cleanOrders(profile, "textBlock", "textOrder", oldBlock)
            bar.textOrder = math.max(1, getCount(profile, "textBlock", v))
            ascensionBars:updateDisplay()
            if panel and panel.UpdateLayout then panel:UpdateLayout() end
        end,
        xOffset + 10)

    local orderOptions = {}
    local count = getCount(profile, "textBlock", bar.textBlock or "T1")
    for j = 1, count do
        table.insert(orderOptions, { label = tostring(j), value = j })
    end
    layout:dropdown("TextOrderDropdown_" .. barKey, Locales["ORDER"], orderOptions,
        function() return bar.textOrder or 1 end,
        function(v)
            local oldOrder = bar.textOrder or 1
            if oldOrder == v then return end
            
            local targetOrder = (v > oldOrder) and (v + 0.5) or (v - 0.5)
            bar.textOrder = targetOrder
            cleanOrders(profile, "textBlock", "textOrder", bar.textBlock or "T1")
            
            ascensionBars:updateDisplay()
            if panel and panel.UpdateLayout then panel:UpdateLayout() end
        end,
        xOffset + 10)

    layout.y = layout.y - 15
end

-------------------------------------------------------------------------------
-- CONTENT CLEANUP
-------------------------------------------------------------------------------

local function cleanupContent(contentPanel)
    if not contentPanel then return end
    for _, child in ipairs({ contentPanel:GetChildren() }) do
        child:Hide()
        child:ClearAllPoints()
    end
    for _, region in ipairs({ contentPanel:GetRegions() }) do
        if region.Hide then region:Hide() end
    end
end

-------------------------------------------------------------------------------
-- TAB BUILD FUNCTIONS
-------------------------------------------------------------------------------

local function buildLayoutTab(panel)
    cleanupContent(panel.content)
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    local scrollFrame = panel.scrollFrame
    local panelWidth = scrollFrame and scrollFrame:GetWidth() - 30 or 600
    panelWidth = math.max(panelWidth, 400)
    local colWidth = (panelWidth - 80) / 3

    -- Global sliders (manual horizontal placement)
    local y = -15
    local _, newY1 = createSlider {
        elementID = "GlobalBlocksOffsetSlider", parent = content,
        text = Locales["GLOBAL_BLOCKS_OFFSET"], minVal = -100, maxVal = 100, step = 1,
        getter = function() return profile.yOffset end,
        setter = function(v)
            profile.yOffset = v; ascensionBars:updateDisplay()
        end,
        width = 180, yOffset = y, xOffset = 15
    }
    local _, newY2 = createSlider {
        elementID = "GlobalBarHeightSlider", parent = content,
        text = Locales["GLOBAL_BAR_HEIGHT"], minVal = 1, maxVal = 50, step = 1,
        getter = function() return profile.globalBarHeight end,
        setter = function(v)
            profile.globalBarHeight = v; for _, b in pairs(profile.bars) do b.freeHeight = v end; ascensionBars
                :updateDisplay()
        end,
        width = 180, yOffset = y, xOffset = 210
    }
    local mainY = math.min(newY1, newY2) - 10

    local mainLayout = layoutModel:new(content, mainY)
    mainLayout:header("BarManagementHeader", Locales["BAR_MANAGEMENT"])
    local startY = mainLayout.y

    local blocks = {
        { name = Locales["TOP_BLOCK"],    key = "TOP",    x = 10 },
        { name = Locales["BOTTOM_BLOCK"], key = "BOTTOM", x = 10 + colWidth + 5 },
        { name = Locales["FREE_MODE"],    key = "FREE",   x = 10 + (colWidth + 5) * 2 }
    }

    local barKeys = { "XP", "Rep", "Honor", "HouseXp", "Azerite" }
    local barNames = { Locales["EXPERIENCE"], Locales["REPUTATION"], Locales["HONOR"], Locales["HOUSE_FAVOR"], Locales
        ["AZERITE"] }

    local maxBottomY = startY

    
    for _, block in ipairs(blocks) do
        local layoutCol = layoutModel:new(content, startY)
        
        local header = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
        header:SetPoint("TOPLEFT", block.x, startY)
        header:SetText(block.name)
        header:SetTextColor(unpack(colors.primary))
        layoutCol.y = startY - 25

        local sorted = {}
        for i, key in ipairs(barKeys) do
            if (profile.bars[key].block or "TOP") == block.key then
                table.insert(sorted, { key = key, name = barNames[i] })
            end
        end
        table.sort(sorted, function(a, b) return profile.bars[a.key].order < profile.bars[b.key].order end)

        for _, bar in ipairs(sorted) do
            -- AHORA coinciden: pasamos layoutCol
            createBarControls(layoutCol, profile, bar.key, bar.name, panel, colWidth - 40, block.x)
        end

        if #sorted == 0 then
            local empty = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
            empty:SetPoint("TOPLEFT", block.x + 10, layoutCol.y)
            empty:SetText(Locales["EMPTY"])
            empty:SetTextColor(0.5, 0.5, 0.5, 1)
            layoutCol.y = layoutCol.y - 20
        end

        if layoutCol.y < maxBottomY then maxBottomY = layoutCol.y end
    end

    content:SetHeight(math.abs(maxBottomY) + 50)
end

local function buildAppearanceTab(panel)
    cleanupContent(panel.content)
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    local layout = layoutModel:new(content, -16)
    layout:header("TextAndFontHeader", Locales["TEXT_AND_FONT"])
    layout:dropdown("LayoutModeDropdown", Locales["LAYOUT_MODE"],
        {
            { label = Locales["ALL_IN_ONE_LINE"], value = "SINGLE_LINE" },
            { label = Locales["MULTIPLE_LINES"],  value = "INDIVIDUAL_LINES" }
        },
        function() return profile.textLayoutMode end,
        function(v)
            profile.textLayoutMode = v; ascensionBars:updateDisplay(); panel:UpdateLayout()
        end,
        15)

    if profile.textLayoutMode == "INDIVIDUAL_LINES" then
        layout:checkbox("TextFollowsBarCheckbox", Locales["TEXT_FOLLOWS_BAR"], Locales["TEXT_FOLLOWS_BAR_DESC"],
            function() return profile.textFollowBar end,
            function(v)
                profile.textFollowBar = v; ascensionBars:updateDisplay()
            end,
            25)
    end

    layout:slider("FontSizeSlider", Locales["FONT_SIZE"], 8, 32, 1,
        function() return profile.textSize end,
        function(v)
            profile.textSize = v; ascensionBars:updateDisplay()
        end,
        180, 15)

    layout:colorPicker("GlobalTextColorPicker", Locales["GLOBAL_TEXT_COLOR"],
        function()
            local c = profile.textColor; return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            profile.textColor.r = r; profile.textColor.g = g; profile.textColor.b = b; profile.textColor.a = a; ascensionBars
                :updateDisplay()
        end,
        15, true)

    layout:header("TextGroupPositionsHeader", Locales["TEXT_GROUP_POSITIONS"])
    local startY = layout.y
    local panelWidth = panel.scrollFrame and panel.scrollFrame:GetWidth() - 30 or 600
    panelWidth = math.max(panelWidth, 400)
    local colWidth = (panelWidth - 30) / 3
    local maxColY = startY

    for i = 1, 3 do
        local groupKey = "T" .. i
        local xOff = 15 + (i - 1) * colWidth
        local layoutGroup = layoutModel:new(content, startY)
        local settings = profile.textGroups[groupKey] or { detached = true, x = 0, y = -25 * i }

        layoutGroup:checkbox("DetachGroupCheckbox_" .. i, string.format(Locales["DETACH_GROUP"], i),
            string.format(Locales["DETACH_GROUP_DESC"], i),
            function() return settings.detached end,
            function(v)
                settings.detached = v; ascensionBars:updateDisplay(); panel:UpdateLayout()
            end,
            xOff)

        if settings.detached then
            layoutGroup:slider("GroupXSlider_" .. i, string.format(Locales["GROUP_X"], i), -1000, 1000, 1,
                function() return settings.x end,
                function(v)
                    settings.x = v; ascensionBars:updateDisplay()
                end,
                colWidth - 20, xOff + 5)
            layoutGroup:slider("GroupYSlider_" .. i, string.format(Locales["GROUP_Y"], i), -1000, 1000, 1,
                function() return settings.y end,
                function(v)
                    settings.y = v; ascensionBars:updateDisplay()
                end,
                colWidth - 20, xOff + 5)
        end

        if layoutGroup.y < maxColY then maxColY = layoutGroup.y end
    end

    layout.y = maxColY - 10
    layout:header("TextManagementHeader", Locales["TEXT_MANAGEMENT"])
    startY = layout.y

    local textBlocks = {
        { name = Locales["GROUP_1"], key = "T1", x = 10 },
        { name = Locales["GROUP_2"], key = "T2", x = 10 + colWidth + 5 },
        { name = Locales["GROUP_3"], key = "T3", x = 10 + (colWidth + 5) * 2 }
    }
    local maxBottomY = startY

    for _, block in ipairs(textBlocks) do
        local layoutCol = layoutModel:new(content, startY)
        
        local header = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
        header:SetPoint("TOPLEFT", block.x, startY)
        header:SetText(block.name)
        header:SetTextColor(unpack(colors.primary))
        layoutCol.y = startY - 25

        local sorted = {}
        for k, b in pairs(profile.bars) do
            if (b.textBlock or "T1") == block.key then
                table.insert(sorted, { key = k, order = b.textOrder or 0 })
            end
        end
        table.sort(sorted, function(a, b) return a.order < b.order end)

        for _, td in ipairs(sorted) do
            -- Asegúrate de que aquí también diga layoutCol
            createTextControls(layoutCol, profile, td.key, panel, block.x)
        end

        if #sorted == 0 then
            local empty = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
            empty:SetPoint("TOPLEFT", block.x + 10, layout.y)
            empty:SetText(Locales["EMPTY"])
            empty:SetTextColor(0.5, 0.5, 0.5, 1)
            layout.y = layout.y - 20
        end

        if layout.y < maxBottomY then maxBottomY = layout.y end
    end

    content:SetHeight(math.abs(maxBottomY) + 20)
end

local function buildBehaviorTab(panel)
    cleanupContent(panel.content)
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    local layout = layoutModel:new(content, -15)
    layout:header("AutoHideLogicHeader", Locales["AUTO_HIDE_LOGIC"])
    layout:checkbox("ShowOnMouseoverCheckbox", Locales["SHOW_ON_MOUSEOVER"], nil,
        function() return profile.showOnMouseover end,
        function(v)
            profile.showOnMouseover = v; ascensionBars:updateDisplay()
        end)
    layout:checkbox("HideInCombatCheckbox", Locales["HIDE_IN_COMBAT"], nil,
        function() return profile.hideInCombat end,
        function(v)
            profile.hideInCombat = v; ascensionBars:updateDisplay()
        end)
    layout:checkbox("HideAtMaxLevelCheckbox", Locales["HIDE_AT_MAX_LEVEL"], nil,
        function() return profile.hideAtMaxLevel end,
        function(v)
            profile.hideAtMaxLevel = v; ascensionBars:updateDisplay()
        end)

    layout:header("DataDisplayHeader", Locales["DATA_DISPLAY"])
    layout:checkbox("ShowPercentageCheckbox", Locales["SHOW_PERCENTAGE"], nil,
        function() return profile.showPercentage end,
        function(v)
            profile.showPercentage = v; ascensionBars:updateDisplay()
        end)
    layout:checkbox("ShowAbsoluteValuesCheckbox", Locales["SHOW_ABSOLUTE_VALUES"], nil,
        function() return profile.showAbsoluteValues end,
        function(v)
            profile.showAbsoluteValues = v; ascensionBars:updateDisplay()
        end)
    layout:checkbox("ShowSparkCheckbox", Locales["SHOW_SPARK"], nil,
        function() return profile.sparkEnabled end,
        function(v)
            profile.sparkEnabled = v; ascensionBars:updateDisplay()
        end)

    content:SetHeight(math.abs(layout.y) + 20)
end

local function buildColorsTab(panel)
    cleanupContent(panel.content)
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    local layout = layoutModel:new(content, -15)

    -- Experience
    layout:header("ExperienceHeader", Locales["EXPERIENCE"])
    layout:checkbox("UseClassColorXPCheckbox", Locales["USE_CLASS_COLOR"], nil,
        function() return profile.useClassColorXP end,
        function(v)
            profile.useClassColorXP = v; ascensionBars:updateDisplay(); panel:UpdateLayout()
        end)
    if not profile.useClassColorXP then
        layout:colorPicker("CustomXPColorPicker", Locales["CUSTOM_XP_COLOR"],
            function()
                local c = profile.xpBarColor; return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                profile.xpBarColor.r = r; profile.xpBarColor.g = g; profile.xpBarColor.b = b; profile.xpBarColor.a = a; ascensionBars
                    :updateDisplay()
            end,
            25, true)
    end
    layout:checkbox("ShowRestedBarCheckbox", Locales["SHOW_RESTED_BAR"], nil,
        function() return profile.showRestedBar end,
        function(v)
            profile.showRestedBar = v; ascensionBars:updateDisplay(); panel:UpdateLayout()
        end)
    if profile.showRestedBar then
        layout:colorPicker("RestedColorPicker", Locales["RESTED_COLOR"],
            function()
                local c = profile.restedBarColor; return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                profile.restedBarColor.r = r; profile.restedBarColor.g = g; profile.restedBarColor.b = b; profile.restedBarColor.a =
                    a; ascensionBars:updateDisplay()
            end,
            25, true)
    end

    -- Reputation
    layout:header("ReputationHeader", Locales["REPUTATION"])
    layout:checkbox("UseReactionColorsCheckbox", Locales["USE_REACTION_COLORS"], nil,
        function() return profile.useReactionColorRep end,
        function(v)
            profile.useReactionColorRep = v; ascensionBars:updateDisplay(); panel:UpdateLayout()
        end)
    if not profile.useReactionColorRep then
        layout:colorPicker("CustomRepColorPicker", Locales["CUSTOM_REP_COLOR"],
            function()
                local c = profile.repBarColor; return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                profile.repBarColor.r = r; profile.repBarColor.g = g; profile.repBarColor.b = b; profile.repBarColor.a =
                    a; ascensionBars:updateDisplay()
            end,
            25, true)
    else
        local standingLabels = {
            Locales["HATED"], Locales["HOSTILE"], Locales["UNFRIENDLY"], Locales["NEUTRAL"],
            Locales["FRIENDLY"], Locales["HONORED"], Locales["REVERED"], Locales["EXALTED"],
            Locales["PARAGON"], Locales["MAXED"], Locales["RENOWN"]
        }
        local startY = layout.y
        local colW = 190
        local lowestY = startY
        layout:beginSection()
        for i = 1, 11 do
            local colIdx = (i - 1) % 2 -- Reduced to 2 columns for better labels
            local xOff = 16 + (colIdx * 184)
            
            layout:colorPicker(
                "RepStandingColorPicker_" .. i,
                standingLabels[i] or string.format(Locales["RANK_NUM"], i),
                function()
                    local c = profile.repColors[i] or {r=1, g=1, b=1, a=1}
                    return c.r, c.g, c.b, c.a
                end,
                function(r, g, b, a)
                    profile.repColors[i] = {r=r, g=g, b=b, a=a}
                    ascensionBars:updateDisplay()
                end,
                xOff,
                true
            )
            -- If it's the second column, reset Y to stay on the same line
            if colIdx == 0 then layout.y = layout.y + menuStyle.colorPickerSpacing end
        end
        layout:endSection()
        layout.y = lowestY - 10
    end

    -- Honor
    layout:header("HonorHeader", Locales["HONOR"])
    layout:colorPicker("HonorColorPicker", Locales["HONOR_COLOR"],
        function()
            local c = profile.honorColor; if not c then return 0.8, 0.2, 0.2, 1 end; return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.honorColor then profile.honorColor = {} end; local c = profile.honorColor; c.r = r; c.g = g; c.b =
                b; c.a = a; ascensionBars:updateDisplay()
        end,
        15, true)

    -- House Favor
    layout:header("HouseFavorHeader", Locales["HOUSE_FAVOR"])
    layout:colorPicker("HouseXPColorPicker", Locales["HOUSE_XP_COLOR"],
        function()
            local c = profile.houseXpColor; if not c then return 0.9, 0.5, 0, 1 end; return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.houseXpColor then profile.houseXpColor = {} end; local c = profile.houseXpColor; c.r = r; c.g =
                g; c.b = b; c.a = a; ascensionBars:updateDisplay()
        end,
        15, true)
    layout:colorPicker("HouseRewardColorPicker", Locales["HOUSE_REWARD_COLOR"],
        function()
            local c = profile.houseRewardTextColor; if not c then return 0.9, 0.5, 0, 1 end; return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.houseRewardTextColor then profile.houseRewardTextColor = {} end; local c = profile
                .houseRewardTextColor; c.r = r; c.g = g; c.b = b; c.a = a; ascensionBars:updateDisplay()
        end,
        15, true)
    layout:slider("HouseRewardYOffsetSlider", Locales["HOUSE_REWARD_Y_OFFSET"], -1000, 500, 5,
        function() return profile.houseRewardTextYOffset or -40 end,
        function(v)
            profile.houseRewardTextYOffset = v; ascensionBars:updateDisplay()
        end,
        180, 15)

    -- Azerite
    layout:header("AzeriteHeader", Locales["AZERITE"])
    layout:colorPicker("AzeriteColorPicker", Locales["AZERITE_COLOR"],
        function()
            local c = profile.azeriteColor; if not c then return 0.9, 0.8, 0.5, 1 end; return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.azeriteColor then profile.azeriteColor = {} end; local c = profile.azeriteColor; c.r = r; c.g =
                g; c.b = b; c.a = a; ascensionBars:updateDisplay()
        end,
        15, true)

    content:SetHeight(math.abs(layout.y) + 20)
end

local function buildParagonTab(panel)
    cleanupContent(panel.content)
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    local layout = layoutModel:new(content, -15)
    layout:header("AlertStylingHeader", Locales["ALERT_STYLING"])
    layout:checkbox("ShowOnTopCheckbox", Locales["SHOW_ON_TOP"], nil,
        function() return profile.paragonOnTop end,
        function(v)
            profile.paragonOnTop = v; ascensionBars:updateDisplay()
        end)
    layout:checkbox("SplitLinesCheckbox", Locales["SPLIT_LINES"], nil,
        function() return profile.splitParagonText end,
        function(v)
            profile.splitParagonText = v; ascensionBars:updateDisplay()
        end)
    layout:slider("ParagonTextSizeSlider", Locales["TEXT_SIZE"], 10, 40, 1,
        function() return profile.paragonTextSize or 18 end,
        function(v)
            profile.paragonTextSize = v; ascensionBars:updateDisplay()
        end,
        180, 15)
    layout:slider("ParagonVerticalOffsetYSlider", Locales["VERTICAL_OFFSET_Y"], -1000, 500, 5,
        function() return profile.paragonTextYOffset or -100 end,
        function(v)
            profile.paragonTextYOffset = v; ascensionBars:updateDisplay()
        end,
        180, 15)
    layout:colorPicker("AlertColorPicker", Locales["ALERT_COLOR"],
        function()
            local c = profile.paragonPendingColor; return c.r, c.g, c.b, 1
        end,
        function(r, g, b)
            local c = profile.paragonPendingColor; c.r = r; c.g = g; c.b = b; ascensionBars:updateDisplay()
        end,
        15, false)

    content:SetHeight(math.abs(layout.y) + 20)
end

-------------------------------------------------------------------------------
-- TABBED INTERFACE FACTORY
-------------------------------------------------------------------------------

local function createTabbedInterface(parent, tabNames, buildFuncs, initialIndex)
    local tabs = {}
    local panels = {}
    local activeTab = initialIndex or 1

    local sidebarSeparator = parent:CreateTexture(nil, "ARTWORK")
    sidebarSeparator:SetWidth(1)
    sidebarSeparator:SetPoint("TOPLEFT", menuStyle.sidebarWidth, -45)
    sidebarSeparator:SetPoint("BOTTOMLEFT", menuStyle.sidebarWidth, 75)
    sidebarSeparator:SetColorTexture(unpack(colors.surfaceHighlight)) -- #2A243D

    local function selectTab(index)
        activeTab = index
        ascensionBars.activeTab = index
        for i, tab in ipairs(tabs) do
            if i == index then
                tab:SetBackdropColor(unpack(colors.sidebarActive))
                tab.accent:Show() -- Show accent on active
            else
                tab:SetBackdropColor(0, 0, 0, 0)
                tab.accent:Hide() -- Hide accent on others
            end
        end
        for i, panel in ipairs(panels) do
            if i == index then
                panel:Show()
                C_Timer.After(0.01, function()
                    if panel.UpdateLayout then panel.UpdateLayout() end
                end)
            else
                panel:Hide()
            end
        end
    end

    local function createTabButton(label, idx)
        local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
        local xOffset = (menuStyle.sidebarWidth - menuStyle.tabWidth) / 2
        local yOffset = -56 - ((idx - 1) * (menuStyle.tabHeight + menuStyle.tabSpacing))
        
        btn:SetSize(menuStyle.tabWidth, menuStyle.tabHeight)
        btn:SetPoint("TOPLEFT", xOffset, yOffset)
        
        -- NEW: Active Accent Texture (The vertical line)
        local accent = btn:CreateTexture(nil, "OVERLAY")
        accent:SetWidth(menuStyle.sidebarAccentWidth)
        accent:SetPoint("TOPLEFT", -xOffset, 0) -- Stays at the very edge of the sidebar
        accent:SetPoint("BOTTOMLEFT", -xOffset, 0)
        accent:SetColorTexture(unpack(colors.primary))
        accent:Hide()
        btn.accent = accent
        btn:SetBackdrop {
            bgFile = files.bgFile,
            edgeFile = files.edgeFile,
            edgeSize = 1, -- Thin border for tabs is cleaner
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        }
        btn:SetBackdropColor(0, 0, 0, 0)
        btn:SetBackdropBorderColor(0, 0, 0, 0)

        local text = btn:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
        text:SetPoint("LEFT", 15, 0)
        text:SetText(label)

        btn:SetScript("OnClick", function() selectTab(idx) end)
        btn:SetScript("OnEnter", function()
            if activeTab ~= idx then btn:SetBackdropColor(unpack(colors.sidebarHover)) end -- #333333
        end)
        btn:SetScript("OnLeave", function()
            if activeTab ~= idx then btn:SetBackdropColor(0, 0, 0, 0) end
        end)

        table.insert(tabs, btn)
        return btn
    end

    for i, name in ipairs(tabNames) do
        createTabButton(name, i)
        local panel = CreateFrame("Frame", nil, parent)
        panel:SetPoint("TOPLEFT", sidebarSeparator, "TOPRIGHT", 0, 0)
        panel:SetPoint("BOTTOMRIGHT", -10, 15)
        panel:Hide()

        local scrollFrame, content = createScrollPanel { elementID = "TabScrollPanel_" .. i, parent = panel }
        panel.scrollFrame = scrollFrame
        panel.content = content
        panel.UpdateLayout = function() buildFuncs[i](panel) end

        table.insert(panels, panel)
    end

    selectTab(activeTab)

    return {
        panels = panels,
        selectTab = selectTab,
        getActiveTab = function() return activeTab end
    }
end

-------------------------------------------------------------------------------
-- MAIN CONFIG WINDOW
-------------------------------------------------------------------------------

local function createConfigFrame()
    if ascensionBars.configFrame then return end

    ascensionBars.configFrame = CreateFrame("Frame", "AscensionBarsConfigFrame", UIParent, "BackdropTemplate")
    local configFrame = ascensionBars.configFrame
    configFrame:SetSize(ascensionBars.normalWidth or 750, ascensionBars.normalHeight or 500)
    configFrame:SetPoint("CENTER")
    configFrame:SetMovable(true)
    configFrame:EnableMouse(true)
    configFrame:RegisterForDrag("LeftButton")
    configFrame:SetScript("OnDragStart", configFrame.StartMoving)
    configFrame:SetScript("OnDragStop", configFrame.StopMovingOrSizing)
    
    configFrame:SetResizable(true)
    configFrame:SetResizeBounds(600, 400) -- Minimum size to prevent UI overlap
    configFrame:SetFrameStrata("HIGH")
    
    configFrame:SetBackdrop({
        bgFile = files.bgFile,
        edgeFile = files.edgeFile,
        edgeSize = menuStyle.backdropEdgeSize,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    configFrame:SetBackdropColor(unpack(colors.backgroundDark)) -- #050508
    configFrame:SetBackdropBorderColor(unpack(colors.surfaceHighlight)) -- #2A243D

    local title = configFrame:CreateFontString(nil, "OVERLAY", menuStyle.headerFont)
    title:SetPoint("TOPLEFT", menuStyle.titleLeft, menuStyle.titleTop)
    title:SetText(Locales["ADDON_NAME"])
    title:SetTextColor(unpack(colors.gold))

    -- Standard close button
    local closeButton = CreateFrame("Button", nil, configFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", configFrame, "TOPRIGHT", -4, -4)

    -- Resize grip button
    local resizeGrip = CreateFrame("Button", nil, configFrame)
    resizeGrip:SetPoint("BOTTOMRIGHT", configFrame, "BOTTOMRIGHT", -6, 6)
    resizeGrip:SetSize(16, 16)
    resizeGrip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeGrip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resizeGrip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    
    resizeGrip:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            configFrame:StartSizing("BOTTOMRIGHT")
        end
    end)
    
    resizeGrip:SetScript("OnMouseUp", function()
        configFrame:StopMovingOrSizing()
        -- Force layout redraw to adjust columns to the new width
        if ascensionBars.configTabs and ascensionBars.configTabs.getActiveTab then
            ascensionBars.configTabs.selectTab(ascensionBars.configTabs.getActiveTab())
        end
    end)

    local resetButton = CreateFrame("Button", nil, configFrame, "UIPanelButtonTemplate")
    -- Standardized button height from menuStyle
    resetButton:SetSize(130, menuStyle.buttonHeight)
    resetButton:SetPoint("BOTTOMLEFT", menuStyle.contentPadding, menuStyle.contentPadding + 24)
    resetButton:SetText(Locales["FACTION_STANDINGS_RESET"])
    resetButton:SetScript("OnClick", function()
        if ascensionBars.db then
            ascensionBars.db:ResetProfile()
            ascensionBars:updateDisplay()
            ascensionBars.configTabs.selectTab(1)
        end
    end)

    local configModeCheck = CreateFrame("CheckButton", nil, configFrame, "UICheckButtonTemplate")
    -- Aligned with internal padding and standardized size
    configModeCheck:SetPoint("BOTTOMLEFT", menuStyle.contentPadding, 8)
    configModeCheck:SetSize(menuStyle.checkboxSize, menuStyle.checkboxSize)
    configModeCheck.text = configModeCheck:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    configModeCheck.text:SetPoint("LEFT", configModeCheck, "RIGHT", 5, 0)
    configModeCheck.text:SetText(Locales["CONFIG_MODE"])

    local tabNames = {
        Locales["TAB_BARS_LAYOUT"],
        Locales["TAB_TEXT_LAYOUT"],
        Locales["TAB_BEHAVIOR"],
        Locales["TAB_COLORS"],
        Locales["TAB_PARAGON_ALERTS"]
    }
    local buildFuncs = { buildLayoutTab, buildAppearanceTab, buildBehaviorTab, buildColorsTab, buildParagonTab }

    ascensionBars.configTabs = createTabbedInterface(configFrame, tabNames, buildFuncs, 1)
    configFrame:Hide()
end

function ascensionBars:refreshConfigUI()
    if self.configFrame then
        local wasShown = self.configFrame:IsShown()
        local currentTab = self.configTabs and self.configTabs.getActiveTab() or 1

        self.configFrame:Hide()
        self.configFrame = nil
        self.configTabs = nil

        self:toggleConfig()

        if wasShown then
            self.configTabs.selectTab(currentTab)
        else
            self.configFrame:Hide()
        end
    end
end

function ascensionBars:refreshConfig() self:refreshConfigUI() end

function ascensionBars:toggleConfig()
    if not self.configFrame then createConfigFrame() end
    if self.configFrame then
        if self.configFrame:IsShown() then self.configFrame:Hide() else self.configFrame:Show() end
    end
end

-------------------------------------------------------------------------------
-- BLIZZARD OPTIONS PANEL (Simplified)
-------------------------------------------------------------------------------

local blizzardPanel = CreateFrame("Frame", "AscensionBars_BlizPanel", UIParent)
blizzardPanel.name = Locales["ADDON_NAME"] or addonName
blizzardPanel:Hide()

--- Builds the simplified Blizzard interface consisting of a single large button
local function buildBlizUI()
    if blizzardPanel.isInitialized then return end

    -- Section Title
    local title = blizzardPanel:CreateFontString(nil, "OVERLAY", menuStyle.headerFont)
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(blizzardPanel.name)
    title:SetTextColor(unpack(colors.gold)) -- #FFCC33

    -- Explanatory Description
    local description = blizzardPanel:CreateFontString(nil, "OVERLAY", menuStyle.descFont)
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -12)
    description:SetPoint("RIGHT", -16, 0)
    description:SetJustifyH("LEFT")
    description:SetText("All configuration options have been moved to a specialized high-performance menu for a better user experience.")

    -- Large Action Button
    local openMenuButton = CreateFrame("Button", nil, blizzardPanel, "UIPanelButtonTemplate")
    openMenuButton:SetSize(280, 45)
    openMenuButton:SetPoint("CENTER", blizzardPanel, "CENTER", 0, 0)
    openMenuButton:SetText("OPEN ASCENSION SETTINGS")

    openMenuButton:SetScript("OnClick", function()
        -- Close the Blizzard Settings panel to avoid UI overlap
        if SettingsPanel and SettingsPanel:IsShown() then
            SettingsPanel:Close()
        end
        
        -- Open the custom Ascension Config Frame
        ascensionBars:toggleConfig()
    end)

    blizzardPanel.isInitialized = true
end

blizzardPanel:SetScript("OnShow", buildBlizUI)

--- Registers the panel within the modern 12.0.0 Settings API
local function registerBlizzardOptions()
    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(blizzardPanel, blizzardPanel.name)
        Settings.RegisterAddOnCategory(category)
    else
        -- Fallback for older API versions if necessary
        local addCategory = _G["InterfaceOptions_AddCategory"]
        if addCategory then 
            addCategory(blizzardPanel) 
        end
    end
end

-- Initialize registration
if ascensionBars:IsEnabled() or (ascensionBars.db) then
    registerBlizzardOptions()
else
    local oldInit = ascensionBars.OnInitialize
    ascensionBars.OnInitialize = function(self)
        if type(oldInit) == "function" then 
            oldInit(self) 
        end
        registerBlizzardOptions()
    end
end