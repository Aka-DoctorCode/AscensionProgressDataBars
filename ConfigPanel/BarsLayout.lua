-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: BarsLayout.lua
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
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

-- Use the shared utilities that will be defined in our main ConfigMain.lua
local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

-- Object-Oriented module for the Bars Layout Tab
addonTable.barsLayoutTab = {}
local barsLayoutTab = addonTable.barsLayoutTab

function barsLayoutTab:createBarControls(layout, profile, barKey, displayName, panel, controlWidth, xOffset)
    if not profile or not profile.bars or not profile.bars[barKey] then return end
    
    local bar = profile.bars[barKey]

    layout:label("BarHeader_" .. barKey, displayName, xOffset + 5)
    
    layout:checkbox("EnableBarCheckbox_" .. barKey, locales["ENABLE"], nil,
        function() return bar.enabled end,
        function(v)
            bar.enabled = v
            ascensionBars:updateDisplay()
        end,
        xOffset + 10)

    layout:dropdown("AnchorDropdown_" .. barKey, locales["ANCHOR"],
        {
            { label = locales["TOP"],    value = "TOP" },
            { label = locales["BOTTOM"], value = "BOTTOM" },
            { label = locales["FREE"],   value = "FREE" }
        },
        function() return bar.block end,
        function(v)
            local oldBlock = bar.block
            bar.block = v
            addonTable.configUtils:cleanOrders(profile, "block", "order", oldBlock)
            bar.order = math.max(1, addonTable.configUtils:getCount(profile, "block", v))
            ascensionBars:updateDisplay()
            if panel and panel.updateLayout then panel:updateLayout() end
        end,
        xOffset + 10)

    local orderOptions = {}
    local count = addonTable.configUtils:getCount(profile, "block", bar.block)
    for j = 1, count do
        table.insert(orderOptions, { label = tostring(j), value = j })
    end
    
    layout:dropdown("OrderDropdown_" .. barKey, locales["ORDER"], orderOptions,
        function() return bar.order or 1 end,
        function(v)
            local oldOrder = bar.order or 1
            if oldOrder == v then return end
            
            local targetOrder = (v > oldOrder) and (v + 0.5) or (v - 0.5)
            bar.order = targetOrder
            addonTable.configUtils:cleanOrders(profile, "block", "order", bar.block or "TOP")
            
            ascensionBars:updateDisplay()
            if panel and panel.updateLayout then panel:updateLayout() end
        end,
        xOffset + 10)

    if profile.textLayoutMode == "INDIVIDUAL_LINES" then
        layout:slider("TextXSlider_" .. barKey, locales["TXT_X"], -500, 500, 1,
            function() return bar.textX or 0 end,
            function(v)
                bar.textX = v
                ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)

        layout:slider("TextYSlider_" .. barKey, locales["TXT_Y"], -500, 500, 1,
            function() return bar.textY or 0 end,
            function(v)
                bar.textY = v
                ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)
    end

    if bar.block == "FREE" then
        layout:slider("WidthSlider_" .. barKey, locales["WIDTH"], 50, 2000, 1,
            function() return bar.freeWidth end,
            function(v)
                bar.freeWidth = v
                ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)

        layout:slider("HeightSlider_" .. barKey, locales["HEIGHT"], 2, 100, 1,
            function() return bar.freeHeight or 15 end,
            function(v)
                bar.freeHeight = v
                ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)

        layout:slider("PosXSlider_" .. barKey, locales["POS_X"], -1000, 1000, 1,
            function() return bar.freeX end,
            function(v)
                bar.freeX = v
                ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)

        layout:slider("PosYSlider_" .. barKey, locales["POS_Y"], -1000, 1000, 1,
            function() return bar.freeY end,
            function(v)
                bar.freeY = v
                ascensionBars:updateDisplay()
            end,
            controlWidth, xOffset + 15)
    end

    layout.y = layout.y - 15
end

function barsLayoutTab:build(panel)
    if not panel or not panel.content then return end
    
    addonTable.configUtils:cleanupContent(panel.content)
    
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    local scrollFrame = panel.scrollFrame
    local panelWidth = scrollFrame and scrollFrame:GetWidth() - 30 or 600
    panelWidth = math.max(panelWidth, 400)
    content:SetWidth(panelWidth)
    local colWidth = (panelWidth - 80) / 3

    local y = -15

    -- SECCIÓN 1: GLOBAL OFFSET
    local mainLayout = addonTable.layoutModel:new(content, y)
    mainLayout:header("GlobalOffsetHeader", locales["GLOBAL_OFFSET"])
    local afterHeaderY = mainLayout.y

    -- Sliders (usando afterHeaderY como punto de partida)
    local slider1, newY1 = addonTable.layoutFactory:createSlider({
        elementID = "GlobalBlocksOffsetSlider", 
        parent = content,
        text = locales["GLOBAL_BLOCKS_OFFSET"], 
        minVal = -100, maxVal = 100, step = 1,
        getter = function() return profile.yOffset end,
        setter = function(v) profile.yOffset = v; ascensionBars:updateDisplay() end,
        width = 180, yOffset = afterHeaderY, xOffset = 15
    })

    local slider2, newY2 = addonTable.layoutFactory:createSlider({
        elementID = "GlobalBarHeightSlider", 
        parent = content,
        text = locales["GLOBAL_BAR_HEIGHT"], 
        minVal = 1, maxVal = 50, step = 1,
        getter = function() return profile.globalBarHeight end,
        setter = function(v) profile.globalBarHeight = v; for _, b in pairs(profile.bars) do b.freeHeight = v end; ascensionBars:updateDisplay() end,
        width = 180, yOffset = newY1, xOffset = 15
    })

    -- Espacio adicional opcional antes de la siguiente sección
    local mainY = newY2 - 10

    -- SECCIÓN 2: BAR MANAGEMENT
    local mainLayout2 = addonTable.layoutModel:new(content, mainY)
    mainLayout2:header("BarManagementHeader", locales["BAR_MANAGEMENT"])
    local startY = mainLayout2.y

    local blocks = {
        { name = locales["TOP_BLOCK"],    key = "TOP",    x = 10 },
        { name = locales["BOTTOM_BLOCK"], key = "BOTTOM", x = 10 + colWidth + 5 },
        { name = locales["FREE_MODE"],    key = "FREE",   x = 10 + (colWidth + 5) * 2 }
    }

    local barKeys = { "XP", "Rep", "Honor", "HouseXp", "Azerite" }
    local barNames = { 
        locales["EXPERIENCE"], 
        locales["REPUTATION"], 
        locales["HONOR"], 
        locales["HOUSE_FAVOR"], 
        locales["AZERITE"] 
    }

    local maxBottomY = startY

    for _, block in ipairs(blocks) do
        local layoutCol = addonTable.layoutModel:new(content, startY)
        
        local header = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
        header:SetPoint("TOPLEFT", block.x, startY)
        header:SetText(block.name)
        header:SetTextColor(unpack(colors.primary)) -- #FFD100
        
        layoutCol.y = startY - 25

        local sorted = {}
        for i, key in ipairs(barKeys) do
            local bar = profile.bars[key]
            if bar and (bar.block or "TOP") == block.key then
                table.insert(sorted, { key = key, name = barNames[i] })
            end
        end
        
        table.sort(sorted, function(a, b) 
            local orderA = (profile.bars[a.key] and profile.bars[a.key].order) or 99
            local orderB = (profile.bars[b.key] and profile.bars[b.key].order) or 99
            return orderA < orderB
        end)

        for _, bar in ipairs(sorted) do
            self:createBarControls(layoutCol, profile, bar.key, bar.name, panel, colWidth - 40, block.x)
        end

        if #sorted == 0 then
            local empty = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
            empty:SetPoint("TOPLEFT", block.x + 10, layoutCol.y)
            empty:SetText(locales["EMPTY"])
            empty:SetTextColor(0.5, 0.5, 0.5, 1) -- #808080
            layoutCol.y = layoutCol.y - 20
        end

        if layoutCol.y < maxBottomY then 
            maxBottomY = layoutCol.y 
        end
    end

    content:SetHeight(math.abs(maxBottomY) + 50)
end