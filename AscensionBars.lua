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

local addonName, addonTable = ...
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local ascensionBars = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceConsole-3.0")

addonTable.main = ascensionBars

-------------------------------------------------------------------------------
-- LOCAL VARIABLES
-------------------------------------------------------------------------------
local texturePool = {}
local lastUpdate = 0

-------------------------------------------------------------------------------
-- UTILITIES
-------------------------------------------------------------------------------

--- Retrieves the current player's maximum level for the expansion
-- @return number The max level
function ascensionBars:getPlayerMaxLevel()
    if _G.GetMaxLevelForLatestExpansion then
        local maxLevel = _G.GetMaxLevelForLatestExpansion()
        if maxLevel then return maxLevel end
    end
    return 80
end

--- Gets the class color with caching to avoid repeated API calls
-- @return table RGB color table
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

--- Hides default Blizzard status bars to prevent UI overlap
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

--- Formats the experience string using localized patterns
function ascensionBars:formatXP(rested)
    local profile = self.db.profile
    local currentXP = UnitXP("player") or 0
    local maxXP = UnitXPMax("player") or 1
    local level = UnitLevel("player")
    local percentage = (currentXP / maxXP) * 100
    
    local showAbs = profile.showAbsoluteValues
    local showPct = profile.showPercentage
    
    -- 1. Base Level Part
    local text = string.format(Locales["LEVEL_TEXT"], level) -- "Level 70"

    -- 2. Main XP Part: | Absolute / Max (Percentage)
    local mainXPStr = ""
    if showAbs and showPct then
        mainXPStr = string.format(" | %s / %s (%.1f%%)", BreakUpLargeNumbers(currentXP), BreakUpLargeNumbers(maxXP), percentage)
    elseif showAbs then
        mainXPStr = string.format(" | %s / %s", BreakUpLargeNumbers(currentXP), BreakUpLargeNumbers(maxXP))
    elseif showPct then
        mainXPStr = string.format(" | %.1f%%", percentage)
    end
    text = text .. mainXPStr

    -- 3. Rested Part: | Rested: Absolute / Max (Percentage)
    if rested and rested > 0 then
        local restedPct = (rested / maxXP) * 100
        local restedStr = ""
        
        -- Building the Rested segment based on toggles
        if showAbs and showPct then
            restedStr = string.format(" | Rested: %s / %s (%.1f%%)", BreakUpLargeNumbers(rested), BreakUpLargeNumbers(maxXP), restedPct)
        elseif showAbs then
            restedStr = string.format(" | Rested: %s / %s", BreakUpLargeNumbers(rested), BreakUpLargeNumbers(maxXP))
        elseif showPct then
            restedStr = string.format(" | Rested: %.1f%%", restedPct)
        end
        
        text = text .. restedStr
    end

    return text
end

-------------------------------------------------------------------------------
-- FRAME CREATION
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
        if self.state then
            self.state.isHovering = true
            self:updateVisibility()
        end
    end)
    
    bar:SetScript("OnLeave", function()
        if self.state then
            self.state.isHovering = false
            self:updateVisibility()
        end
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
    -- MODIFIED: Increased size from 6x6 to 12x24 for better visibility
    spark:SetSize(200, 24) 
    spark:SetBlendMode("ADD")

    local restedOverlay = (name == "AscensionXPBar_XP") and bar:CreateTexture(nil, "ARTWORK") or nil

    local txFrame = CreateFrame("Frame", nil, UIParent)
    txFrame:SetFrameStrata("HIGH")
    txFrame:SetSize(self.constants and self.constants.MIN_TEXT_WIDTH or 50, 20)

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
    if not parent then return nil end
    
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
    for i = 1, #texturePool do 
        if texturePool[i] then texturePool[i]:Hide() end 
    end
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
    if not bar or not bar.bar then return end
    if maxVal <= minVal then maxVal = minVal + 1 end
    
    bar.bar:SetMinMaxValues(minVal, maxVal)
    bar.bar:SetValue(currentVal)
    bar.bar:SetStatusBarColor(color.r, color.g, color.b, color.a or 1)
    self:updateSpark(bar, minVal, maxVal, currentVal)
end

function ascensionBars:updateStandardBar(barObj, barKey, currentFunc, maxFunc, colorFunc, textFunc)
    if not self.db or not barObj then return end
    
    local profile = self.db.profile
    if not profile or not profile.bars then return end
    
    local config = profile.bars[barKey]
    if not config or not config.enabled then
        barObj.bar:Hide()
        barObj.txFrame:Hide()
        return
    end
    
    barObj.bar:Show()
    barObj.txFrame:Show()
    
    local current = currentFunc()
    local maxVal = maxFunc()
    if maxVal == 0 then maxVal = 1 end
    
    local color = colorFunc()
    self:setupBar(barObj, 0, maxVal, current, color)
    
    barObj.text:SetText(textFunc(current, maxVal, (current / maxVal) * 100))
    
    local textColor = profile.textColor
    if textColor then
        barObj.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, textColor.a or 1)
    end
end

-------------------------------------------------------------------------------
-- DISPLAY FUNCTIONS
-------------------------------------------------------------------------------

function ascensionBars:applyTextStyles()
    if not self.db or not self.db.profile then return end
    
    local profile = self.db.profile
    local font = profile.fontPath or [[Fonts\FRIZQT__.TTF]]
    local size = profile.textSize or 14
    local barList = { self.xp, self.rep, self.honor, self.houseXp, self.azerite }
    
    for _, obj in ipairs(barList) do
        if obj and obj.text then
            obj.text:SetFont(font, size, "OUTLINE")
            local textColor = profile.textColor
            if textColor then
                obj.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, textColor.a or 1)
            end
        end
    end
end

function ascensionBars:updateTextAnchors()
    if not self.db or not self.db.profile then return end
    local profile = self.db.profile
    
    local barList = {
        { obj = self.xp,      key = "XP" },
        { obj = self.rep,     key = "Rep" },
        { obj = self.honor,   key = "Honor" },
        { obj = self.houseXp, key = "HouseXp" },
        { obj = self.azerite, key = "Azerite" }
    }

    if profile.textLayoutMode == "INDIVIDUAL_LINES" then
        -- 1. Ocultar los contenedores agrupados porque manejaremos cada línea por separado
        for _, holder in pairs(self.textHolders) do
            holder:Hide()
        end

        -- 2. Asignar posiciones individuales para cada texto anclado SIEMPRE AL TOP
        for _, entry in ipairs(barList) do
            local config = profile.bars[entry.key]
            -- Solo mostrar textos de barras activas y visibles
            if config and config.enabled and entry.obj.bar:IsShown() then
                entry.obj.txFrame:ClearAllPoints()
                -- Anclaje absoluto al borde superior de la pantalla
                entry.obj.txFrame:SetPoint("TOP", UIParent, "TOP", config.textX or 0, config.textY or 0)
                entry.obj.txFrame:Show()
            else
                entry.obj.txFrame:Hide()
            end
        end
        
    else
        -- 3. Lógica para el modo agrupado (SINGLE_LINE)
        local groups = { T1 = {}, T2 = {}, T3 = {} }
        for _, entry in ipairs(barList) do
            local config = profile.bars[entry.key]
            if config and config.enabled and entry.obj.bar:IsShown() then
                local blockKey = config.textBlock or "T1"
                table.insert(groups[blockKey], entry)
            else
                entry.obj.txFrame:Hide()
            end
        end

        for gKey, activeFrames in pairs(groups) do
            table.sort(activeFrames, function(a, b)
                local barA = profile.bars[a.key]
                local barB = profile.bars[b.key]
                return (barA.textOrder or 0) < (barB.textOrder or 0)
            end)

            local container = self.textHolders[gKey]
            if #activeFrames > 0 then
                local gap = profile.textGap or (self.constants and self.constants.DEFAULT_GAP) or 10
                local totalWidth = 0
                
                -- Calcular ancho total del grupo
                for _, data in ipairs(activeFrames) do
                    local minW = self.constants and self.constants.MIN_TEXT_WIDTH or 50
                    local textWidth = math.max(data.obj.text:GetStringWidth() + 5, minW)
                    data.width = textWidth
                    totalWidth = totalWidth + textWidth
                end
                
                totalWidth = totalWidth + (gap * (#activeFrames - 1))

                if container then
                    container:Show()
                    container:SetWidth(totalWidth)
                    
                    local gSet = profile.textGroups[gKey] or { detached = true, x = 0, y = 0 }
                    container:ClearAllPoints()
                    
                    -- ANCLAJE ABSOLUTO AL TOP
                    container:SetPoint("TOP", UIParent, "TOP", gSet.x, gSet.y)

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
                if container then container:Hide() end
            end
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

    if not self.db or not self.db.profile then return end
    local profile = self.db.profile
    local bars = profile.bars

    self:applyTextStyles()

    local maxLevel = self:getPlayerMaxLevel() or 1
    local curLevel = UnitLevel("player") or 0
    local isConfig = self.state and self.state.isConfigMode
    
    -- If in config mode, we force shouldHideXP to false so the bar layout is calculated
    local shouldHideXP = (curLevel >= maxLevel) and profile.hideAtMaxLevel and not isConfig

    self:updateLayout(shouldHideXP)
    self:updateVisibility()

    -- CONFIGURATION MODE LOGIC
    if isConfig then
        local textColor = profile.textColor or { r = 1, g = 1, b = 1, a = 1 }
        
        -- Call dedicated config functions for each module
        if self.configExperience then self:configExperience(profile, bars, textColor) end
        if self.configReputation then self:configReputation(profile, bars, textColor) end
        if self.configHonor then self:configHonor(profile, bars, textColor) end
        if self.configHouseXp then self:configHouseXp(profile, bars, textColor) end
        if self.configAzerite then self:configAzerite(profile, bars, textColor) end
        
        -- Always update anchors in config mode to reflect position changes
        self:updateTextAnchors()
        return -- We return here because config modules handle their own internal rendering
    end

    -- NORMAL MODE LOGIC
    if self.renderExperience then self:renderExperience(shouldHideXP) end
    if self.renderReputation then self:renderReputation() end
    if self.renderHonor then self:renderHonor() end
    if self.renderHouseXp then self:renderHouseXp() end
    if self.renderAzerite then self:renderAzerite() end
    
    self:updateTextAnchors()
end

function ascensionBars:updateLayout(shouldHideXP)
    if not self.db or not self.db.profile then return end
    local profile = self.db.profile
    local bars = profile.bars

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
            entry.obj.txFrame:Show()
        else
            if entry.obj.bar then entry.obj.bar:Hide() end
            entry.obj.txFrame:Hide()
        end
    end

    local sortFn = function(a, b)
        return (bars[a.key].order or 0) < (bars[b.key].order or 0)
    end
    table.sort(blocks.TOP, sortFn)
    table.sort(blocks.BOTTOM, sortFn)

    local gHeight = profile.globalBarHeight or 6
    local yOffset = profile.yOffset or 0

    -- Layout TOP blocks
    for i, entry in ipairs(blocks.TOP) do
        local config = bars[entry.key]
        entry.obj.bar:ClearAllPoints()
        entry.obj.bar:SetHeight(config.freeHeight or gHeight)
        if i == 1 then
            entry.obj.bar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, yOffset)
            entry.obj.bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, yOffset)
        else
            local prev = blocks.TOP[i - 1]
            entry.obj.bar:SetPoint("TOPLEFT", prev.obj.bar, "BOTTOMLEFT", 0, -gap)
            entry.obj.bar:SetPoint("TOPRIGHT", prev.obj.bar, "BOTTOMRIGHT", 0, -gap)
        end
        entry.obj.bar:Show()
    end

    -- Layout BOTTOM blocks
    for i, entry in ipairs(blocks.BOTTOM) do
        local config = bars[entry.key]
        entry.obj.bar:ClearAllPoints()
        entry.obj.bar:SetHeight(config.freeHeight or gHeight)
        if i == 1 then
            entry.obj.bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, math.abs(yOffset))
            entry.obj.bar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, math.abs(yOffset))
        else
            local prev = blocks.BOTTOM[i - 1]
            entry.obj.bar:SetPoint("BOTTOMLEFT", prev.obj.bar, "TOPLEFT", 0, gap)
            entry.obj.bar:SetPoint("BOTTOMRIGHT", prev.obj.bar, "TOPRIGHT", 0, gap)
        end
        entry.obj.bar:Show()
    end

    -- Layout FREE blocks
    for _, entry in ipairs(blocks.FREE) do
        local config = bars[entry.key]
        entry.obj.bar:ClearAllPoints()
        entry.obj.bar:SetSize(config.freeWidth or 500, config.freeHeight or 6)
        entry.obj.bar:SetPoint("CENTER", UIParent, "CENTER", config.freeX or 0, config.freeY or 0)
        entry.obj.bar:Show()
    end
end

function ascensionBars:updateVisibility()
    if not self.db or not self.db.profile or not self.state then return end
    local profile = self.db.profile

    local alpha = 1
    if not self.state.isConfigMode then
        if profile.hideInCombat and self.state.inCombat then
            alpha = 0
        elseif profile.showOnMouseover and not self.state.isHovering then
            alpha = 0
        end
    end
    
    local bars = { self.xp, self.rep, self.honor, self.houseXp, self.azerite }
    for _, barObj in ipairs(bars) do
        if barObj and barObj.bar then 
            barObj.bar:SetAlpha(alpha)
            -- If alpha is 1, ensure the frame is actually visible
            if alpha > 0 and not barObj.bar:IsShown() then
                local config = profile.bars[barObj.key or ""]
                if config and config.enabled then
                    barObj.bar:Show()
                end
            end
        end
        if barObj and barObj.txFrame then barObj.txFrame:SetAlpha(alpha) end
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
    
    local defaultFont = [[Fonts\FRIZQT__.TTF]]
    if _G.GameFontNormal and _G.GameFontNormal.GetFont then
        self.fontToUse = _G.GameFontNormal:GetFont() or defaultFont
    else
        self.fontToUse = defaultFont
    end

    local toggleConfig = function()
        self:toggleConfig()
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

    local events = {
        ["PLAYER_XP_UPDATE"] = "updateDisplay",
        ["UPDATE_EXHAUSTION"] = "updateDisplay",
        ["PLAYER_LEVEL_UP"] = "updateDisplay",
        ["UPDATE_FACTION"] = "onUpdateFaction",
        ["PLAYER_ENTERING_WORLD"] = "onPlayerEnteringWorld",
        ["PLAYER_REGEN_DISABLED"] = "onCombatStart",
        ["PLAYER_REGEN_ENABLED"] = "onCombatEnd",
        ["QUEST_TURNED_IN"] = "onQuestTurnIn",
        ["HONOR_XP_UPDATE"] = "updateDisplay",
        ["HONOR_LEVEL_UPDATE"] = "updateDisplay",
        ["AZERITE_ITEM_EXPERIENCE_CHANGED"] = "updateDisplay",
        ["HOUSE_LEVEL_FAVOR_UPDATED"] = "onHouseFavorUpdated",
        ["CVAR_UPDATE"] = "onCVarUpdate",
        ["NEIGHBORHOOD_NAME_UPDATED"] = "updateDisplay"
    }

    for event, method in pairs(events) do
        if self[method] then
            self:RegisterEvent(event, method)
        end
    end

    if C_Reputation and C_Reputation.SetWatchedFactionByID then
        hooksecurefunc(C_Reputation, "SetWatchedFactionByID", function()
            self:updateDisplay()
        end)
    end
    
    if C_Housing and C_Housing.SetTrackedHouseGuid then
        hooksecurefunc(C_Housing, "SetTrackedHouseGuid", function()
            C_Timer.After(0.15, function()
                if self.refreshHousingFavor then self:refreshHousingFavor() end
                self:updateDisplay()
            end)
        end)
    end

    if self.refreshHousingFavor then self:refreshHousingFavor() end
    self:hideBlizzardFrames()
    if self.scanParagonRewards then self:scanParagonRewards() end
    self:updateDisplay(true)
end

function ascensionBars:onUpdateFaction()
    if self.scanParagonRewards then self:scanParagonRewards() end
    self:updateDisplay()
end

function ascensionBars:onPlayerEnteringWorld()
    if self.scanParagonRewards then self:scanParagonRewards() end
    if self.refreshHousingFavor then self:refreshHousingFavor() end
    self:updateDisplay(true)
end

function ascensionBars:onCombatStart()
    if self.state then self.state.inCombat = true end
    self:updateVisibility()
end

function ascensionBars:onCombatEnd()
    if self.state then self.state.inCombat = false end
    self:updateVisibility()
end

function ascensionBars:onQuestTurnIn()
    C_Timer.After(1, function()
        if self.scanParagonRewards then self:scanParagonRewards() end
    end)
end

function ascensionBars:onCVarUpdate(_, name, _)
    if name == "trackedHouseFavor" then
        C_Timer.After(0.15, function()
            if self.refreshHousingFavor then self:refreshHousingFavor() end
            self:updateDisplay()
        end)
    end
end

function ascensionBars:OnDisable()
    self:cleanupTextures()
    local bars = { self.xp, self.rep, self.honor, self.houseXp, self.azerite }
    for _, bar in ipairs(bars) do
        if bar and bar.bar then bar.bar:Hide() end
    end
    if self.textHolder then self.textHolder:Hide() end
end

function ascensionBars:toggleConfig()
    if not self.configFrame then 
        self:refreshConfigUI() 
    end
    
    if self.configFrame then
        local isNowShown = not self.configFrame:IsShown()
        self.configFrame:SetShown(isNowShown)
        
        -- Sync state with window visibility
        self.state.isConfigMode = isNowShown
        
        -- Refresh to show/hide bars immediately
        self:updateDisplay(true)
    end
end