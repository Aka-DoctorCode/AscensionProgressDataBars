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
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

--- Requests the latest favor data from the server.
function ascensionBars:refreshHousingFavor()
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

--- Internal helper to scan for house names using localized fallback.
-- @param guid string|number The house GUID to look for.
-- @return string|nil The discovered house name or address.
local function findHouseName(guid)
    if not guid or guid == 0 or guid == "0" then return nil end
    local guidStr = tostring(guid)

    -- 1. Scan Current Neighborhood (12.0.0 API)
    if C_HousingNeighborhood and C_HousingNeighborhood.GetNeighborhoodName then
        local name = C_HousingNeighborhood.GetNeighborhoodName()
        if name and name ~= "" then return name end
    end

    -- 2. Scan Current House Info
    if C_Housing and C_Housing.GetCurrentHouseInfo then
        local info = C_Housing.GetCurrentHouseInfo()
        if type(info) == "table" then
            if (info.houseGUID and tostring(info.houseGUID) == guidStr) or 
                (info.neighborhoodGUID and tostring(info.neighborhoodGUID) == guidStr) then
                return info.houseName or info.neighborhoodName
            end
        end
    end

    -- 3. Fallback: Blizzard UI Scraping
    local dashboard = _G["HousingDashboardFrame"]
    if dashboard and dashboard.HouseInfoContent then
        local contentFrame = dashboard.HouseInfoContent.ContentFrame
        local upgradeFrame = contentFrame and contentFrame.HouseUpgradeFrame
        if upgradeFrame and upgradeFrame.AddressText then
            local uiText = upgradeFrame.AddressText:GetText()
            if uiText and uiText ~= "" then return uiText end
        end
    end

    return Locales["HOUSE_XP"] -- "House Favor" fallback from Locales
end

--- Obtiene el nivel máximo de la casa rastreada actualmente.
-- @param guid string|number GUID de la casa.
-- @return number El nivel máximo, o 0 si no se puede determinar.
local function getHouseMaxLevel(guid)
    if not guid or guid == 0 or guid == "0" then return 0 end
    local level = 1
    while true do
        local favorReq = C_Housing.GetHouseLevelFavorForLevel(level)
        if not favorReq or favorReq <= 0 then
            return level - 1
        end
        level = level + 1
        if level > 100 then break end -- Límite de seguridad
    end
    return 0
end

--- Event handler for house favor updates
function ascensionBars:onHouseFavorUpdated(_, houseLevelFavor)
    if not (C_Housing and houseLevelFavor and self.db.profile) then return end
    
    local profile = self.db.profile
    local trackedGuid = C_Housing.GetTrackedHouseGuid()
    
    if houseLevelFavor.houseGUID == trackedGuid then
        local guidStr = tostring(trackedGuid)
        
        -- Save to persistent profile cache
        profile.housingCache.lastTrackedGuid = guidStr
        profile.housingCache.houses[guidStr] = profile.housingCache.houses[guidStr] or {}
        profile.housingCache.houses[guidStr].favor = houseLevelFavor.houseFavor or 0
        profile.housingCache.houses[guidStr].level = houseLevelFavor.houseLevel or 0
        
        if houseLevelFavor.houseName or houseLevelFavor.neighborhoodName then
            profile.housingCache.houses[guidStr].name = houseLevelFavor.houseName or houseLevelFavor.neighborhoodName
        end

        if self.updateDisplay then 
            self:updateDisplay() 
        end
    end
end

--- Renders the Housing Favor bar
function ascensionBars:renderHouseXp()
    if not self.db or not self.db.profile then return end
    
    local profile = self.db.profile
    local bars = profile.bars
    local houseObj = self.houseXp

    if not (houseObj and bars["HouseXp"] and bars["HouseXp"].enabled) then 
        if houseObj then
            houseObj.bar:Hide()
            houseObj.txFrame:Hide()
            if self.houseRewardText then self.houseRewardText:Hide() end
        end
        return 
    end

    -- Color por defecto: naranja casa (#FF801A)
    local color = profile.houseXpColor or { r = 1.0, g = 0.5, b = 0.1, a = 1.0 }
    local currentFavor, maxFavor, currentLevel = 0, 1, 0
    local isMonitoring = false
    local addressString = Locales["HOUSE_XP"]
    local maxLevel = 0

    local trackedGuid = C_Housing.GetTrackedHouseGuid()
    if not trackedGuid or trackedGuid == 0 or trackedGuid == "0" or trackedGuid == "" then
        trackedGuid = profile.housingCache.lastTrackedGuid
    end
    
    if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "0" and trackedGuid ~= "" then
        isMonitoring = true
        local guidStr = tostring(trackedGuid)
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

        -- Obtener o calcular el nivel máximo de la casa
        if cache.maxLevel then
            maxLevel = cache.maxLevel
        else
            maxLevel = getHouseMaxLevel(trackedGuid)
            cache.maxLevel = maxLevel
        end

        -- Determinar el favor necesario para el siguiente nivel
        local nextLevel = currentLevel + 1
        local nextFavor = C_Housing.GetHouseLevelFavorForLevel and C_Housing.GetHouseLevelFavorForLevel(nextLevel)
        if nextFavor and nextFavor > 0 then
            maxFavor = nextFavor
        else
            -- No hay siguiente nivel (la casa ya está al máximo)
            maxFavor = currentFavor  -- para que el porcentaje sea 100%
            if maxFavor <= 0 then maxFavor = 1 end  -- seguridad
        end
    end

    if isMonitoring then
        houseObj.bar:Show()
        houseObj.txFrame:Show()
        self:setupBar(houseObj, 0, maxFavor, currentFavor, color)
        
        local percentage = (currentFavor / maxFavor) * 100
        local showAbs = profile.showAbsoluteValues
        local showPct = profile.showPercentage

        -- Formatear el texto usando las claves de localización (ajustadas previamente)
        local text
        if showAbs and showPct then
            text = string.format(Locales["HOUSE_LEVEL_FORMAT"], 
                addressString, 
                currentLevel, 
                BreakUpLargeNumbers(currentFavor), 
                BreakUpLargeNumbers(maxFavor), 
                percentage)
        elseif showAbs then
            text = string.format(Locales["HOUSE_LEVEL_ABS"], 
                addressString, 
                currentLevel, 
                BreakUpLargeNumbers(currentFavor), 
                BreakUpLargeNumbers(maxFavor))
        elseif showPct then
            text = string.format(Locales["HOUSE_LEVEL_PCT"], 
                addressString, 
                currentLevel, 
                percentage)
        else
            text = string.format(Locales["HOUSE_LEVEL_SIMPLE"], 
                addressString, 
                currentLevel)
        end

        houseObj.text:SetText(text)
        
        -- Mostrar mensaje de recompensa SOLO si hay mejora real
        -- (favor suficiente y nivel actual < nivel máximo)
        if currentFavor >= maxFavor and currentLevel < maxLevel then
            if not self.houseRewardText then
                self.houseRewardText = self.textHolder:CreateFontString(nil, "OVERLAY")
            end
            
            local activeFont = self.fontToUse or [[Fonts\FRIZQT__.TTF]]
            self.houseRewardText:SetFont(activeFont, profile.paragonTextSize or 14, "OUTLINE, THICK")
            
            local rewardColor = profile.houseRewardTextColor or color
            local hex = string.format("|cff%02x%02x%02x",
                math.floor((rewardColor.r or 1) * 255),
                math.floor((rewardColor.g or 0.5) * 255),
                math.floor((rewardColor.b or 0.1) * 255))

            self.houseRewardText:SetText(hex .. string.format(Locales["HOUSE_UPGRADES_AVAILABLE"], string.upper(addressString)) .. "|r")
            self.houseRewardText:Show()
            
            local offset = profile.houseRewardTextYOffset or -40
            self.houseRewardText:ClearAllPoints()
            if profile.barAnchor == "BOTTOM" then
                self.houseRewardText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, -offset)
            else
                self.houseRewardText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, offset)
            end
        else
            if self.houseRewardText then self.houseRewardText:Hide() end
        end
    else
        houseObj.bar:Hide()
        houseObj.txFrame:Hide()
        if self.houseRewardText then self.houseRewardText:Hide() end
    end
end