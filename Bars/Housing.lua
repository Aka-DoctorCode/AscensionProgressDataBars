-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Housing.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

function ascensionBars:refreshHousingFavor()
    if not (C_Housing and C_Housing.GetTrackedHouseGuid) then return end
    local trackedGuid = C_Housing.GetTrackedHouseGuid()
    if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "0" and trackedGuid ~= "" then
        if C_Housing.GetCurrentHouseLevelFavor then
            C_Housing.GetCurrentHouseLevelFavor(trackedGuid)
        end
    else
        self.state.houseLevelFavor = nil
    end
end

function ascensionBars:onHouseFavorUpdated(event, houseLevelFavor)
    if C_Housing and C_Housing.GetTrackedHouseGuid and houseLevelFavor then
        local trackedGuid = C_Housing.GetTrackedHouseGuid()
        if houseLevelFavor.houseGUID == trackedGuid and self.state then
            self.state.houseLevelFavor = houseLevelFavor
            if self.updateDisplay then self:updateDisplay() end
        end
    end
end

function ascensionBars:renderHouseXp()
    local profile = self.db and self.db.profile
    if not profile then return end

    if self.houseXp and profile and profile.bars and profile.bars["HouseXp"] and profile.bars["HouseXp"].enabled then
        self.houseXp.bar:Show()
        self.houseXp.txFrame:Show()
        local color = profile.houseXpColor or { r = 0.9, g = 0.5, b = 0.0, a = 1.0 }
        local currentFavor = 0
        local minFavor = 0
        local maxFavor = 1
        local currentLevel = 1
        local houseName = "House Favor"
        local isMonitoringHouse = false
        local currentHouseAddress = ""

        local trackedGuid = C_Housing and C_Housing.GetTrackedHouseGuid and C_Housing.GetTrackedHouseGuid()
        if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "0" and trackedGuid ~= "" and self.state and self.state.houseLevelFavor then
            local data = self.state.houseLevelFavor
            if data.houseGUID == trackedGuid then
                isMonitoringHouse = true
                currentFavor = data.houseFavor or 0
                currentLevel = data.houseLevel or 1
                currentHouseAddress = data.houseName or data.neighborhoodName or "House Favor"
                houseName = string.format("%s - Level %d", currentHouseAddress, currentLevel)
                if C_Housing and C_Housing.GetHouseLevelFavorForLevel then
                    minFavor = C_Housing.GetHouseLevelFavorForLevel(currentLevel) or 0
                    maxFavor = C_Housing.GetHouseLevelFavorForLevel(currentLevel + 1) or 1
                end
            end
        end

        if maxFavor <= minFavor then maxFavor = minFavor + 1 end
        self:setupBar(self.houseXp, minFavor, maxFavor, currentFavor, color)

        if isMonitoringHouse then
            local currentProgress = currentFavor - minFavor
            local maxProgress = maxFavor - minFavor
            if maxProgress <= 0 then maxProgress = 1 end
            local percentage = (currentProgress / maxProgress) * 100

            if percentage >= 100 then
                self.houseXp.text:SetText(houseName)
                if not self.houseRewardText then
                    self.houseRewardText = self.textHolder:CreateFontString(nil, "OVERLAY")
                end
                self.houseRewardText:SetFont(self.fontToUse, profile.paragonTextSize or 18, "THICKOUTLINE")
                local rewardColor = profile.houseRewardTextColor or color
                local hex = string.format("|cff%02x%02x%02x",
                    math.floor((rewardColor.r or 0.9) * 255),
                    math.floor((rewardColor.g or 0.5) * 255),
                    math.floor((rewardColor.b or 0.0) * 255))
                self.houseRewardText:SetText(hex .. "House Upgrades available for " .. currentHouseAddress .. "|r")
                self.houseRewardText:Show()
                self.houseRewardText:ClearAllPoints()
                local offset = profile.houseRewardTextYOffset or profile.paragonTextYOffset or -40
                if profile.paragonOnTop then
                    self.houseRewardText:SetPoint("TOP", UIParent, "TOP", 0, offset - 20)
                else
                    if profile.barAnchor == "BOTTOM" then
                        self.houseRewardText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, (-offset) + 20)
                    else
                        self.houseRewardText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, offset - 20)
                    end
                end
            else
                local valueStr = BreakUpLargeNumbers(currentProgress)
                local maxStr = BreakUpLargeNumbers(maxProgress)
                if profile.showAbsoluteValues and profile.showPercentage then
                    self.houseXp.text:SetText(string.format("%s %s/%s (%.1f%%)", houseName, valueStr, maxStr, percentage))
                elseif profile.showAbsoluteValues then
                    self.houseXp.text:SetText(string.format("%s %s/%s", houseName, valueStr, maxStr))
                elseif profile.showPercentage then
                    self.houseXp.text:SetText(string.format("%s %.1f%%", houseName, percentage))
                else
                    self.houseXp.text:SetText(houseName)
                end
                if self.houseRewardText then self.houseRewardText:Hide() end
            end
        else
            self.houseXp.bar:SetMinMaxValues(0, 1)
            self.houseXp.bar:SetValue(0)
            self.houseXp.text:SetText("No House Watched")
            if self.houseRewardText then self.houseRewardText:Hide() end
        end

        local textColor = profile.textColor
        if textColor then
            self.houseXp.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1,
                textColor.a or 1)
        end
    elseif self.houseXp then
        self.houseXp.bar:Hide()
        self.houseXp.txFrame:Hide()
        if self.houseRewardText then self.houseRewardText:Hide() end
    end
end

function ascensionBars:configHouseXp(profile, bars, textColor)
    local houseConfig = bars["HouseXp"]
    if self.houseXp and houseConfig and houseConfig.enabled then
        self.houseXp.bar:Show()
        self.houseXp.txFrame:Show()
        local houseColor = profile.houseXpColor or { r = 0.9, g = 0.5, b = 0.0, a = 1.0 }
        self:setupBar(self.houseXp, 0, 1000, 600, houseColor)

        local configText = Locales["HOUSE_XP_BAR_DATA"]
        local showAbs = profile.showAbsoluteValues
        local showPct = profile.showPercentage
        if showAbs and showPct then
            self.houseXp.text:SetText(configText .. " | 600/1,000 (60.0%)")
        elseif showAbs then
            self.houseXp.text:SetText(configText .. " | 600/1,000")
        elseif showPct then
            self.houseXp.text:SetText(configText .. " | 60.0%")
        else
            self.houseXp.text:SetText(configText)
        end
        self.houseXp.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)

        if not self.houseRewardText then
            self.houseRewardText = self.textHolder:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        end
        local pSize = profile.paragonTextSize or 18
        self.houseRewardText:SetFont(self.fontToUse, pSize, "THICKOUTLINE")
        local rewardColor = profile.houseRewardTextColor or houseColor
        local hex = string.format("|cff%02x%02x%02x",
            math.floor((rewardColor.r or 0.9) * 255),
            math.floor((rewardColor.g or 0.5) * 255),
            math.floor((rewardColor.b or 0.0) * 255))
        self.houseRewardText:SetText(hex .. "[CONFIG] HOUSE UPGRADE FOR ADDRESS|r")
        self.houseRewardText:Show()
        self.houseRewardText:ClearAllPoints()
        local hOffset = profile.houseRewardTextYOffset or profile.paragonTextYOffset or -40
        if profile.paragonOnTop then
            self.houseRewardText:SetPoint("TOP", UIParent, "TOP", 0, hOffset - 20)
        else
            local barAnchor = profile.barAnchor
            if barAnchor == "BOTTOM" then
                self.houseRewardText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, (-hOffset) + 20)
            else
                self.houseRewardText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, hOffset - 20)
            end
        end
    elseif self.houseXp then
        self.houseXp.bar:Hide()
        self.houseXp.txFrame:Hide()
        if self.houseRewardText then self.houseRewardText:Hide() end
    end
end
