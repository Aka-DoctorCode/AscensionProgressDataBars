-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: AscensionBars.lua
-- Version: 28
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------
local addonName = "AscensionBars"

---@class AscensionBars : AceAddon-3.0
---@field constants table
---@field defaults table
---@field db table
---@field state table
---@field fontToUse string
---@field textHolder table
---@field HoverFrame table
---@field XP table
---@field Rep table
---@field Honor table|nil
---@field HouseXp table|nil
---@field Artifact table|nil
---@field houseRewardText table|nil
---@field GetOptionsTable function
---@field GetPlayerMaxLevel function
---@field GetClassColor function
---@field AddTooltip function
---@field LoadPreset function
---@field CreateFrames function
---@field CreateBar function
---@field AcquireTexture function
---@field UpdateTextAnchors function
---@field UpdateVisibility function
---@field UpdateDisplay function
---@field HideBlizzardFrames function
---@field ScanParagonRewards function
---@field CleanupTextures function
---@field OnInitialize function
---@field OnEnable function
---@field OnDisable function
---@field OnUpdateFaction function
---@field OnCombatStart function
---@field OnCombatEnd function
---@field OnQuestTurnIn function
---@field RegisterChatCommand function
---@field RegisterEvent function
---@field FormatXP function
---@field RenderReputation function
---@field paragonText table
---@field SetFont function
---@field SetText function
---@field Show function
---@field ClearAllPoints function
---@field SetPoint function
---@field RenderConfig function
---@field UpdateLayout function
---@field RenderOptionalBars function
---@field HouseInfo.plotID table

local AB = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceConsole-3.0")

-------------------------------------------------------------------------------
-- INITIALIZATION
-------------------------------------------------------------------------------

function AB:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("AscensionBarsDB", self.defaults, true)
    self.state = {
        lastParagonScanTime = 0,
        cachedPendingParagons = {},
        cachedClassColor = nil,
        isConfigMode = false,
        inCombat = false,
        isHovering = false,
        eventHandlers = {},
        updatePending = false
    }
    self.fontToUse = (GameFontNormal and GameFontNormal.GetFont and GameFontNormal:GetFont()) or "Fonts\\FRIZQT__.TTF"
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, self:GetOptionsTable())
    local optionsFrame, category = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, "Ascension Bars")
    self.optionsCategory = category or optionsFrame
    self:RegisterChatCommand("ab", function()
        if Settings and Settings.OpenToCategory then
            if type(self.optionsCategory) == "table" and self.optionsCategory.GetID then
                Settings.OpenToCategory(self.optionsCategory:GetID())
            elseif type(self.optionsCategory) == "number" or type(self.optionsCategory) == "string" then
                Settings.OpenToCategory(self.optionsCategory)
            else
                Settings.OpenToCategory(addonName)
            end
        end
    end)
    self:CreateFrames()
end

function AB:OnEnable()
    self.state = {
        isConfigMode = false,
        isHovering = false,
        inCombat = false,
        cachedClassColor = nil,
    }
    self:CreateFrames()
    self:RegisterEvent("PLAYER_XP_UPDATE", "UpdateDisplay")
    self:RegisterEvent("UPDATE_EXHAUSTION", "UpdateDisplay")
    self:RegisterEvent("PLAYER_LEVEL_UP", "UpdateDisplay")
    self:RegisterEvent("UPDATE_FACTION", "OnUpdateFaction")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnCombatStart")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnCombatEnd")
    self:RegisterEvent("QUEST_TURNED_IN", "OnQuestTurnIn")
    self:RegisterEvent("HONOR_XP_UPDATE", "UpdateDisplay")
    self:RegisterEvent("HONOR_LEVEL_UPDATE", "UpdateDisplay")
    self:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED", "UpdateDisplay")
    self:RegisterEvent("HOUSE_LEVEL_FAVOR_UPDATED", "OnHouseFavorUpdated")
    self:RegisterEvent("CVAR_UPDATE", "OnCVarUpdate")
    if C_Reputation and C_Reputation.SetWatchedFactionByID then
        hooksecurefunc(C_Reputation, "SetWatchedFactionByID", function()
            -- Need nill check: Ensure function exists before calling
            if self.UpdateDisplay then
                self:UpdateDisplay()
            end
        end)
    end
    if C_Housing and C_Housing.SetTrackedHouseGuid then
        hooksecurefunc(C_Housing, "SetTrackedHouseGuid", function()
            if not self.state then self.state = {} end
            C_Timer.After(0.15, function()
                if C_Housing and C_Housing.GetTrackedHouseGuid then
                    local trackedGuid = C_Housing.GetTrackedHouseGuid()
                    if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "0" and trackedGuid ~= "" then
                        if C_Housing.GetCurrentHouseLevelFavor then
                            C_Housing.GetCurrentHouseLevelFavor(trackedGuid)
                        end
                    else
                        self.state.houseLevelFavor = nil
                    end
                    if self.UpdateDisplay then
                        self:UpdateDisplay()
                    end
                end
            end)
        end)
    end
    if C_Housing and C_Housing.GetTrackedHouseGuid then
        local trackedGuid = C_Housing.GetTrackedHouseGuid()
        if trackedGuid and C_Housing.GetCurrentHouseLevelFavor then
            C_Housing.GetCurrentHouseLevelFavor(trackedGuid)
        end
    end
    self:HideBlizzardFrames()
    self:ScanParagonRewards()
    self:UpdateDisplay(true)
end

-------------------------------------------------------------------------------
-- EVENT HANDLERS
-------------------------------------------------------------------------------

function AB:OnUpdateFaction()
    self:ScanParagonRewards()
    if self.UpdateDisplay then
        self:UpdateDisplay()
    end
end

function AB:OnPlayerEnteringWorld()
    self:ScanParagonRewards()
    if C_Housing and C_Housing.GetTrackedHouseGuid then
        local trackedGuid = C_Housing.GetTrackedHouseGuid()
        if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "0" and trackedGuid ~= "" then
            if C_Housing.GetCurrentHouseLevelFavor then
                C_Housing.GetCurrentHouseLevelFavor(trackedGuid)
            end
        end
    end
    if self.UpdateDisplay then
        self:UpdateDisplay(true)
    end
end

function AB:OnCombatStart()
    self.state.inCombat = true
    self:UpdateVisibility()
end

function AB:OnCombatEnd()
    self.state.inCombat = false
    self:UpdateVisibility()
end

function AB:OnQuestTurnIn()
    C_Timer.After(1, function()
        self:ScanParagonRewards()
    end)
end

-------------------------------------------------------------------------------
-- HOUSING EVENT HANDLERS
-------------------------------------------------------------------------------

function AB:OnHouseFavorUpdated(event, houseLevelFavor)
    if C_Housing and C_Housing.GetTrackedHouseGuid and houseLevelFavor then
        local trackedGuid = C_Housing.GetTrackedHouseGuid()
        if houseLevelFavor.houseGUID == trackedGuid then
            if not self.state then self.state = {} end
            self.state.houseLevelFavor = houseLevelFavor
            if self.UpdateDisplay then
                self:UpdateDisplay()
            end
        end
    end
end

function AB:OnCVarUpdate(event, name, value)
    if name == "trackedHouseFavor" then
        if not self.state then self.state = {} end
        C_Timer.After(0.15, function()
            if C_Housing and C_Housing.GetTrackedHouseGuid then
                local trackedGuid = C_Housing.GetTrackedHouseGuid()
                if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "0" and trackedGuid ~= "" then
                    if C_Housing.GetCurrentHouseLevelFavor then
                        C_Housing.GetCurrentHouseLevelFavor(trackedGuid)
                    end
                else
                    self.state.houseLevelFavor = nil
                end
                if self.UpdateDisplay then
                    self:UpdateDisplay()
                end
            end
        end)
    end
end

-------------------------------------------------------------------------------
-- DISABLE
-------------------------------------------------------------------------------

function AB:OnDisable()
    self:CleanupTextures()
    if self.XP and self.XP.bar then self.XP.bar:Hide() end
    if self.Rep and self.Rep.bar then self.Rep.bar:Hide() end
    if self.Honor and self.Honor.bar then self.Honor.bar:Hide() end
    if self.HouseXp and self.HouseXp.bar then self.HouseXp.bar:Hide() end
    if self.Artifact and self.Artifact.bar then self.Artifact.bar:Hide() end
    if self.textHolder then self.textHolder:Hide() end
end
