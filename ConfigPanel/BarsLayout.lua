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

    -- UX IMPROVEMENT: Encapsulate the entire bar configuration inside a visual Card
    layout:beginSection(xOffset, controlWidth)

    -- Reduce internal padding by half (from 10 to 5)
    local innerX = xOffset + 5
    local innerWidth = controlWidth - 10

    -- Apply the header gold color to the label
    layout:label("BarHeader_" .. barKey, displayName, innerX, colors.gold)
    
    layout:checkbox("EnableBarCheckbox_" .. barKey, locales["ENABLE"], nil,
        function() return bar.enabled end,
        function(v)
            bar.enabled = v
            ascensionBars:updateDisplay()
        end,
        innerX)

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
            if panel and panel.updateLayout then 
                _G.C_Timer.After(0.01, function() panel:updateLayout() end) 
            end
        end,
        innerWidth, innerX)

    -- UX IMPROVEMENT: Hide 'Order' Dropdown entirely if the bar is freely moved via coordinates
    if bar.block ~= "FREE" then
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
                if panel and panel.updateLayout then 
                    _G.C_Timer.After(0.01, function() panel:updateLayout() end) 
                end
            end,
            innerWidth, innerX)
    end

    if profile.textLayoutMode == "INDIVIDUAL_LINES" then
        layout:slider("TextXSlider_" .. barKey, locales["TXT_X"], -500, 500, 1,
            function() return bar.textX or 0 end,
            function(v)
                bar.textX = v
                ascensionBars:updateDisplay()
            end,
            innerWidth - 20, innerX + 10)

        layout:slider("TextYSlider_" .. barKey, locales["TXT_Y"], -500, 500, 1,
            function() return bar.textY or 0 end,
            function(v)
                bar.textY = v
                ascensionBars:updateDisplay()
            end,
            innerWidth - 20, innerX + 10)
    end

    if bar.block == "FREE" then
        layout:slider("WidthSlider_" .. barKey, locales["WIDTH"], 50, 2000, 1,
            function() return bar.freeWidth end,
            function(v)
                bar.freeWidth = v
                ascensionBars:updateDisplay()
            end,
            innerWidth - 20, innerX + 10)

        layout:slider("HeightSlider_" .. barKey, locales["HEIGHT"], 2, 100, 1,
            function() return bar.freeHeight or 15 end,
            function(v)
                bar.freeHeight = v
                ascensionBars:updateDisplay()
            end,
            innerWidth - 20, innerX + 10)

        layout:slider("PosXSlider_" .. barKey, locales["POS_X"], -1000, 1000, 1,
            function() return bar.freeX end,
            function(v)
                bar.freeX = v
                ascensionBars:updateDisplay()
            end,
            innerWidth - 20, innerX + 10)

        layout:slider("PosYSlider_" .. barKey, locales["POS_Y"], -1000, 1000, 1,
            function() return bar.freeY end,
            function(v)
                bar.freeY = v
                ascensionBars:updateDisplay()
            end,
            innerWidth - 20, innerX + 10)
    end

    -- Close the Card logic
    layout:endSection()
    
    -- Small gap before the next card in the column
    layout.y = layout.y - 15
end

function barsLayoutTab:build(panel)
    if not panel or not panel.content then return end
    
    addonTable.configUtils:cleanupContent(panel.content)
    
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    -- Default NormalWidth(750) - SidebarWidth(~150) - SafeMargins(30)
    local defaultAvailableSpace = (ascensionBars.normalWidth or 750) - (menuStyle.sidebarWidth or 150) - 30
    local colGap = 10
    local colWidth = (defaultAvailableSpace - (colGap * 2)) / 3

    local y = -15

    -- SECCIÓN 1: GLOBAL OFFSET
    local mainLayout = addonTable.layoutModel:new(content, y)
    mainLayout:header("GlobalOffsetHeader", locales["GLOBAL_OFFSET"])
    local afterHeaderY = mainLayout.y

    mainLayout:slider("GlobalBlocksOffsetSlider", locales["GLOBAL_BLOCKS_OFFSET"], -100, 100, 1,
        function() return profile.yOffset end,
        function(v) 
            profile.yOffset = v 
            ascensionBars:updateDisplay() 
        end,
        180, 15)

    mainLayout:slider("GlobalBarHeightSlider", locales["GLOBAL_BAR_HEIGHT"], 1, 50, 1,
        function() return profile.globalBarHeight end,
        function(v) 
            profile.globalBarHeight = v 
            for _, b in pairs(profile.bars) do b.freeHeight = v end 
            ascensionBars:updateDisplay() 
        end,
        180, 15)

    -- Spacer before next section
    mainLayout.y = mainLayout.y - 10
    
    mainLayout:header("BarManagementHeader", locales["BAR_MANAGEMENT"])
    local startY = mainLayout.y

    local blocks = {
        { name = locales["TOP_BLOCK"],    key = "TOP",    x = 10 },
        { name = locales["BOTTOM_BLOCK"], key = "BOTTOM", x = 10 + colWidth + colGap },
        { name = locales["FREE_MODE"],    key = "FREE",   x = 10 + (colWidth + colGap) * 2 }
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
        header:SetWidth(colWidth)
        header:SetJustifyH("CENTER")
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
            self:createBarControls(layoutCol, profile, bar.key, bar.name, panel, colWidth, block.x)
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