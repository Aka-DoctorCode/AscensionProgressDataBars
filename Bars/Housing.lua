-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Housing.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
-------------------------------------------------------------------------------

local _, addonTable = ...
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonTable.addonName or "AscensionBars")
---@cast ascensionBars AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

--- Refreshes the housing favor by requesting data from the server
function ascensionBars:refreshHousingFavor()
    if not (C_Housing and C_Housing.GetTrackedHouseGuid) then return end
    
    local trackedGuid = C_Housing.GetTrackedHouseGuid()
    if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "0" and trackedGuid ~= "" then
        if C_Housing.GetCurrentHouseLevelFavor then
            -- This triggers the HOUSE_LEVEL_FAVOR_UPDATED event
            C_Housing.GetCurrentHouseLevelFavor(trackedGuid)
        end
    else
        if self.state then 
            self.state.houseLevelFavor = nil 
        end
    end
end

--- Event handler for house favor updates
--- @param houseLevelFavor table The data structure returned by the API
function ascensionBars:onHouseFavorUpdated(event, houseLevelFavor)
    if C_Housing and C_Housing.GetTrackedHouseGuid and houseLevelFavor then
        local trackedGuid = C_Housing.GetTrackedHouseGuid()
        if houseLevelFavor.houseGUID == trackedGuid and self.state then
            self.state.houseLevelFavor = houseLevelFavor
            if self.updateDisplay then 
                self:updateDisplay() 
            end
        end
    end
end

--- Renders the Housing Experience/Favor bar
function ascensionBars:renderHouseXp()
    local profile = self.db and self.db.profile
    if not (profile and self.houseXp and profile.bars["HouseXp"] and profile.bars["HouseXp"].enabled) then 
        if self.houseXp then
            self.houseXp.bar:Hide()
            self.houseXp.txFrame:Hide()
            if self.houseRewardText then self.houseRewardText:Hide() end
        end
        return 
    end

    local color = profile.houseXpColor or { r = 0.9, g = 0.5, b = 0.0, a = 1.0 } -- #E68000
    local currentFavor, minFavor, maxFavor, currentLevel = 0, 0, 1, 1
    local isMonitoringHouse = false
    local addressString = Locales["UNKNOWN_FACTION"] or "Unknown Address"

    local trackedGuid = C_Housing.GetTrackedHouseGuid()
    
    if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "" and self.state and self.state.houseLevelFavor then
        local data = self.state.houseLevelFavor
        if data.houseGUID == trackedGuid then
            isMonitoringHouse = true
            currentFavor = data.houseFavor or 0
            currentLevel = data.houseLevel or 1
            
            -- 1. Get address from Neighborhood system
            if C_HousingNeighborhood and C_HousingNeighborhood.GetNeighborhoodName then
                local neighborhoodName = C_HousingNeighborhood.GetNeighborhoodName()
                if neighborhoodName and neighborhoodName ~= "" then
                    addressString = neighborhoodName
                end
            end

            -- 2. Fallback: Get House Info if Neighborhood is unavailable
            if addressString == "Unknown Address" then
                if C_Housing.GetCurrentHouseInfo then
                    local info = C_Housing.GetCurrentHouseInfo()
                    if info and (info.houseGUID == trackedGuid or info.guid == trackedGuid) then
                        addressString = info.houseName or info.neighborhoodName or addressString
                    end
                end
            end
            
            -- 3. Final Fallback: Use ID if still unknown
            if addressString == "Unknown Address" then 
                addressString = "House " .. tostring(data.houseGUID) 
            end

            -- 4. Get Favor ranges
            if C_Housing.GetHouseLevelFavorForLevel then
                minFavor = C_Housing.GetHouseLevelFavorForLevel(currentLevel) or 0
                maxFavor = C_Housing.GetHouseLevelFavorForLevel(currentLevel + 1) or 1
            end
        end
    end

    if maxFavor <= minFavor then maxFavor = minFavor + 1 end
    self:setupBar(self.houseXp, minFavor, maxFavor, currentFavor, color)

    if isMonitoringHouse then
        self.houseXp.bar:Show()
        self.houseXp.txFrame:Show()
        
        local currentProgress = currentFavor - minFavor
        local maxProgress = maxFavor - minFavor
        local percentage = (maxProgress > 0) and (currentProgress / maxProgress) * 100 or 0
        
        local actualStr = BreakUpLargeNumbers(currentProgress)
        local maximoStr = BreakUpLargeNumbers(maxProgress)

        -- FORMAT: Address Level # | actual / maximum (percentage)
        local barText = string.format("%s Level %d | %s / %s (%.1f%%)", 
            addressString, currentLevel, actualStr, maximoStr, percentage)

        self.houseXp.text:SetText(barText)

        -- Handle reward alerts
        if percentage >= 100 then
            if not self.houseRewardText then
                self.houseRewardText = self.textHolder:CreateFontString(nil, "OVERLAY")
            end
            self.houseRewardText:SetFont(self.fontToUse, profile.paragonTextSize or 18, "THICKOUTLINE")
            
            local rColor = profile.houseRewardTextColor or color
            local hex = string.format("|cff%02x%02x%02x", 
                math.floor(rColor.r * 255), 
                math.floor(rColor.g * 255), 
                math.floor(rColor.b * 255))
                
            local upgradeText = Locales["HOUSING_UPGRADE_READY"] or "HOUSE UPGRADE READY"
            self.houseRewardText:SetText(hex .. upgradeText .. " IN " .. addressString:upper() .. "|r")
            self.houseRewardText:Show()
            
            local offset = profile.houseRewardTextYOffset or -60
            self.houseRewardText:ClearAllPoints()
            
            if profile.paragonOnTop then
                self.houseRewardText:SetPoint("TOP", UIParent, "TOP", 0, offset)
            else
                local anchor = profile.barAnchor == "BOTTOM" and "TOP" or "BOTTOM"
                local sign = profile.barAnchor == "BOTTOM" and 1 or -1
                self.houseRewardText:SetPoint(anchor, self.textHolder, profile.barAnchor, 0, (offset * sign))
            end
        elseif self.houseRewardText then
            self.houseRewardText:Hide()
        end
    else
        self.houseXp.bar:Hide()
        self.houseXp.txFrame:Hide()
        if self.houseRewardText then self.houseRewardText:Hide() end
    end

    if profile.textColor then
        local tC = profile.textColor
        self.houseXp.text:SetTextColor(tC.r or 1, tC.g or 1, tC.b or 1, tC.a or 1) -- #FFFFFF
    end
end

--- Shows dummy data for the housing bar in config mode
function ascensionBars:configHouseXp(profile, bars, textColor)
    if self.houseXp and bars["HouseXp"] and bars["HouseXp"].enabled then
        self.houseXp.bar:Show()
        self.houseXp.txFrame:Show()
        self:setupBar(self.houseXp, 0, 1000, 600, profile.houseXpColor)
        
        local example = "Stormwind Level 3 | 600 / 1,000 (60.0%)"
        self.houseXp.text:SetText(example)
        self.houseXp.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1) -- #FFFFFF
    end
end