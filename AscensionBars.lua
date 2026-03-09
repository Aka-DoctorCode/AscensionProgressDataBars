-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: AscensionBars.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------
---
local addonName, _ = ...
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local ascensionBars = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceConsole-3.0")

-------------------------------------------------------------------------------
-- LOCAL VARIABLES
-------------------------------------------------------------------------------
local texturePool = {}
local lastUpdate = 0

-------------------------------------------------------------------------------
-- UTILITIES (definidas primero)
-------------------------------------------------------------------------------
function ascensionBars:getPlayerMaxLevel()
    if _G.GetMaxLevelForLatestExpansion then
        local maxLevel = _G.GetMaxLevelForLatestExpansion()
        if maxLevel then return maxLevel end
    end
    return 80
end

function ascensionBars:getClassColor()
    if not self.state then return { r = 1, g = 1, b = 1, a = 1 } end
    if not self.state.cachedClassColor then
        local _, classFilename = UnitClass("player")
        if classFilename then
            local classColor = C_ClassColor.GetClassColor(classFilename)
            if classColor then
                self.state.cachedClassColor = classColor
                return self.state.cachedClassColor
            end
        end
        self.state.cachedClassColor = { r = 1, g = 1, b = 1, a = 1 }
    end
    return self.state.cachedClassColor
end

function ascensionBars:hideBlizzardFrames()
    local framesToHide = { _G.StatusTrackingBarManager, _G.UIWidgetPowerBarContainerFrame }
    for _, frame in pairs(framesToHide) do
        if frame then
            frame:UnregisterAllEvents()
            frame:Hide()
            frame:SetAlpha(0)
            frame.Show = function() end
        end
    end
end

function ascensionBars:formatXP()
    local currentXP, maxXP = UnitXP("player") or 0, UnitXPMax("player") or 1
    local percentage = (maxXP > 0 and currentXP / maxXP * 100) or 0
    if not self.db or not self.db.profile then return "" end
    local profile = self.db.profile
    local text = ""
    if profile and profile.showAbsoluteValues then
        if profile.showPercentage then
            text = string.format(Locales["LEVEL_TEXT_ABS_PCT"] or "%d | %s / %s (%d%%)", UnitLevel("player") or 0,
                BreakUpLargeNumbers(currentXP),
                BreakUpLargeNumbers(maxXP), percentage)
        else
            text = string.format(Locales["LEVEL_TEXT_ABS"] or "%d | %s / %s", UnitLevel("player") or 0,
                BreakUpLargeNumbers(currentXP),
                BreakUpLargeNumbers(maxXP))
        end
    elseif profile and profile.showPercentage then
        text = string.format(Locales["LEVEL_TEXT_PCT"] or "%d | %d%%", UnitLevel("player") or 0, percentage)
    else
        text = string.format(Locales["LEVEL_TEXT"] or "%d", UnitLevel("player") or 0)
    end
    local rested = GetXPExhaustion()
    if rested and rested > 0 and profile and profile.showRestedBar then
        text = text .. string.format(Locales["RESTED_TEXT"] or " (+%d%%)", (maxXP > 0 and rested / maxXP * 100) or 0)
    end
    return text
end

-------------------------------------------------------------------------------
-- FRAME CREATION (definidas antes de OnInitialize)
-------------------------------------------------------------------------------
function ascensionBars:createFrames()
    self.textHolders = {}
    for i = 1, 3 do
        local key = "T" .. i
        local holder = CreateFrame("Frame", "AscensionBars_TextHolder" .. key, UIParent)
        holder:SetFrameStrata("HIGH")
        holder:SetClipsChildren(false)
        holder:SetHeight(20)
        holder:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        self.textHolders[key] = holder
    end
    self.textHolder = self.textHolders.T1

    if not self.hoverFrame then
        self.hoverFrame = CreateFrame("Frame", "AscensionBars_HoverFrame", UIParent)
        self.hoverFrame:SetAllPoints(UIParent)
        self.hoverFrame:SetFrameStrata("BACKGROUND")
        self.hoverFrame:EnableMouse(false)
    end

    self.xp = self:createBar("AscensionXPBar_XP")
    self.rep = self:createBar("AscensionXPBar_Rep")
    self.honor = self:createBar("AscensionXPBar_Honor")
    self.houseXp = self:createBar("AscensionXPBar_HouseXp")
    self.azerite = self:createBar("AscensionXPBar_Azerite")

    if self.honor then self.honor.bar:Hide() end
    if self.houseXp then self.houseXp.bar:Hide() end
    if self.azerite then self.azerite.bar:Hide() end

    self.paragonText = self.textHolder:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
end
function ascensionBars:createBar(name)
    local bar = CreateFrame("StatusBar", name, UIParent)
    bar:SetFrameStrata("LOW")
    bar:EnableMouse(true)
    bar:SetScript("OnEnter", function()
        self.state.isHovering = true; self:updateVisibility()
    end)
    bar:SetScript("OnLeave", function()
        self.state.isHovering = false; self:updateVisibility()
    end)
    bar:SetStatusBarTexture(self.constants.TEXTURE_BAR)
    bar:SetClipsChildren(true)

    local background = self:acquireTexture(bar)
    background:SetAllPoints()
    background:SetTexture(self.constants.TEXTURE_BAR)
    
    local bgAlpha = (self.db and self.db.profile and self.db.profile.backgroundAlpha) or 0.5
    background:SetVertexColor(0, 0, 0, bgAlpha) -- #000000
    background:SetDrawLayer("BACKGROUND", -1)

    local spark = bar:CreateTexture(nil, "ARTWORK")
    spark:SetTexture(self.constants.TEXTURE_SPARK)
    spark:SetSize(6, 6)
    spark:SetBlendMode("ADD")

    local restedOverlay = (name == "AscensionXPBar_XP") and bar:CreateTexture(nil, "ARTWORK") or nil

    local txFrame = CreateFrame("Frame", nil, self.textHolder)
    txFrame:SetSize(self.constants.MIN_TEXT_WIDTH, 20)

    local text = txFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    text:SetAllPoints()

    return {
        bar = bar,
        spark = spark,
        txFrame = txFrame,
        text = text,
        restedOverlay = restedOverlay,
        background = background
    }
end

function ascensionBars:acquireTexture(parent)
    for i = 1, #texturePool do
        if not texturePool[i]:IsShown() and texturePool[i]:GetParent() == parent then
            texturePool[i]:Show()
            return texturePool[i]
        end
    end
    local texture = parent:CreateTexture(nil, "BACKGROUND")
    table.insert(texturePool, texture)
    return texture
end

function ascensionBars:cleanupTextures()
    for i = 1, #texturePool do texturePool[i]:Hide() end
end

-------------------------------------------------------------------------------
-- DISPLAY HELPERS
-------------------------------------------------------------------------------
function ascensionBars:updateSpark(bar, minVal, maxVal, currentVal)
    if not (self.db and self.db.profile and self.db.profile.sparkEnabled) then
        if bar and bar.spark then bar.spark:Hide() end
        return
    end
    local percentage = (maxVal > minVal) and (currentVal - minVal) / (maxVal - minVal) or 0
    bar.spark:SetPoint("CENTER", bar.bar, "LEFT", bar.bar:GetWidth() * percentage, 0)
    bar.spark:Show()
end

function ascensionBars:setupBar(bar, minVal, maxVal, currentVal, color)
    if maxVal <= minVal then maxVal = minVal + 1 end
    bar.bar:SetMinMaxValues(minVal, maxVal)
    bar.bar:SetValue(currentVal)
    bar.bar:SetStatusBarColor(color.r, color.g, color.b, color.a or 1)
    self:updateSpark(bar, minVal, maxVal, currentVal)
end

function ascensionBars:updateStandardBar(barObj, barKey, currentFunc, maxFunc, colorFunc, textFunc)
    local db = self.db
    if not db then return end
    local profile = db.profile
    if not profile or not profile.bars then return end
    local config = profile.bars[barKey]
    if not config or not config.enabled then
        if barObj then
            barObj.bar:Hide(); barObj.txFrame:Hide()
        end
        return
    end
    barObj.bar:Show(); barObj.txFrame:Show()
    local current = currentFunc()
    local maxVal = maxFunc()
    if maxVal == 0 then maxVal = 1 end
    local color = colorFunc()
    self:setupBar(barObj, 0, maxVal, current, color)
    barObj.text:SetText(textFunc(current, maxVal, (current / maxVal) * 100))
    local textColor = profile and profile.textColor
    if textColor then
        barObj.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, textColor.a or 1)
    end
end

-------------------------------------------------------------------------------
-- DISPLAY FUNCTIONS
-------------------------------------------------------------------------------
function ascensionBars:applyTextStyles()
    local db = self.db
    if not db then return end
    local profile = db.profile
    if not profile then return end
    local font = profile.fontPath or [[Fonts\FRIZQT__.TTF]]
    local size = profile.textSize or 14
    local barList = { self.xp, self.rep, self.honor, self.houseXp, self.azerite }
    for _, obj in ipairs(barList) do
        if obj and obj.text then
            obj.text:SetFont(font, size, "OUTLINE")
            local textColor = profile and profile.textColor
            if textColor then
                obj.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, textColor.a or 1)
            end
        end
    end
end

function ascensionBars:updateTextAnchors()
    local db = self.db
    if not db then return end
    local profile = db.profile
    if not profile then return end
    local barList = {
        { obj = self.xp,      key = "XP" },
        { obj = self.rep,     key = "Rep" },
        { obj = self.honor,   key = "Honor" },
        { obj = self.houseXp, key = "HouseXp" },
        { obj = self.azerite, key = "Azerite" }
    }

    local groups = { T1 = {}, T2 = {}, T3 = {} }
    for _, entry in ipairs(barList) do
        local config = profile.bars[entry.key]
        if config and config.enabled then
            local blockKey = config.textBlock or "T1"
            table.insert(groups[blockKey], entry)
        end
    end

    for gKey, activeFrames in pairs(groups) do
        table.sort(activeFrames, function(a, b)
            local bars = profile and profile.bars
            local barA = bars and bars[a.key]
            local barB = bars and bars[b.key]
            local orderA = barA and barA.textOrder or 0
            local orderB = barB and barB.textOrder or 0
            return orderA < orderB
        end)

        if #activeFrames > 0 then
            local gap = profile and profile.textGap or ascensionBars.constants.DEFAULT_GAP
            local totalWidth = 0
            for _, data in ipairs(activeFrames) do
                local getStringWidth = data.obj and data.obj.text and data.obj.text.GetStringWidth
                local textWidth = math.max((getStringWidth and data.obj.text:GetStringWidth() or 0) + 5,
                    ascensionBars.constants.MIN_TEXT_WIDTH)
                data.width = textWidth
                totalWidth = totalWidth + textWidth
            end
            totalWidth = totalWidth + (gap * (#activeFrames - 1))

            local container = self.textHolders[gKey]
            if container then
                container:Show()
                container:SetWidth(totalWidth)
                local gSet = profile.textGroups[gKey] or { detached = true, x = 0, y = 0 }

                if gSet.detached then
                    container:ClearAllPoints()
                    container:SetPoint("TOP", UIParent, "TOP", gSet.x, gSet.y)
                elseif gKey == "T1" and profile.textFollowBar then
                    local lowestBar
                    local lowestY = 9999
                    for _, b in ipairs({ self.xp, self.rep, self.honor, self.houseXp, self.azerite }) do
                        if b and b.bar and b.bar:IsShown() and b.bar.GetPoint then
                            local _, _, _, _, yValue = b.bar:GetPoint()
                            if yValue and yValue < lowestY then
                                lowestY = yValue
                                lowestBar = b.bar
                            end
                        end
                    end
                    if lowestBar then
                        container:ClearAllPoints()
                        container:SetPoint("TOP", lowestBar, "BOTTOM", 0, -5)
                    end
                else
                    container:ClearAllPoints()
                    container:SetPoint("TOP", UIParent, "TOP", gSet.x, gSet.y)
                end

                for i, data in ipairs(activeFrames) do
                    data.obj.txFrame:ClearAllPoints()
                    data.obj.txFrame:SetWidth(data.width)
                    data.obj.txFrame:Show()
                    if i == 1 then
                        data.obj.txFrame:SetPoint("LEFT", container, "LEFT")
                    else
                        data.obj.txFrame:SetPoint("LEFT", activeFrames[i - 1].obj.txFrame, "RIGHT", gap, 0)
                    end
                end
            end
        else
            if self.textHolders[gKey] then self.textHolders[gKey]:Hide() end
        end
    end
end

function ascensionBars:updateDisplay(force)
    local now = GetTime()
    if not force and (now - lastUpdate < ascensionBars.constants.UPDATE_THROTTLE) then
        if self.state and not self.state.updatePending then
            self.state.updatePending = true
            C_Timer.After(ascensionBars.constants.UPDATE_THROTTLE, function()
                if self.state then self.state.updatePending = false end
                self:updateDisplay(true)
            end)
        end
        return
    end
    lastUpdate = now

    local db = self.db
    if not db then return end
    local profile = db.profile
    if not profile then return end

    self:applyTextStyles()

    local maxLevel = self:getPlayerMaxLevel() or 1
    local curLevel = UnitLevel("player") or 0
    local isMaxLevel = curLevel >= maxLevel
    local shouldHideXP = isMaxLevel and profile.hideAtMaxLevel

    self:updateLayout(shouldHideXP)
    self:updateVisibility()

    if self.state and self.state.isConfigMode then
        self:renderConfig()
        return
    end

    self:renderExperience(shouldHideXP)
    self:renderReputation()
    self:renderHonor()
    self:renderHouseXp()
    self:renderAzerite()
    self:updateTextAnchors()
end

function ascensionBars:renderConfig()
    local db = self.db
    if not db then return end
    local profile = db.profile
    if not profile then return end
    local bars = profile.bars
    if not bars then return end
    local textColor = profile.textColor or { r = 1, g = 1, b = 1, a = 1 }

    self:configExperience(profile, bars, textColor)
    self:configReputation(profile, bars, textColor)
    self:configHonor(profile, bars, textColor)
    self:configHouseXp(profile, bars, textColor)
    self:configAzerite(profile, bars, textColor)

    self:updateTextAnchors()
end

function ascensionBars:updateLayout(shouldHideXP)
    local db = self.db
    if not db then return end
    local profile = db.profile
    if not profile then return end
    local bars = profile.bars
    if not bars then return end

    local gap = profile.barGap or 1
    local blocks = { TOP = {}, BOTTOM = {}, FREE = {} }
    local barList = {
        { obj = self.xp,      key = "XP" },
        { obj = self.rep,     key = "Rep" },
        { obj = self.honor,   key = "Honor" },
        { obj = self.houseXp, key = "HouseXp" },
        { obj = self.azerite, key = "Azerite" }
    }

    for _, entry in ipairs(barList) do
        local config = bars[entry.key]
        if config and config.enabled and not (entry.key == "XP" and shouldHideXP) then
            table.insert(blocks[config.block or "TOP"], entry)
            if entry.obj and entry.obj.txFrame then entry.obj.txFrame:Show() end
        else
            if entry.obj and entry.obj.bar then entry.obj.bar:Hide() end
            if entry.obj and entry.obj.txFrame then entry.obj.txFrame:Hide() end
        end
    end

    local sortFn = function(a, b)
        local barA = bars[a.key]
        local barB = bars[b.key]
        local orderA = barA and barA.order or 0
        local orderB = barB and barB.order or 0
        return orderA < orderB
    end
    table.sort(blocks.TOP, sortFn)
    table.sort(blocks.BOTTOM, sortFn)

    local gHeight = profile.globalBarHeight or 6
    local yOffset = profile.yOffset or 0

    for i, entry in ipairs(blocks.TOP) do
        local config = bars[entry.key]
        if not config then break end
        if entry.obj and entry.obj.bar then
            entry.obj.bar:ClearAllPoints()
            entry.obj.bar:SetHeight(config.freeHeight or gHeight)
            if i == 1 then
                entry.obj.bar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, yOffset)
                entry.obj.bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, yOffset)
            else
                local prev = blocks.TOP[i - 1]
                if prev and prev.obj and prev.obj.bar then
                    entry.obj.bar:SetPoint("TOPLEFT", prev.obj.bar, "BOTTOMLEFT", 0, -gap)
                    entry.obj.bar:SetPoint("TOPRIGHT", prev.obj.bar, "BOTTOMRIGHT", 0, -gap)
                end
            end
            entry.obj.bar:Show()
        end
    end

    for i, entry in ipairs(blocks.BOTTOM) do
        local config = bars[entry.key]
        if not config then break end
        if entry.obj and entry.obj.bar then
            entry.obj.bar:ClearAllPoints()
            entry.obj.bar:SetHeight(config.freeHeight or gHeight)
            if i == 1 then
                entry.obj.bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, math.abs(yOffset))
                entry.obj.bar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, math.abs(yOffset))
            else
                local prev = blocks.BOTTOM[i - 1]
                if prev and prev.obj and prev.obj.bar then
                    entry.obj.bar:SetPoint("BOTTOMLEFT", prev.obj.bar, "TOPLEFT", 0, gap)
                    entry.obj.bar:SetPoint("BOTTOMRIGHT", prev.obj.bar, "TOPRIGHT", 0, gap)
                end
            end
            entry.obj.bar:Show()
        end
    end

    for _, entry in ipairs(blocks.FREE) do
        local config = bars[entry.key]
        if not config then break end
        if entry.obj and entry.obj.bar then
            entry.obj.bar:ClearAllPoints()
            entry.obj.bar:SetSize(config.freeWidth or 500, config.freeHeight or 6)
            entry.obj.bar:SetPoint("CENTER", UIParent, "CENTER", config.freeX or 0, config.freeY or 0)
            entry.obj.bar:Show()
        end
    end
end

function ascensionBars:updateVisibility()
    local db = self.db
    if not db then return end
    local profile = db.profile
    if not profile then return end

    local alpha = 1
    if not self.state.isConfigMode then
        if profile.hideInCombat and self.state.inCombat then
            alpha = 0
        elseif profile.showOnMouseover and not self.state.isHovering then
            alpha = 0
        end
    end
    local bars = { self.xp, self.rep, self.honor, self.houseXp, self.azerite }
    for _, bar in ipairs(bars) do
        if bar and bar.bar then bar.bar:SetAlpha(alpha) end
    end
    if self.textHolder then self.textHolder:SetAlpha(alpha) end
end

-------------------------------------------------------------------------------
-- INITIALIZATION & EVENT HANDLERS
-------------------------------------------------------------------------------

function ascensionBars:OnInitialize()
    local db = LibStub("AceDB-3.0"):New("AscensionBarsDB", self.defaults, true)
    self.db = db
    self.state = {
        cachedPendingParagons = {},
        cachedClassColor = nil,
        isConfigMode = false,
        inCombat = false,
        isHovering = false,
        updatePending = false
    }
    local defaultFont = "Fonts\\FRIZQT__.TTF"
    local fontName = defaultFont
    if _G.GameFontNormal and _G.GameFontNormal.GetFont then
        fontName = _G.GameFontNormal:GetFont() or defaultFont
    end
    self.fontToUse = fontName
    local toggleConfig = function()
        if self and type(self.toggleConfig) == "function" then
            self:toggleConfig()
        end
    end
    self:RegisterChatCommand("ascensionBars", toggleConfig)
    self:RegisterChatCommand("ab", toggleConfig)
    self:createFrames()
end

function ascensionBars:OnEnable()
    self.state.isConfigMode = false
    self.state.isHovering = false
    self.state.inCombat = false
    self.state.cachedClassColor = nil
    local function reg(event, method)
        if self[method] then
            self:RegisterEvent(event, method)
        end
    end

    reg("PLAYER_XP_UPDATE", "updateDisplay")
    reg("UPDATE_EXHAUSTION", "updateDisplay")
    reg("PLAYER_LEVEL_UP", "updateDisplay")
    reg("UPDATE_FACTION", "onUpdateFaction")
    reg("PLAYER_ENTERING_WORLD", "onPlayerEnteringWorld")
    reg("PLAYER_REGEN_DISABLED", "onCombatStart")
    reg("PLAYER_REGEN_ENABLED", "onCombatEnd")
    reg("QUEST_TURNED_IN", "onQuestTurnIn")
    reg("HONOR_XP_UPDATE", "updateDisplay")
    reg("HONOR_LEVEL_UPDATE", "updateDisplay")
    reg("AZERITE_ITEM_EXPERIENCE_CHANGED", "updateDisplay")
    reg("HOUSE_LEVEL_FAVOR_UPDATED", "onHouseFavorUpdated")
    reg("CVAR_UPDATE", "onCVarUpdate")

    if C_Reputation and C_Reputation.SetWatchedFactionByID then
        hooksecurefunc(C_Reputation, "SetWatchedFactionByID", function()
            if self.updateDisplay then self:updateDisplay() end
        end)
    end
    if C_Housing and C_Housing.SetTrackedHouseGuid then
        hooksecurefunc(C_Housing, "SetTrackedHouseGuid", function()
            C_Timer.After(0.15, function()
                self:refreshHousingFavor()
                if self.updateDisplay then self:updateDisplay() end
            end)
        end)
    end

    self:refreshHousingFavor()
    self:hideBlizzardFrames()
    self:scanParagonRewards()
    self:RegisterEvent("NEIGHBORHOOD_NAME_UPDATED", "updateDisplay")
    self:updateDisplay(true)
end

function ascensionBars:onUpdateFaction()
    self:scanParagonRewards()
    if self.updateDisplay then self:updateDisplay() end
end

function ascensionBars:onPlayerEnteringWorld()
    self:scanParagonRewards()
    self:refreshHousingFavor()
    self:updateDisplay(true)
end

function ascensionBars:onCombatStart()
    if self.state then
        self.state.inCombat = true
    end
    self:updateVisibility()
end

function ascensionBars:onCombatEnd()
    if self.state then
        self.state.inCombat = false
    end
    self:updateVisibility()
end

function ascensionBars:onQuestTurnIn()
    C_Timer.After(1, function()
        if self.scanParagonRewards then
            self:scanParagonRewards()
        end
    end)
end

function ascensionBars:onCVarUpdate(_, name, _)
    if name == "trackedHouseFavor" then
        C_Timer.After(0.15, function()
            if self.refreshHousingFavor then self:refreshHousingFavor() end
            if self.updateDisplay then self:updateDisplay() end
        end)
    end
end

function ascensionBars:OnDisable()
    self:cleanupTextures()
    if self.xp and self.xp.bar then self.xp.bar:Hide() end
    if self.rep and self.rep.bar then self.rep.bar:Hide() end
    if self.honor and self.honor.bar then self.honor.bar:Hide() end
    if self.houseXp and self.houseXp.bar then self.houseXp.bar:Hide() end
    if self.azerite and self.azerite.bar then self.azerite.bar:Hide() end
    if self.textHolder then self.textHolder:Hide() end
end

-------------------------------------------------------------------------------
-- CONFIG TOGGLE (provided by Config.lua, but we keep a stub)
-------------------------------------------------------------------------------
function ascensionBars:toggleConfig()
    -- Logic placeholder if Config.lua fails to load
    UIErrorsFrame:AddMessage("AscensionBars: Configuration module not found.", 1, 0, 0) -- #FF0000
end
