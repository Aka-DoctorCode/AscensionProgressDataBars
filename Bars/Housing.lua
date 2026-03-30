-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Bars/Housing.lua
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
local core = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast core AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")
local dataText = addonTable.dataText

-------------------------------------------------------------------------------
-- MODULE DEFINITION
-------------------------------------------------------------------------------

local HousingModule = core:NewModule("Housing", "AceEvent-3.0")
HousingModule.core  = core

-------------------------------------------------------------------------------
-- HELPER FUNCTIONS
-------------------------------------------------------------------------------

local function findHouseName(guid)
    if not guid or guid == 0 or guid == "0" then return nil end
    local guidStr = tostring(guid)

    if C_HousingNeighborhood and C_HousingNeighborhood.GetNeighborhoodName then
        local name = C_HousingNeighborhood.GetNeighborhoodName()
        if name and name ~= "" then return name end
    end

    if C_Housing and C_Housing.GetCurrentHouseInfo then
        local info = C_Housing.GetCurrentHouseInfo()
        if type(info) == "table" then
            if (info.houseGUID and tostring(info.houseGUID) == guidStr) or 
                (info.neighborhoodGUID and tostring(info.neighborhoodGUID) == guidStr) then
                return info.houseName or info.neighborhoodName
            end
        end
    end

    local dashboard = _G["HousingDashboardFrame"]
    if dashboard and dashboard.HouseInfoContent then
        local contentFrame = dashboard.HouseInfoContent.ContentFrame
        local upgradeFrame = contentFrame and contentFrame.HouseUpgradeFrame
        if upgradeFrame and upgradeFrame.AddressText then
            local uiText = upgradeFrame.AddressText:GetText()
            if uiText and uiText ~= "" then return uiText end
        end
    end

    return Locales["HOUSE_XP"]
end

local function getHouseMaxLevel(guid)
    if not guid or guid == 0 or guid == "0" then return 0 end
    if not (C_Housing and C_Housing.GetHouseLevelFavorForLevel) then return 0 end
    local level = 1
    while true do
        local favorReq = C_Housing.GetHouseLevelFavorForLevel(level)
        if not favorReq or favorReq <= 0 then
            return level - 1
        end
        level = level + 1
        if level > 100 then break end
    end
    return 0
end

-------------------------------------------------------------------------------
-- MODULE LIFECYCLE
-------------------------------------------------------------------------------

function HousingModule:OnEnable()
    self:RegisterEvent("HOUSE_LEVEL_FAVOR_UPDATED", "onHouseFavorUpdated")
end

function HousingModule:OnDisable()
    self:UnregisterAllEvents()
end

-------------------------------------------------------------------------------
-- EVENT HANDLERS
-------------------------------------------------------------------------------

function HousingModule:onHouseFavorUpdated(_, houseLevelFavor)
    if not (C_Housing and houseLevelFavor and self.core.db and self.core.db.profile) then return end
    local profile = self.core.db.profile
    local trackedGuid = C_Housing.GetTrackedHouseGuid()
    
    if houseLevelFavor.houseGUID == trackedGuid then
        local guidStr = tostring(trackedGuid)
        
        self.core.state = self.core.state or {}
        self.core.state.lastHouseFavor = self.core.state.lastHouseFavor or {}
        
        local lastFavor = self.core.state.lastHouseFavor[guidStr] or 0
        local currentFavor = houseLevelFavor.houseFavor or 0
        
        if lastFavor > 0 and currentFavor > lastFavor then
            local gained = currentFavor - lastFavor
            local name = houseLevelFavor.houseName or houseLevelFavor.neighborhoodName or Locales["HOUSE_FAVOR"]
            if self.core.pushCarouselEvent then
                self.core:pushCarouselEvent("HOUSE", guidStr, name, gained)
            end
        end
        
        self.core.state.lastHouseFavor[guidStr] = currentFavor
        profile.housingCache = profile.housingCache or {}
        profile.housingCache.lastTrackedGuid = guidStr
        profile.housingCache.houses = profile.housingCache.houses or {}
        profile.housingCache.houses[guidStr] = profile.housingCache.houses[guidStr] or {}
        profile.housingCache.houses[guidStr].favor = houseLevelFavor.houseFavor or 0
        profile.housingCache.houses[guidStr].level = houseLevelFavor.houseLevel or 0
        
        if houseLevelFavor.houseName or houseLevelFavor.neighborhoodName then
            profile.housingCache.houses[guidStr].name = houseLevelFavor.houseName or houseLevelFavor.neighborhoodName
        end

        if self.core.updateDisplay then 
            self.core:updateDisplay() 
        end
    end
end

-------------------------------------------------------------------------------
-- RENDER DISPATCH
-------------------------------------------------------------------------------

function HousingModule:UpdateRender(isConfig, shouldHideXP)
    if isConfig then
        self:renderConfig()
    else
        self:renderLive()
    end
end

-------------------------------------------------------------------------------
-- LIVE RENDER
-------------------------------------------------------------------------------

function HousingModule:renderLive()
    if not self.core.db or not self.core.db.profile then return end
    if not (C_Housing and C_Housing.GetTrackedHouseGuid) then return end

    local profile = self.core.db.profile
    local bars = profile.bars or {}
    local houseObj = self.core.houseXp

    if not (houseObj and bars["HouseXp"] and bars["HouseXp"].enabled) then
        if houseObj then
            if houseObj.bar     then houseObj.bar:Hide()     end
            if houseObj.txFrame then houseObj.txFrame:Hide() end
            if self.core.houseRewardText then self.core.houseRewardText:Hide() end
        end
        return
    end

    local color = profile.houseXpColor or { r = 1.0, g = 0.5, b = 0.1, a = 1.0 }
    local currentFavor, maxFavor, currentLevel = 0, 1, 0
    local isMonitoring = false
    local addressString = Locales["HOUSE_XP"]
    local maxLevel = 0

    local trackedGuid = C_Housing.GetTrackedHouseGuid()
    if not trackedGuid or trackedGuid == 0 or trackedGuid == "0" or trackedGuid == "" then
        profile.housingCache = profile.housingCache or {}
        trackedGuid = profile.housingCache.lastTrackedGuid
    end
    
    if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "0" and trackedGuid ~= "" then
        isMonitoring = true
        local guidStr = tostring(trackedGuid)
        profile.housingCache = profile.housingCache or {}
        profile.housingCache.houses = profile.housingCache.houses or {}
        local cache = profile.housingCache.houses[guidStr] or {}

        local foundName = findHouseName(trackedGuid)
        if foundName then
            cache.name = foundName
            addressString = foundName
        else
            addressString = cache.name or Locales["HOUSE_XP"]
        end

        currentFavor = cache.favor or (C_Housing.GetCurrentHouseLevelFavor and C_Housing.GetCurrentHouseLevelFavor(trackedGuid)) or 0
        currentLevel = cache.level or 0

        if cache.maxLevel then
            maxLevel = cache.maxLevel
        else
            maxLevel = getHouseMaxLevel(trackedGuid)
            cache.maxLevel = maxLevel
        end

        local nextLevel = currentLevel + 1
        local nextFavor = (C_Housing and C_Housing.GetHouseLevelFavorForLevel) and C_Housing.GetHouseLevelFavorForLevel(nextLevel) or nil
        if nextFavor and nextFavor > 0 then
            maxFavor = nextFavor
        else
            maxFavor = currentFavor
            if maxFavor <= 0 then maxFavor = 1 end
        end
    end

    if isMonitoring then
        if houseObj.bar     then houseObj.bar:Show()     end
        if houseObj.txFrame then houseObj.txFrame:Show() end
        
        self.core:setupBar(houseObj, 0, maxFavor, currentFavor, color)
        
        local percentage = (currentFavor / maxFavor) * 100

        houseObj.current = currentFavor
        houseObj.max = maxFavor
        houseObj.percentage = percentage
        houseObj.displayName = addressString
        houseObj.level = currentLevel
        houseObj.color = color

        if dataText and houseObj.centerText then
            local result = dataText:formatHousing(addressString, currentLevel, currentFavor, maxFavor)
            houseObj.centerText:SetText(result)
            if houseObj.leftText  then houseObj.leftText:SetText("")  end
            if houseObj.rightText then houseObj.rightText:SetText("") end
        end
        
        if currentFavor >= maxFavor and currentLevel < maxLevel then
            if self.core.houseRewardText then
                local activeFont = self.core.fontToUse or [[Fonts\FRIZQT__.TTF]]
                local pSize = profile.houseRewardTextSize or 18
                self.core.houseRewardText:SetFont(activeFont, pSize, "OUTLINE")
                
                local rewardColor = profile.houseRewardTextColor or { r = 1, g = 0.5, b = 0.1, a = 1.0 }
                local hex = string.format("|cff%02x%02x%02x",
                    math.floor((rewardColor.r or 1) * 255),
                    math.floor((rewardColor.g or 0.5) * 255),
                    math.floor((rewardColor.b or 0.1) * 255))

                self.core.houseRewardText:SetText(hex .. string.format(Locales["HOUSE_UPGRADES_AVAILABLE"], string.upper(addressString)) .. "|r")
                self.core.houseRewardText:Show()
                
                local pX = profile.houseRewardXOffset or 0
                local pY = profile.houseRewardTextYOffset or -60
                
                self.core.houseRewardText:ClearAllPoints()
                self.core.houseRewardText:SetPoint("TOP", UIParent, "TOP", pX, pY)
            end
        else
            if self.core.houseRewardText then self.core.houseRewardText:Hide() end
        end
    else
        if houseObj.bar     then houseObj.bar:Hide()     end
        if houseObj.txFrame then houseObj.txFrame:Hide() end
        if self.core.houseRewardText then self.core.houseRewardText:Hide() end
    end
end

-------------------------------------------------------------------------------
-- CONFIG PREVIEW RENDER
-------------------------------------------------------------------------------

function HousingModule:renderConfig()
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local houseObj = self.core.houseXp
    if not houseObj then return end
    
    local houseConfig = profile.bars and profile.bars["HouseXp"]
    if houseConfig and houseConfig.enabled then
        if houseObj.bar     then houseObj.bar:Show()     end
        if houseObj.txFrame then houseObj.txFrame:Show() end
        
        local color = profile.houseXpColor or { r = 1.0, g = 0.5, b = 0.1, a = 1.0 }
        self.core:setupBar(houseObj, 0, 100, 45, color)
        
        houseObj.current = 450
        houseObj.max = 1000
        houseObj.percentage = 45
        houseObj.displayName = Locales["HOUSE_XP"] or "House"
        houseObj.level = 3
        houseObj.color = color
        
        if houseObj.centerText then
            houseObj.centerText:SetText((Locales["HOUSE_XP"] or "House") .. ": 45%")
        end
    else
        if houseObj.bar     then houseObj.bar:Hide()     end
        if houseObj.txFrame then houseObj.txFrame:Hide() end
        if self.core.houseRewardText then self.core.houseRewardText:Hide() end
    end
end

-- Backward-compat shims
function core:refreshHousingFavor()
    if not (C_Housing and C_Housing.GetTrackedHouseGuid) then return end
    local trackedGuid = C_Housing.GetTrackedHouseGuid()
    if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "0" and trackedGuid ~= "" then
        if C_Housing.GetCurrentHouseLevelFavor then
            C_Housing.GetCurrentHouseLevelFavor(trackedGuid)
        end
    else
        if self.state then 
            self.state.houseLevelFavor = nil 
        end
    end
end

function core:renderHouseXp()
    local mod = self:GetModule("Housing", true)
    if mod then mod:renderLive() end
end

function core:configHouseXp(profile, bars, textColor)
    local mod = self:GetModule("Housing", true)
    if mod then mod:renderConfig() end
end