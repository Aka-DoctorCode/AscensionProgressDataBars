-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: AscensionProgressDataBars.lua
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

---@class AscensionBars
---@field db { profile: table, global: table, ResetProfile: function }
---@field xp table
---@field rep table
---@field honor table
---@field houseXp table
---@field azerite table
---@field state table
---@field constants table
---@field defaults table
---@field configFrame Frame | any
---@field isMinimized boolean
---@field normalWidth number
---@field normalHeight number
---@field activeTab number
---@field tabs table
---@field panels table
---@field textHolder Frame
---@field textHolders table
---@field fontToUse string
---@field colors table
---@field files table
---@field menuStyle table
---@field houseRewardText FontString
---@field paragonText FontString
---@field hoverFrame Frame
---@field registeredElements table
---@field configTabs table
---@field refreshConfig function
---@field ResetProfile function
---@field refreshConfigUI function
---@field updateDisplay function
---@field updateVisibility function
---@field setupBar function
---@field getClassColor function
---@field refreshHousingFavor function
---@field scanParagonRewards function
---@field setupTextHolders function
---@field acquireTexture function
---@field updateStandardBar function
---@field cleanupTextures function
---@field hideBlizzardFrames function
---@field createBars function
---@field updateLayout function
---@field IsEnabled function
---@field RegisterChatCommand function
---@field RegisterEvent function
---@field UnregisterEvent function
---@field UnregisterAllEvents function
---@field configExperience function
---@field configReputation function
---@field configHonor function
---@field configHouseXp function
---@field configAzerite function
---@field renderExperience function
---@field renderReputation function
---@field renderHonor function
---@field renderHouseXp function
---@field renderAzerite function
---@field getFactionData function
---@field onHouseFavorUpdated function
---@field formatXP function
---@field getPlayerMaxLevel function
---@field applyTextStyles function
---@field handleOnUpdate function
---@field toggleConfig function
---@field onUpdateFaction function
---@field onPlayerEnteringWorld function
---@field onCombatStart function
---@field onCombatEnd function
---@field onQuestTurnIn function
---@field onCVarUpdate function
---@field createFrames function
---@field createBar function
---@field updateSpark function
---@class DataTextResult
---@field identity string
---@field details string
---@field percentage string
---@field remaining string

local ascensionBars = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceConsole-3.0")
---@cast ascensionBars AscensionBars

addonTable.main = ascensionBars

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
    local framesToHide = { _G["StatusTrackingBarManager"], _G["UIWidgetPowerBarContainerFrame"] }
    for _, frame in pairs(framesToHide) do
        if frame then
            frame:UnregisterAllEvents()
            frame:Hide()
            frame:SetAlpha(0)
            frame.Show = function() end
        end
    end
end

--- Formats the experience string (delegates to DataText module)
function ascensionBars:formatXP(rested)
    local dt = addonTable.dataText
    if dt then
        return dt:combine(dt:formatExperience())
    end
    return ""
end

-------------------------------------------------------------------------------
-- FRAME CREATION
-------------------------------------------------------------------------------

function ascensionBars:createFrames()
    -- Only keep textHolder for paragon alert backward compatibility
    self.textHolder = CreateFrame("Frame", "AscensionBars_TextHolderT1", UIParent)
    self.textHolder:SetFrameStrata("TOOLTIP")
    self.textHolder:SetClipsChildren(false)
    self.textHolder:SetHeight(20)
    self.textHolder:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

    if not self.hoverFrame then
        self.hoverFrame = CreateFrame("Frame", "AscensionBars_HoverFrame", UIParent)
        self.hoverFrame:SetAllPoints(UIParent)
        self.hoverFrame:SetFrameStrata("TOOLTIP")
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
    bar:SetFrameStrata("TOOLTIP")
    bar:EnableMouse(true)
    
    -- Extract the barKey from the name for tracking
    local barKey = string.match(name, "AscensionXPBar_(.+)")
    
    bar:SetScript("OnEnter", function()
        if self.state then
            self.state.isHovering = true
            self.state.hoveredBarKey = barKey
            self:updateVisibility()
        end
    end)
    
    bar:SetScript("OnLeave", function()
        if self.state then
            self.state.isHovering = false
            self.state.hoveredBarKey = nil
            self:updateVisibility()
        end
    end)
    
    bar:SetStatusBarTexture(self.constants.TEXTURE_BAR)
    bar:SetClipsChildren(true)

    local background = self:acquireTexture(bar)
    if background then
        background:SetAllPoints()
        background:SetTexture(self.constants.TEXTURE_BAR)
        
        local bgAlpha = (self.db and self.db.profile and self.db.profile.backgroundAlpha) or 0.5
        background:SetVertexColor(0, 0, 0, bgAlpha) -- #000000
        background:SetDrawLayer("BACKGROUND", -1)
    end

    local spark = bar:CreateTexture(nil, "ARTWORK")
    spark:SetTexture(self.constants.TEXTURE_SPARK)
    -- MODIFIED: Increased size from 6x6 to 12x24 for better visibility
    spark:SetSize(200, 24) 
    spark:SetBlendMode("ADD")

    local restedOverlay = (name == "AscensionXPBar_XP") and bar:CreateTexture(nil, "ARTWORK") or nil

    -- Legacy text frame (kept, now acts as container for texts to avoid clipping)
    local txFrame = CreateFrame("Frame", nil, UIParent)
    -- Must be TOOLTIP and higher frame level than the bar to appear on top
    txFrame:SetFrameStrata("TOOLTIP")
    txFrame:SetFrameLevel(bar:GetFrameLevel() + 5)
    txFrame:SetAllPoints(bar)
    txFrame:Hide()

    local leftText = txFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    local centerText = txFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    local rightText = txFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")

    local text = txFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    text:SetAllPoints() -- Legacy text

    return {
        bar = bar,
        spark = spark,
        leftText = leftText,
        centerText = centerText,
        rightText = rightText,
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
    
    -- Store basic values for legend (displayName se asigna después en cada barra)
    barObj.current = current
    barObj.max = maxVal
    barObj.percentage = (current / maxVal) * 100
    barObj.color = color
    
    local str = textFunc(current, maxVal, (current / maxVal) * 100)  -- ahora retorna string
    barObj.centerText:SetText(str)
    barObj.leftText:SetText("")
    barObj.rightText:SetText("")
end

-------------------------------------------------------------------------------
-- DISPLAY FUNCTIONS
-------------------------------------------------------------------------------

function ascensionBars:applyTextStyles()
    if not self.db or not self.db.profile then return end
    
    local profile = self.db.profile
    local font = profile.fontPath or [[Fonts\FRIZQT__.TTF]]
    local outline = profile.fontOutline or "OUTLINE"
    
    local barList = {
        { obj = self.xp,      key = "XP" },
        { obj = self.rep,     key = "Rep" },
        { obj = self.honor,   key = "Honor" },
        { obj = self.houseXp, key = "HouseXp" },
        { obj = self.azerite, key = "Azerite" }
    }
    
    for _, entry in ipairs(barList) do
        local obj = entry.obj
        local barKey = entry.key
        
        if obj then
            local barConfig = profile.bars and profile.bars[barKey]
            
            -- 1. Determine Font
            local finalFont = font
            if barConfig and barConfig.useCustomFont then
                finalFont = barConfig.customFontPath or finalFont
            end

            -- 2. Determine Text Size
            local finalSize = profile.textSize or 14
            if barConfig and barConfig.useCustomTextSize then
                finalSize = barConfig.customTextSize or finalSize
            end
            
            -- 3. Determine Text Color
            local finalColor = profile.textColor or { r = 1, g = 1, b = 1, a = 1 }
            if barConfig and barConfig.useCustomTextColor then
                finalColor = barConfig.customTextColor or finalColor
            end
            
            local function applyStyle(fontString)
                if fontString then
                    fontString:SetFont(finalFont, finalSize, outline)
                    fontString:SetTextColor(finalColor.r or 1, finalColor.g or 1, finalColor.b or 1, finalColor.a or 1)
                end
            end

            applyStyle(obj.leftText)
            applyStyle(obj.centerText)
            applyStyle(obj.rightText)
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
    local bars = profile and profile.bars or nil
    if not bars then return end

    self:applyTextStyles()

    local maxLevel = self:getPlayerMaxLevel() or 1
    local curLevel = UnitLevel("player") or 0
    local isConfig = self.state and self.state.isConfigMode
    
    -- If in config mode, we force shouldHideXP to false so the bar layout is calculated
    local shouldHideXP = (curLevel >= maxLevel) and profile and profile.hideAtMaxLevel and not isConfig

    self:updateLayout(shouldHideXP)
    self:updateVisibility()
    if self.updateLegend then self:updateLegend() end
    if self.updateCarouselVisibility then self:updateCarouselVisibility() end

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
        return -- We return here because config modules handle their own internal rendering
    end

    -- NORMAL MODE LOGIC
    if self.renderExperience then self:renderExperience(shouldHideXP) end
    if self.renderReputation then self:renderReputation() end
    if self.renderHonor then self:renderHonor() end
    if self.renderHouseXp then self:renderHouseXp() end
    if self.renderAzerite then self:renderAzerite() end
    
end

function ascensionBars:updateLayout(shouldHideXP)
    if not self.db or not self.db.profile then return end
    local profile = self.db.profile
    local bars = profile and profile.bars or nil
    if not bars then return end

    -- 1. Block Organization
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

    -- 2. Internal helper to calculate the dynamic height of each bar
    local function getBarHeight(entry)
        local config = bars and bars[entry.key] or nil
        if not config then return profile and profile.globalBarHeight or 6 end
        local block = config.block or "TOP"
        
        -- Priority: 1. FREE Mode (freeHeight) | 2. Custom Height | 3. Block Height (if enabled) | 4. Global Height
        if block == "FREE" then return config.freeHeight or 15 end
        if config.useCustomHeight then return config.customHeight or 10 end
        
        if profile.usePerBlockHeights and profile.blockHeights and profile.blockHeights[block] then
            return profile.blockHeights[block]
        end
        
        return profile and profile.globalBarHeight or 6
    end

    -- 3. Sorting by priority 'order'
    local sortFn = function(a, b)
        return (bars[a.key].order or 0) < (bars[b.key].order or 0)
    end
    table.sort(blocks.TOP, sortFn)
    table.sort(blocks.BOTTOM, sortFn)

    ---------------------------------------------------------------------------
    -- LAYOUT: TOP BLOCKS
    ---------------------------------------------------------------------------
    local topOffset = profile.usePerBlockOffsets and (profile.topOffset or 0) or (profile.yOffset or 0)
    local baseTopGap = profile.usePerBlockGaps and (profile.topBarGap or 2) or (profile.barGap or 1)
    local blockMode = profile.blockTextMode or "FOCUS"

    for i, entry in ipairs(blocks.TOP) do
        entry.obj.bar:ClearAllPoints()
        entry.obj.bar:SetHeight(getBarHeight(entry))
        
        if i == 1 then
            entry.obj.bar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, topOffset)
            entry.obj.bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, topOffset)
        else
            local prev = blocks.TOP[i - 1]
            local gap = baseTopGap
            if blockMode == "GRID" then
                local conf = bars[prev.key]
                local textSize = conf and conf.useCustomTextSize and conf.customTextSize or profile.textSize or 14
                gap = textSize + (profile.dynamicGridGap or 2)
            end
            entry.obj.bar:SetPoint("TOPLEFT", prev.obj.bar, "BOTTOMLEFT", 0, -gap)
            entry.obj.bar:SetPoint("TOPRIGHT", prev.obj.bar, "BOTTOMRIGHT", 0, -gap)
        end
        entry.obj.bar:Show()
    end

    ---------------------------------------------------------------------------
    -- LAYOUT: BOTTOM BLOCKS
    ---------------------------------------------------------------------------
    local botOffset = profile.usePerBlockOffsets and (profile.bottomOffset or 0) or math.abs(profile.yOffset or 0)
    local baseBotGap = profile.usePerBlockGaps and (profile.bottomBarGap or 2) or (profile.barGap or 1)

    for i, entry in ipairs(blocks.BOTTOM) do
        entry.obj.bar:ClearAllPoints()
        entry.obj.bar:SetHeight(getBarHeight(entry))
        
        if i == 1 then
            entry.obj.bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, botOffset)
            entry.obj.bar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, botOffset)
        else
            local prev = blocks.BOTTOM[i - 1]
            local gap = baseBotGap
            if blockMode == "GRID" then
                local conf = bars[prev.key]
                local textSize = conf and conf.useCustomTextSize and conf.customTextSize or profile.textSize or 14
                gap = textSize + (profile.dynamicGridGap or 2)
            end
            entry.obj.bar:SetPoint("BOTTOMLEFT", prev.obj.bar, "TOPLEFT", 0, gap)
            entry.obj.bar:SetPoint("BOTTOMRIGHT", prev.obj.bar, "TOPRIGHT", 0, gap)
        end
        entry.obj.bar:Show()
    end

    ---------------------------------------------------------------------------
    -- LAYOUT: FREE BLOCKS
    ---------------------------------------------------------------------------
    for _, entry in ipairs(blocks.FREE) do
        local config = bars[entry.key]
        entry.obj.bar:ClearAllPoints()
        entry.obj.bar:SetSize(config.freeWidth or 500, config.freeHeight or 15)
        entry.obj.bar:SetPoint("CENTER", UIParent, "CENTER", config.freeX or 0, config.freeY or 0)
        entry.obj.bar:Show()
    end
end

function ascensionBars:updateVisibility()
    if not self.db or not self.db.profile or not self.state then return end
    local profile = self.db.profile
    local blockMode = profile.blockTextMode or "FOCUS"
    local isConfig = self.state.isConfigMode
    local legendHovered = self.state.legendHovered

    -- Alpha base (opacidad máxima según combate y "show on mouseover")
    local baseAlpha = 1
    if not legendHovered and not isConfig then
        if profile.hideInCombat and self.state.inCombat then
            baseAlpha = 0
        elseif profile.showOnMouseover and not self.state.isHovering then
            baseAlpha = 0
        end
    end

    -- Factor de atenuación para barras no hovereadas en modo FOCUS
    local dimAlpha = profile.focusDimAlpha or 0.4

    local bars = {
        { obj = self.xp,      key = "XP" },
        { obj = self.rep,     key = "Rep" },
        { obj = self.honor,   key = "Honor" },
        { obj = self.houseXp, key = "HouseXp" },
        { obj = self.azerite, key = "Azerite" }
    }

    for _, entry in ipairs(bars) do
        local barObj = entry.obj
        local key = entry.key
        local config = profile.bars and profile.bars[key]

        if barObj and barObj.bar and config and config.enabled then
            local barAlpha = baseAlpha
            local centerAlpha = 0  -- texto oculto por defecto

                        if blockMode == "FOCUS" then
                if self.state.hoveredBarKey == nil then
                    -- Sin hover: todas las barras visibles al 100%, textos ocultos
                    barAlpha = baseAlpha
                    centerAlpha = 0
                elseif self.state.hoveredBarKey == key then
                    -- Barra hovereada: visible al 100% y con texto
                    barAlpha = baseAlpha
                    centerAlpha = baseAlpha
                else
                    -- Otras barras: atenuadas, sin texto
                    barAlpha = baseAlpha * dimAlpha
                    centerAlpha = 0
                end
            else
                -- Modo GRID o NONE: siempre visibles con texto
                barAlpha = baseAlpha
                centerAlpha = baseAlpha
            end

            barObj.bar:SetAlpha(barAlpha)
            if barAlpha > 0 and not barObj.bar:IsShown() then
                barObj.bar:Show()
            end

            -- Textos laterales siempre ocultos
            if barObj.leftText then barObj.leftText:SetAlpha(0) end
            if barObj.rightText then barObj.rightText:SetAlpha(0) end
            if barObj.centerText then barObj.centerText:SetAlpha(centerAlpha) end

            if barObj.txFrame then barObj.txFrame:SetAlpha(barAlpha) end
        end
    end
    if self.textHolder then self.textHolder:SetAlpha(baseAlpha) end
end

-------------------------------------------------------------------------------
-- INITIALIZATION & EVENT HANDLERS
-------------------------------------------------------------------------------

function ascensionBars:OnInitialize()
    local db = LibStub("AceDB-3.0"):New("AscensionProgressDataBarsDB", self.defaults, true)
    
    -- Migration / Cleanup of old text system variables
    if db.profile then
        if db.profile.textGroups then db.profile.textGroups = nil end
        if db.profile.usePerGroupSize ~= nil then db.profile.usePerGroupSize = nil end
        if db.profile.usePerGroupColor ~= nil then db.profile.usePerGroupColor = nil end
        if db.profile.textLayoutMode ~= nil then db.profile.textLayoutMode = nil end
        if db.profile.textFollowBar ~= nil then db.profile.textFollowBar = nil end
        
        if db.profile.bars then
            for k, v in pairs(db.profile.bars) do
                if v.textBlock then v.textBlock = nil end
                if v.textOrder then v.textOrder = nil end
                if v.textX then v.textX = nil end
                if v.textY then v.textY = nil end
            end
        end
    end
    
    self.db = db
    self.state = {
        cachedPendingParagons = {},
        cachedClassColor = nil,
        isConfigMode = false,
        inCombat = false,
        isHovering = false,
        updatePending = false,
        legendHovered = false,
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

    if addonTable.dataText and addonTable.dataText.initBarText then
        for _, bar in ipairs({self.xp, self.rep, self.honor, self.houseXp, self.azerite}) do
            if bar then addonTable.dataText:initBarText(bar) end
        end
    end

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
    if self.updateCarouselVisibility then self:updateCarouselVisibility() end
end

function ascensionBars:onCombatEnd()
    if self.state then self.state.inCombat = false end
    self:updateVisibility()
    if self.updateCarouselVisibility then self:updateCarouselVisibility() end
    if self.startCarousel then self:startCarousel() end
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
        local isOpening = not self.configFrame:IsShown()
        
        -- Toggle visibility
        self.configFrame:SetShown(isOpening)
        
        -- If we just closed the menu, ensure config mode is disabled to restore normal bar behavior
        if not isOpening then
            self.state.isConfigMode = false
            self:updateDisplay(true)
        end
    end
end