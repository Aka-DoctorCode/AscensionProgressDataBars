-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Bars/Reputation.lua
-------------------------------------------------------------------------------
---@diagnostic disable: undefined-global, undefined-field, inject-field

local addonName, addonTable = ...

local core = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)

local Locales  = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")
local dataText = addonTable.dataText

-------------------------------------------------------------------------------
-- MODULE DEFINITION
-------------------------------------------------------------------------------

local ReputationModule = core:NewModule("Reputation", "AceEvent-3.0")
ReputationModule.core  = core

-------------------------------------------------------------------------------
-- MODULE LIFECYCLE
-------------------------------------------------------------------------------

function ReputationModule:OnEnable()
    self:RegisterEvent("UPDATE_FACTION", "onUpdateFaction")
    self:initializeCache()
end

function ReputationModule:initializeCache()
    local state = self.core.state
    if not state then return end
    state.lastReputation = state.lastReputation or {}

    if not (C_Reputation and C_Reputation.GetNumFactions and C_Reputation.GetFactionDataByIndex) then
        return
    end

    local numFactions = C_Reputation.GetNumFactions()
    if not numFactions then return end

    for i = 1, numFactions do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        if factionData and factionData.factionID then
            local id = factionData.factionID
            local normalized = self:getFactionData(id)
            if normalized then
                state.lastReputation[id] = {
                    value = normalized.currentValue or 0,
                    max   = normalized.maxValue or 1,
                    level = normalized.levelName or ""
                }
            end
        end
    end
end

function ReputationModule:OnDisable()
    self:UnregisterAllEvents()
end

-------------------------------------------------------------------------------
-- EVENT HANDLERS
-------------------------------------------------------------------------------

function ReputationModule:onUpdateFaction()

    local state  = self.core.state
    if not state then return end

    if not (C_Reputation and C_Reputation.GetNumFactions and C_Reputation.GetFactionDataByIndex) then
        self.core:updateDisplay()
        return
    end

    local numFactions = C_Reputation.GetNumFactions()
    if not numFactions then
        self.core:updateDisplay()
        return
    end

    for i = 1, numFactions do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        if factionData and factionData.factionID then
            local id   = factionData.factionID
            local name = factionData.name

            local normalized = self:getFactionData(id)
            if normalized then
                local currentVal = normalized.currentValue or 0
                local currentMax = normalized.maxValue or 1
                local currentLvl = normalized.levelName or ""

                local lastInfo = state.lastReputation[id]

                if lastInfo then
                    local gained = 0
                    if lastInfo.level == currentLvl then
                        if currentVal > lastInfo.value then
                            gained = currentVal - lastInfo.value
                        end
                    else
                        local remainingInLast = lastInfo.max - lastInfo.value
                        if remainingInLast < 0 then remainingInLast = 0 end
                        gained = remainingInLast + currentVal
                    end

                    if gained > 0 and self.core.pushCarouselEvent then
                        self.core:pushCarouselEvent("REP", id, name, gained)
                    end
                end

                state.lastReputation[id] = {
                    value = currentVal,
                    max   = currentMax,
                    level = currentLvl
                }
            end
        end
    end

    self.core:updateDisplay()
end

-------------------------------------------------------------------------------
-- RENDER DISPATCH
-------------------------------------------------------------------------------

function ReputationModule:UpdateRender(isConfig, shouldHideXP)
    if isConfig then
        self:renderConfig()
    else
        self:renderLive()
    end
end

-------------------------------------------------------------------------------
-- FACTION DATA NORMALIZER
-------------------------------------------------------------------------------

--- Normalizes a faction ID into a unified data table regardless of type.
-- Handles Major Factions (Renown), Friendship Factions, and Standard reputation.
-- @param factionId number The faction ID to query.
-- @return table|nil Normalized data table.
function ReputationModule:getFactionData(factionId)
    if not factionId then return nil end
    if not (C_Reputation and C_Reputation.IsFactionParagon) then return nil end

    local data = {
        id           = factionId,
        currentValue = 0,
        maxValue     = 1,
        levelName    = "",
        isMaxLevel   = false,
        hasParagon   = C_Reputation.IsFactionParagon(factionId),
        type         = "STANDARD",
        reaction     = 0,
    }

    local isHandled = false

    -- 1. Major Faction (Renown)
    if C_Reputation.IsMajorFaction and C_Reputation.IsMajorFaction(factionId) then
        isHandled = true
        if C_MajorFactions and C_MajorFactions.GetMajorFactionData then
            local majorData = C_MajorFactions.GetMajorFactionData(factionId)
            if majorData then
                data.type         = "RENOWN"
                data.reaction     = 11
                data.currentValue = majorData.renownReputationEarned or 0
                data.maxValue     = majorData.renownLevelThreshold   or 2500
                data.isMaxLevel   = (majorData.renownLevel >= majorData.maxLevel)
                data.levelName    = string.format("%s %d", Locales["RENOWN_LEVEL"], majorData.renownLevel)

                if data.isMaxLevel and not data.hasParagon then
                    data.currentValue, data.maxValue = 1, 1
                    data.reaction = 10
                end
            end
        end
    end

    -- 2. Friendship Factions (only if not already handled as Major)
    if not isHandled and C_GossipInfo and C_GossipInfo.GetFriendshipReputation then
        local friendData = C_GossipInfo.GetFriendshipReputation(factionId)
        if friendData and friendData.friendshipFactionID and friendData.friendshipFactionID > 0 then
            isHandled         = true
            data.type         = "FRIENDSHIP"
            data.reaction     = 5
            data.levelName    = friendData.reaction or ""
            data.currentValue = (friendData.standing or 0) - (friendData.reactionThreshold or 0)
            data.maxValue     = friendData.nextThreshold
                and (friendData.nextThreshold - friendData.reactionThreshold) or 1
            data.isMaxLevel   = (friendData.nextThreshold == nil)

            if data.isMaxLevel and not data.hasParagon then
                data.currentValue, data.maxValue = 1, 1
                data.reaction = 10
            end
        end
    end

    -- 3. Standard Reputation (fallback for all non-Major, non-Friendship factions)
    if not isHandled and C_Reputation.GetFactionDataByID then
        local factionData = C_Reputation.GetFactionDataByID(factionId)
        if factionData then
            local reactionIndex = factionData.reaction or 0
            data.reaction     = reactionIndex
            data.levelName    = _G["FACTION_STANDING_LABEL" .. reactionIndex] or reactionIndex
            data.currentValue = factionData.currentStanding - factionData.currentReactionThreshold
            data.maxValue     = factionData.nextReactionThreshold - factionData.currentReactionThreshold
            data.isMaxLevel   = (reactionIndex == 8)

            if data.isMaxLevel and not data.hasParagon then
                data.currentValue, data.maxValue = 1, 1
                data.reaction = 10
            end
        end
    end

    -- 4. Paragon Override
    if data.hasParagon and data.isMaxLevel and C_Reputation.GetFactionParagonInfo then
        local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionId)
        if currentValue and threshold and threshold > 0 then
            data.currentValue = currentValue % threshold
            data.maxValue     = threshold
            data.levelName    = Locales["PARAGON"]
            data.reaction     = 9
            data.isMaxLevel   = false
        end
    end

    return data
end

-------------------------------------------------------------------------------
-- LIVE RENDER
-------------------------------------------------------------------------------

function ReputationModule:renderSingleRepBarLive(repKey, targetFactionId)
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local repObj = self.core.activeBars[repKey]
    if not repObj then return end

    local repConfig = profile.bars and profile.bars[repKey]
    if not repConfig or not repConfig.enabled then
        if repObj.bar     then repObj.bar:Hide()     end
        if repObj.txFrame then repObj.txFrame:Hide() end
        return
    end

    local name, reaction, curVal, maxVal, standingLabel
    local isMaxLevel, hasParagon = false, false
    if not name then
        if targetFactionId then
            local normalized = self:getFactionData(targetFactionId)
            if normalized then
                if C_Reputation.GetFactionDataByID then
                    local fd = C_Reputation.GetFactionDataByID(targetFactionId)
                    if fd and fd.name then name = fd.name end
                end
                if not name and C_MajorFactions and C_MajorFactions.GetMajorFactionData then
                    local md = C_MajorFactions.GetMajorFactionData(targetFactionId)
                    if md and md.name then name = md.name end
                end
                if not name and repConfig.name then
                    name = repConfig.name
                elseif not name then
                    name = Locales["REPUTATION"] .. " " .. targetFactionId
                end
                
                reaction     = normalized.reaction
                curVal       = normalized.currentValue
                maxVal       = normalized.maxValue
                standingLabel = normalized.levelName
                isMaxLevel   = normalized.isMaxLevel
                hasParagon   = normalized.hasParagon
            end
        else
            if C_Reputation and C_Reputation.GetWatchedFactionData then
                local watchedData = C_Reputation.GetWatchedFactionData()
                if watchedData then
                    targetFactionId = watchedData.factionID
                    local normalized = self:getFactionData(targetFactionId)
                    if normalized then
                        name         = watchedData.name
                        reaction     = normalized.reaction
                        curVal       = normalized.currentValue
                        maxVal       = normalized.maxValue
                        standingLabel = normalized.levelName
                        isMaxLevel   = normalized.isMaxLevel
                        hasParagon   = normalized.hasParagon
                    end
                end
            end
        end
    end

    if name and repObj then
        if repObj.bar     then repObj.bar:Show()     end
        if repObj.txFrame then repObj.txFrame:Show() end

        local cur  = math.max(0, curVal or 0)
        local max  = math.max(1, maxVal or 1)
        if cur > max then cur = max end
        local percentage = (cur / max) * 100

        local useReaction = profile.useReactionColorRep
        local repColors   = profile.repColors
        local rBarColor   = profile.repBarColor or { r = 0, g = 1, b = 0, a = 1 }
        local color       = (useReaction and repColors and repColors[reaction]) or rBarColor

        -- Apply color variation for adjacent reputations with the same level
        if variationStep and variationStep > 0 and self.core.getRepColorVariation then
            color = self.core:getRepColorVariation(color, variationStep)
        end

        self.core:setupBar(repObj, 0, max, cur, color)

        repObj.current    = cur
        repObj.max        = max
        repObj.percentage = percentage
        repObj.displayName = name
        repObj.standing   = standingLabel
        repObj.color      = color

        if dataText and repObj.centerText then
            local result = dataText:formatReputation(name, standingLabel, cur, max, isMaxLevel, hasParagon)
            repObj.centerText:SetText(result)
            if repObj.leftText  then repObj.leftText:SetText("")  end
            if repObj.rightText then repObj.rightText:SetText("") end
        end
    elseif repObj then
        if repObj.bar     then repObj.bar:Hide()     end
        if repObj.txFrame then repObj.txFrame:Hide() end
    end
end

-------------------------------------------------------------------------------
-- ADJACENCY COLOR VARIATION COMPUTATION
-------------------------------------------------------------------------------

--- Computes cyclic variation steps (0: Base, 1: -20% darker, 2: +15% lighter)
-- for adjacent reputation bars that share the same standing level / reaction.
-- @param repBarList table Array of { key = string, reaction = number|string }
-- @return table Map of barKey -> step (0, 1, or 2)
function ReputationModule:computeColorVariations(repBarList)
    local profile = self.core.db and self.core.db.profile
    if not profile or not repBarList or #repBarList == 0 then return {} end

    local repBarsByKey = {}
    for _, info in ipairs(repBarList) do
        repBarsByKey[info.key] = info
    end

    local adj = {}
    local function addEdge(k1, k2)
        if not k1 or not k2 or k1 == k2 then return end
        if not repBarsByKey[k1] or not repBarsByKey[k2] then return end
        if not adj[k1] then adj[k1] = {} end
        if not adj[k2] then adj[k2] = {} end
        adj[k1][k2] = true
        adj[k2][k1] = true
    end

    local gridMaster = profile.customGridMasterEnabled
    local customGrids = profile.customGrids or {}
    local blocks = { "TOP", "BOTTOM" }

    for _, blockName in ipairs(blocks) do
        local grid = customGrids[blockName]
        if gridMaster and grid and grid.enabled and grid.assignments then
            local numRows = grid.numRows or 1
            for r = 1, numRows do
                local cols = (grid.colsPerRow and grid.colsPerRow[r]) or 1
                for c = 1, cols do
                    local currentKey = grid.assignments[r] and grid.assignments[r][c]
                    if currentKey and repBarsByKey[currentKey] then
                        local rightKey = grid.assignments[r] and grid.assignments[r][c + 1]
                        if rightKey and repBarsByKey[rightKey] then
                            addEdge(currentKey, rightKey)
                        end
                        local downKey = grid.assignments[r + 1] and grid.assignments[r + 1][c]
                        if downKey and repBarsByKey[downKey] then
                            addEdge(currentKey, downKey)
                        end
                    end
                end
            end
        else
            local blockBars = {}
            if profile.bars then
                for _, info in ipairs(repBarList) do
                    local bConfig = profile.bars[info.key]
                    local bBlock = (bConfig and bConfig.block) or "TOP"
                    if bBlock == blockName and (bConfig and bConfig.enabled) then
                        table.insert(blockBars, { key = info.key, order = (bConfig and bConfig.order) or 0 })
                    end
                end
            end
            table.sort(blockBars, function(a, b) return a.order < b.order end)
            for i = 1, #blockBars - 1 do
                addEdge(blockBars[i].key, blockBars[i + 1].key)
            end
        end
    end

    local assignedSteps = {}
    for _, info in ipairs(repBarList) do
        local key = info.key
        local myReaction = info.reaction

        local usedSteps = {}
        if adj[key] then
            for neighborKey in pairs(adj[key]) do
                local neighborInfo = repBarsByKey[neighborKey]
                if neighborInfo and neighborInfo.reaction == myReaction then
                    local nStep = assignedSteps[neighborKey]
                    if nStep ~= nil then
                        usedSteps[nStep] = true
                    end
                end
            end
        end

        local chosenStep = 0
        if not usedSteps[0] then
            chosenStep = 0
        elseif not usedSteps[1] then
            chosenStep = 1
        elseif not usedSteps[2] then
            chosenStep = 2
        else
            chosenStep = 0
        end

        assignedSteps[key] = chosenStep
    end

    return assignedSteps
end

function ReputationModule:renderLive()
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    -- 1. Gather all active reputation bars
    local activeReps = {}
    local useReaction = profile.useReactionColorRep

    local repConfig = profile.bars and profile.bars["Rep"]
    if repConfig and repConfig.enabled and self.core.activeBars["Rep"] then
        local targetFactionId = nil
        if C_Reputation and C_Reputation.GetWatchedFactionData then
            local wd = C_Reputation.GetWatchedFactionData()
            if wd then targetFactionId = wd.factionID end
        end
        local reaction = 5
        if targetFactionId then
            local norm = self:getFactionData(targetFactionId)
            if norm and norm.reaction then reaction = norm.reaction end
        end
        table.insert(activeReps, { key = "Rep", factionId = targetFactionId, reaction = useReaction and reaction or "STATIC" })
    end

    if profile.bars then
        for k, v in pairs(profile.bars) do
            if v and v.enabled and self.core.activeBars[k] and string.match(k, "^Rep_(%d+)$") then
                local factionId = tonumber(string.match(k, "^Rep_(%d+)$"))
                local reaction = 5
                if factionId then
                    local norm = self:getFactionData(factionId)
                    if norm and norm.reaction then reaction = norm.reaction end
                end
                table.insert(activeReps, { key = k, factionId = factionId, reaction = useReaction and reaction or "STATIC" })
            end
        end
    end

    -- 2. Compute variations for adjacent bars sharing the same level
    local steps = self:computeColorVariations(activeReps)

    -- 3. Render bars with assigned steps
    self:renderSingleRepBarLive("Rep", nil, steps["Rep"] or 0)
    
    if profile.bars then
        for k, v in pairs(profile.bars) do
            if string.match(k, "^Rep_(%d+)$") then
                local factionId = tonumber(string.match(k, "^Rep_(%d+)$"))
                self:renderSingleRepBarLive(k, factionId, steps[k] or 0)
            end
        end
    end
end

-------------------------------------------------------------------------------
-- CONFIG PREVIEW RENDER
-------------------------------------------------------------------------------

function ReputationModule:renderSingleRepBarConfig(repKey, variationStep)
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local repObj = self.core.activeBars[repKey]
    if not repObj then return end

    local repConfig = profile.bars and profile.bars[repKey]
    if not repConfig or not repConfig.enabled then
        if repObj.bar     then repObj.bar:Hide()     end
        if repObj.txFrame then repObj.txFrame:Hide() end
        return
    end

    if repObj.bar     then repObj.bar:Show()     end
    if repObj.txFrame then repObj.txFrame:Show() end

    local repColor = profile.repBarColor or { r = 0, g = 1, b = 0, a = 1 }

    -- Apply color variation for adjacent reputations with the same level in preview
    if variationStep and variationStep > 0 and self.core.getRepColorVariation then
        repColor = self.core:getRepColorVariation(repColor, variationStep)
    end

    self.core:setupBar(repObj, 0, 100, 50, repColor)

    local targetName = repConfig.name or Locales["REPUTATION"] or "Reputation"
    if repKey == "Rep" then targetName = Locales["REPUTATION"] or "Watched Reputation" end

    repObj.current     = 1500
    repObj.max         = 3000
    repObj.percentage  = 50
    repObj.displayName = targetName
    repObj.standing    = Locales["FRIENDLY"]   or "Friendly"
    repObj.color       = repColor

    if repObj.centerText then
        repObj.centerText:SetText(Locales["REP_BAR_DATA"] or targetName)
    end
end

function ReputationModule:renderConfig()
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local activeReps = {}
    local repConfig = profile.bars and profile.bars["Rep"]
    if repConfig and repConfig.enabled and self.core.activeBars["Rep"] then
        table.insert(activeReps, { key = "Rep", reaction = 5 })
    end

    if profile.bars then
        for k, v in pairs(profile.bars) do
            if v and v.enabled and self.core.activeBars[k] and string.match(k, "^Rep_(%d+)$") then
                table.insert(activeReps, { key = k, reaction = 5 })
            end
        end
    end

    local steps = self:computeColorVariations(activeReps)

    self:renderSingleRepBarConfig("Rep", steps["Rep"] or 0)
    
    if profile.bars then
        for k, v in pairs(profile.bars) do
            if string.match(k, "^Rep_(%d+)$") then
                self:renderSingleRepBarConfig(k, steps[k] or 0)
            end
        end
    end
end

-- Backward-compat shims: allow core and config panel to call the old method names
function core:getFactionData(factionId)
    local mod = self:GetModule("Reputation", true)
    if mod then return mod:getFactionData(factionId) end
    return nil
end

function core:renderReputation()
    local mod = self:GetModule("Reputation", true)
    if mod then mod:renderLive() end
end

function core:configReputation(profile, bars, textColor)
    local mod = self:GetModule("Reputation", true)
    if mod then mod:renderConfig() end
end