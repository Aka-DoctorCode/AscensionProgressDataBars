-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: TextLayout.lua
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

-- Shared utilities mapped from the main table
local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

-- Object-Oriented module for the Text Layout Tab
addonTable.textLayoutTab = {}
local textLayoutTab = addonTable.textLayoutTab

function textLayoutTab:createTextControls(layout, profile, barKey, panel, controlWidth, xOffset)
    if not profile or not profile.bars or not profile.bars[barKey] then return end
    
    local bar = profile.bars[barKey]

    -- UX IMPROVEMENT: Encapsulate the text configuration inside a visual Card
    layout:beginSection(xOffset, controlWidth)

    -- Reduce internal padding by half (from 10 to 5)
    local innerX = xOffset + 5
    local innerWidth = controlWidth - 10

    -- Apply the header gold color to the label
    layout:label("TextHeader_" .. barKey, barKey, innerX, colors.gold)
    
    layout:dropdown("TextAnchorDropdown_" .. barKey, locales["ANCHOR"],
        {
            { label = locales["GROUP_1"], value = "T1" },
            { label = locales["GROUP_2"], value = "T2" },
            { label = locales["GROUP_3"], value = "T3" }
        },
        function() return bar.textBlock or "T1" end,
        function(v)
            local oldBlock = bar.textBlock or "T1"
            bar.textBlock = v
            addonTable.configUtils:cleanOrders(profile, "textBlock", "textOrder", oldBlock)
            bar.textOrder = math.max(1, addonTable.configUtils:getCount(profile, "textBlock", v))
            ascensionBars:updateDisplay()
            if panel and panel.updateLayout then 
                _G.C_Timer.After(0.01, function() panel:updateLayout() end) 
            end
        end,
        innerWidth, innerX)

    local orderOptions = {}
    local count = addonTable.configUtils:getCount(profile, "textBlock", bar.textBlock or "T1")
    for j = 1, count do
        table.insert(orderOptions, { label = tostring(j), value = j })
    end
    
    layout:dropdown("TextOrderDropdown_" .. barKey, locales["ORDER"], orderOptions,
        function() return bar.textOrder or 1 end,
        function(v)
            local oldOrder = bar.textOrder or 1
            if oldOrder == v then return end
            
            local targetOrder = (v > oldOrder) and (v + 0.5) or (v - 0.5)
            bar.textOrder = targetOrder
            addonTable.configUtils:cleanOrders(profile, "textBlock", "textOrder", bar.textBlock or "T1")
            
            ascensionBars:updateDisplay()
            if panel and panel.updateLayout then 
                _G.C_Timer.After(0.01, function() panel:updateLayout() end) 
            end
        end,
        innerWidth, innerX)

    -- Close the Card logic
    layout:endSection()
    
    -- Small gap before the next card in the column
    layout.y = layout.y - 15
end

function textLayoutTab:build(panel)
    if not panel or not panel.content then return end
    
    addonTable.configUtils:cleanupContent(panel.content)
    
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    local layout = addonTable.layoutModel:new(content, -16)
    
    layout:header("TextAndFontHeader", locales["TEXT_AND_FONT"])
    
    layout:dropdown("LayoutModeDropdown", locales["LAYOUT_MODE"],
        {
            { label = locales["ALL_IN_ONE_LINE"], value = "SINGLE_LINE" },
            { label = locales["MULTIPLE_LINES"],  value = "INDIVIDUAL_LINES" }
        },
        function() return profile.textLayoutMode end,
        function(v)
            profile.textLayoutMode = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end
        end,
        180, 15)

    if profile.textLayoutMode == "INDIVIDUAL_LINES" then
        layout:checkbox("TextFollowsBarCheckbox", locales["TEXT_FOLLOWS_BAR"], locales["TEXT_FOLLOWS_BAR_DESC"],
            function() return profile.textFollowBar end,
            function(v)
                profile.textFollowBar = v
                ascensionBars:updateDisplay()
            end,
            25)
    end

    layout:slider("FontSizeSlider", locales["FONT_SIZE"], 8, 32, 1,
        function() return profile.textSize end,
        function(v)
            profile.textSize = v
            ascensionBars:updateDisplay()
        end,
        180, 15)

    layout:colorPicker("GlobalTextColorPicker", locales["GLOBAL_TEXT_COLOR"],
        function()
            local c = profile.textColor
            if not c then return 1, 1, 1, 1 end -- #FFFFFF
            return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.textColor then profile.textColor = {} end
            local c = profile.textColor
            c.r = r
            c.g = g
            c.b = b
            c.a = a
            ascensionBars:updateDisplay()
        end,
        15, true)

    layout:header("TextGroupPositionsHeader", locales["TEXT_GROUP_POSITIONS"])
    
    local startY = layout.y
    local defaultAvailableSpace = (ascensionBars.normalWidth or 750) - (menuStyle.sidebarWidth or 150) - 30
    local colGap = 10
    local colWidth = (defaultAvailableSpace - (colGap * 2)) / 3
    local maxColY = startY

    for i = 1, 3 do
        local groupKey = "T" .. i
        local xOff = 15 + (i - 1) * colWidth
        local layoutGroup = addonTable.layoutModel:new(content, startY)
        local settings = profile.textGroups[groupKey] or { detached = true, x = 0, y = -25 * i }

        layoutGroup:checkbox("DetachGroupCheckbox_" .. i, string.format(locales["DETACH_GROUP"], i),
            string.format(locales["DETACH_GROUP_DESC"], i),
            function() return settings.detached end,
            function(v)
                settings.detached = v
                ascensionBars:updateDisplay()
                if panel.updateLayout then panel:updateLayout() end
            end,
            xOff)

        if settings.detached then
            layoutGroup:slider("GroupXSlider_" .. i, string.format(locales["GROUP_X"], i), -1000, 1000, 1,
                function() return settings.x end,
                function(v)
                    settings.x = v
                    ascensionBars:updateDisplay()
                end,
                colWidth - 20, xOff + 5)
                
            layoutGroup:slider("GroupYSlider_" .. i, string.format(locales["GROUP_Y"], i), -1000, 1000, 1,
                function() return settings.y end,
                function(v)
                    settings.y = v
                    ascensionBars:updateDisplay()
                end,
                colWidth - 20, xOff + 5)
        end

        if layoutGroup.y < maxColY then 
            maxColY = layoutGroup.y 
        end
    end

    layout.y = maxColY - 10
    layout:header("TextManagementHeader", locales["TEXT_MANAGEMENT"])
    startY = layout.y

    local textBlocks = {
        { name = locales["GROUP_1"], key = "T1", x = 10 },
        { name = locales["GROUP_2"], key = "T2", x = 10 + colWidth + colGap },
        { name = locales["GROUP_3"], key = "T3", x = 10 + (colWidth + colGap) * 2 }
    }
    local maxBottomY = startY

    for _, block in ipairs(textBlocks) do
        local layoutCol = addonTable.layoutModel:new(content, startY)
        
        local header = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
        header:SetPoint("TOPLEFT", block.x, startY)
        header:SetWidth(colWidth)
        header:SetJustifyH("CENTER")
        header:SetText(block.name)
        header:SetTextColor(unpack(colors.primary)) -- #FFD100
        
        layoutCol.y = startY - 25

        local sorted = {}
        for k, b in pairs(profile.bars) do
            if (b.textBlock or "T1") == block.key then
                table.insert(sorted, { key = k, order = b.textOrder or 0 })
            end
        end
        
        table.sort(sorted, function(a, b) return a.order < b.order end)

        for _, td in ipairs(sorted) do
            self:createTextControls(layoutCol, profile, td.key, panel, colWidth, block.x)
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

    content:SetHeight(math.abs(maxBottomY) + 20)
end