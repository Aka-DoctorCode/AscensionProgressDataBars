-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: DataText.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...
---@type AscensionBars
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars", true) or {}

-------------------------------------------------------------------------------
-- DataText Module Definition
-------------------------------------------------------------------------------

addonTable.dataText = {}
local dataText = addonTable.dataText

function dataText:FormatValue(value, profile)
    if not value then return "0" end
    if profile.useCompactFormat then return self:FormatCompact(value) end
    return BreakUpLargeNumbers(value) or tostring(value)
end

function dataText:FormatCompact(value)
    if not value or value == 0 then return "0" end
    if value >= 1000000 then return string.format("%.1fM", value / 1000000)
    elseif value >= 1000 then return string.format("%.1fk", value / 1000) end
    return tostring(value)
end

------------------------------------------------------------------------------- 
-- Manages Layout
-------------------------------------------------------------------------------
function dataText:initBarText(barObject)
    if not barObject or not barObject.bar then return end
    -- Anclajes de los textos (solo posicionamiento, sin hooks)
    if barObject.leftText then
        barObject.leftText:ClearAllPoints()
        barObject.leftText:SetPoint("LEFT", barObject.bar, "LEFT", 10, 0)
        barObject.leftText:SetJustifyH("LEFT")
        barObject.leftText:SetDrawLayer("OVERLAY", 7)
        barObject.leftText:SetText("")
    end
    if barObject.centerText then
        barObject.centerText:ClearAllPoints()
        barObject.centerText:SetPoint("CENTER", barObject.bar, "CENTER", 0, 0)
        barObject.centerText:SetJustifyH("CENTER")
        barObject.centerText:SetDrawLayer("OVERLAY", 7)
        barObject.centerText:SetText("")
    end
    if barObject.rightText then
        barObject.rightText:ClearAllPoints()
        barObject.rightText:SetPoint("RIGHT", barObject.bar, "RIGHT", -10, 0)
        barObject.rightText:SetJustifyH("RIGHT")
        barObject.rightText:SetDrawLayer("OVERLAY", 7)
        barObject.rightText:SetText("")
    end
    -- Los hooks de ratón ya están definidos en createBar (AscensionProgressDataBars.lua)
end

-------------------------------------------------------------------------------
-- Formatting Functions
-------------------------------------------------------------------------------

function dataText:formatExperience()
    if not ascensionBars.db or not ascensionBars.db.profile then
        return ""
    end
    local profile = ascensionBars.db.profile
    local isConfig = profile.configMode
    local currentXP = isConfig and 4500 or (UnitXP("player") or 0)
    local maxXP = isConfig and 10000 or (UnitXPMax("player") or 1)
    local levelValue = isConfig and 60 or UnitLevel("player")
    local restedXP = isConfig and 2000 or (GetXPExhaustion() or 0)
    local calculatedPercentage = (currentXP / maxXP) * 100
    local levelText = string.format(Locales["LEVEL_TEXT"] or "Level %d", levelValue)
    local mainPart = string.format("%s | %s / %s (%.1f%%)", levelText, self:FormatValue(currentXP, profile), self:FormatValue(maxXP, profile), calculatedPercentage)
    if restedXP > 0 then
        local restedPercentage = (restedXP / maxXP) * 100
        local restedStr = string.format(" | Rested: %s (%.1f%%)", self:FormatValue(restedXP, profile), restedPercentage)
        return mainPart .. restedStr
    end
    return mainPart
end

function dataText:formatReputation(name, standingLabel, curVal, maxVal, isMaxLevel, hasParagon)
    if not ascensionBars.db or not ascensionBars.db.profile then
        return ""
    end
    local profile = ascensionBars.db.profile
    local isConfig = profile.configMode
    local factionName = (isConfig or not name) and (Locales["REPUTATION"] or "Reputation") or name
    local standingText = standingLabel
    if isConfig then standingText = Locales["EXALTED"] or "Exalted" end
    if hasParagon then standingText = Locales["PARAGON"] or "Paragon" end
    if not standingText then standingText = "Neutral" end
    local currentValue = isConfig and 1200 or math.max(0, curVal or 0)
    local maxValue = isConfig and 3000 or math.max(1, maxVal or 1)
    local identity = string.format("%s - %s", factionName, standingText)
    if isMaxLevel and not hasParagon then
        return string.format("%s | 100.0%%", identity)
    else
        local percentage = (currentValue / maxValue) * 100
        local details = string.format("%s / %s (%.1f%%)", self:FormatValue(currentValue, profile), self:FormatValue(maxValue, profile), percentage)
        return string.format("%s | %s", identity, details)
    end
end

function dataText:formatHonor(current, max, percentage)
    if not ascensionBars.db or not ascensionBars.db.profile then
        return ""
    end
    local profile = ascensionBars.db.profile
    local isConfig = profile.configMode
    local honorLevel = isConfig and 45 or (UnitHonorLevel("player") or 0)
    local currentValue = isConfig and 1500 or (current or 0)
    local maxValue = isConfig and 3000 or (max or 100)
    local calculatedPercentage = isConfig and 50.0 or (percentage or 0)
    local levelText = string.format(Locales["LEVEL_TEXT"] or "Level %d", honorLevel)
    return string.format("%s | %s / %s (%.1f%%)", levelText, self:FormatValue(currentValue, profile), self:FormatValue(maxValue, profile), calculatedPercentage)
end

function dataText:formatHousing(addressString, currentLevel, currentFavor, maxFavor)
    if not ascensionBars.db or not ascensionBars.db.profile then
        return ""
    end
    local profile = ascensionBars.db.profile
    local isConfig = profile.configMode
    local address = isConfig and "My Neighborhood" or (addressString or Locales["HOUSE_XP"] or "House")
    local levelValue = isConfig and 3 or (currentLevel or 0)
    local currentValue = isConfig and 750 or (currentFavor or 0)
    local maxValue = isConfig and 1000 or (maxFavor or 1)
    if maxValue <= 0 then maxValue = 1 end
    local calculatedPercentage = (currentValue / maxValue) * 100
    local levelText = string.format("%s " .. (Locales["LEVEL_TEXT"] or "Level %d"), address, levelValue)
    return string.format("%s | %s / %s (%.1f%%)", levelText, self:FormatValue(currentValue, profile), self:FormatValue(maxValue, profile), calculatedPercentage)
end

function dataText:formatAzerite(current, max, percentage)
    if not ascensionBars.db or not ascensionBars.db.profile then
        return ""
    end
    local profile = ascensionBars.db.profile
    local isConfig = profile.configMode
    local azeriteLevel = isConfig and 30 or 0
    if not isConfig and C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem then
        local itemLocation = C_AzeriteItem.FindActiveAzeriteItem()
        if itemLocation then azeriteLevel = C_AzeriteItem.GetPowerLevel(itemLocation) or 0 end
    end
    local currentValue = isConfig and 2500 or (current or 0)
    local maxValue = isConfig and 5000 or (max or 100)
    local calculatedPercentage = isConfig and 50.0 or (percentage or 0)
    local levelText = string.format((Locales["AZERITE"] or "Azerite") .. " Level %d", azeriteLevel)
    return string.format("%s | %s / %s (%.1f%%)", levelText, self:FormatValue(currentValue, profile), self:FormatValue(maxValue, profile), calculatedPercentage)
end