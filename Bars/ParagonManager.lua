-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: ParagonManager.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025-2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...
---@type AscensionBars
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")

-------------------------------------------------------------------------------
-- PARAGON MANAGER
-- Responsible for scanning and caching paragon reward availability.
-- Fires RaidNotice_AddMessage alerts for pending rewards (no chat prints).
-------------------------------------------------------------------------------

--- Scans all factions for pending paragon rewards and updates the account-wide cache.
--- Called on PLAYER_ENTERING_WORLD and QUEST_TURNED_IN (with a 1-second delay).
function ascensionBars:scanParagonRewards()
    if not (self.db and self.db.global) then return end

    if not (C_Reputation and C_Reputation.GetNumFactions and C_Reputation.GetFactionDataByIndex
        and C_Reputation.IsFactionParagon and C_Reputation.GetFactionParagonInfo) then
        return
    end

    local characterKey = UnitName("player") .. "-" .. GetRealmName()
    self.db.global.paragonRewards = self.db.global.paragonRewards or {}

    local currentRewards = {}
    local pendingList = {}
    local foundAny = false
    local numFactions = C_Reputation.GetNumFactions()

    if numFactions and numFactions > 0 then
        for i = 1, numFactions do
            local factionData = C_Reputation.GetFactionDataByIndex(i)
            if factionData and factionData.factionID then
                if C_Reputation.IsFactionParagon(factionData.factionID) then
                    local _, _, _, hasReward = C_Reputation.GetFactionParagonInfo(factionData.factionID)
                    if hasReward then
                        currentRewards[factionData.factionID] = factionData.name
                        table.insert(pendingList, { name = factionData.name })
                        foundAny = true
                    end
                end
            end
        end

        if foundAny then
            self.db.global.paragonRewards[characterKey] = currentRewards
            self:notifyParagonRewardsAvailable(currentRewards)
        else
            self.db.global.paragonRewards[characterKey] = nil
        end
    end

    -- Update the persistent paragon text renderer
    self:renderParagonText(pendingList)
end

--- Renderiza el texto persistente de recompensas Paragon (exactamente como en AscensionBars)
function ascensionBars:renderParagonText(pending)
    if not self.paragonText then return end
    
    local profile = self.db.profile
    if not profile then return end

    if pending and #pending > 0 then
        local pColor = profile.paragonPendingColor or { r = 0, g = 0.8, b = 1 }
        local hex = string.format("|cff%02x%02x%02x",
            math.floor((pColor.r or 0) * 255),
            math.floor((pColor.g or 0.8) * 255),
            math.floor((pColor.b or 1) * 255)
        )

        local textContent = ""
        local split = profile.splitParagonText
        if split then
            local lines = {}
            for _, info in ipairs(pending) do
                table.insert(lines, hex .. string.upper(info.name) .. (Locales["REWARD_PENDING_SINGLE"] or " REWARD PENDING!") .. "|r")
            end
            textContent = table.concat(lines, "\n")
        else
            local names = {}
            for _, info in ipairs(pending) do
                table.insert(names, string.upper(info.name))
            end

            local totalCount = #names
            local factionStr = ""
            if totalCount == 1 then
                factionStr = names[1]
            elseif totalCount == 2 then
                factionStr = names[1] .. (Locales["AND"] or " AND ") .. names[2]
            else
                local last = table.remove(names)
                factionStr = table.concat(names, ", ") .. (Locales["AND"] or " AND ") .. last
            end

            local suffix = (totalCount > 1) and (Locales["REWARD_PENDING_PLURAL"] or " REWARDS PENDING!") or (Locales["REWARD_PENDING_SINGLE"] or " REWARD PENDING!")
            textContent = hex .. factionStr .. suffix .. "|r"
        end

        local pSize = profile.paragonTextSize or 18
        self.paragonText:SetFont(self.fontToUse or [[Fonts\FRIZQT__.TTF]], pSize, "OUTLINE")
        self.paragonText:SetText(textContent)
        self.paragonText:Show()

        -- Posicionamiento configurable (Screen Top Center, con offsets de usuario)
        local pX = profile.paragonXOffset or 0
        local pY = profile.paragonYOffset or -100
        self.paragonText:ClearAllPoints()
        self.paragonText:SetPoint("TOP", UIParent, "TOP", pX, pY)
    else
        self.paragonText:Hide()
    end
    
    if self.updateCarouselVisibility then
        self:updateCarouselVisibility()
    end
end


--- Displays a center-screen notification using RaidNotice_AddMessage.
--- Avoids any chat log output.
-- @param rewards table Map of factionID -> factionName with pending rewards.
function ascensionBars:notifyParagonRewardsAvailable(rewards)
    if not rewards or not next(rewards) then return end
    if not (self.db and self.db.profile) then return end

    local profile = self.db.profile
    if not profile.paragonRaidAlerts then return end

    local pColor = profile.paragonPendingColor or { r = 0, g = 0.8, b = 1, a = 1 }
    local hex = string.format("|cff%02x%02x%02x",
        math.floor((pColor.r or 0) * 255),
        math.floor((pColor.g or 0.8) * 255),
        math.floor((pColor.b or 1) * 255))

    local names = {}
    for _, factionName in pairs(rewards) do
        table.insert(names, string.upper(factionName))
    end

    local totalCount = #names
    local factionStr = names[1] or ""
    if totalCount > 1 then
        local last = table.remove(names)
        factionStr = table.concat(names, ", ") .. (Locales["AND"] or " & ") .. last
    end

    local suffix = (totalCount > 1) and (Locales["REWARD_PENDING_PLURAL"] or " have rewards!") or (Locales["REWARD_PENDING_SINGLE"] or " has a reward!")
    local message = hex .. factionStr .. suffix .. "|r"

    if _G.RaidNotice_AddMessage and _G.RaidWarningFrame and _G.ChatTypeInfo then
        _G.RaidNotice_AddMessage(_G.RaidWarningFrame, message, _G.ChatTypeInfo["RAID_WARNING"])
    end
end
