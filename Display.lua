-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Display.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

---@type AscensionBars
local AB = LibStub("AceAddon-3.0"):GetAddon("AscensionBars")
local L = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local lastUpdate = 0

-------------------------------------------------------------------------------
-- Text Styles & Positioning
-------------------------------------------------------------------------------
function AB:ApplyTextStyles()
    local profile = self.db.profile
    local font = profile.fontPath or [[Fonts\FRIZQT__.TTF]]
    local size = profile.textSize or 14
    local barList = { self.XP, self.Rep, self.Honor, self.HouseXp, self.Azerite }
    for _, obj in ipairs(barList) do
        if obj and obj.text then
            obj.text:SetFont(font, size, "OUTLINE")
            local tc = profile.textColor
            if tc then
                obj.text:SetTextColor(tc.r, tc.g, tc.b, tc.a or 1)
            end
        end
    end
end

function AB:UpdateTextAnchors(_, _)
    local profile = self.db.profile
    local barList = {
        { obj = self.XP,      key = "XP" },
        { obj = self.Rep,     key = "Rep" },
        { obj = self.Honor,   key = "Honor" },
        { obj = self.HouseXp, key = "HouseXp" },
        { obj = self.Azerite, key = "Azerite" }
    }

    local groups = { T1 = {}, T2 = {}, T3 = {} }
    for _, entry in ipairs(barList) do
        local config = profile.bars[entry.key]
        if config and config.enabled then
            local blockKey = config.textBlock or "T1"
            table.insert(groups[blockKey], entry)
        end
    end

    self.textHolder:Show() -- Backward compatibility or main holder

    for gKey, activeFrames in pairs(groups) do
        table.sort(activeFrames, function(a, b)
            return (profile.bars[a.key].textOrder or 0) < (profile.bars[b.key].textOrder or 0)
        end)

        if #activeFrames > 0 then
            local gap = AB.constants.DEFAULT_GAP
            local totalWidth = 0
            for _, data in ipairs(activeFrames) do
                local w = math.max(data.obj.text:GetStringWidth() + 5, AB.constants.MIN_TEXT_WIDTH)
                data.width = w
                totalWidth = totalWidth + w
            end
            totalWidth = totalWidth + (gap * (#activeFrames - 1))

            local container = self.textHolders[gKey]
            if container then
                container:Show()
                container:SetWidth(totalWidth)
                local gSet = profile.textGroups[gKey] or { detached = true, x = 0, y = 0 }

                if gSet.detached then
                    container:ClearAllPoints()
                    container:SetPoint("TOP", UIParent, "TOP", gSet.x, gSet.y)
                elseif gKey == "T1" and profile.textFollowBar then
                    local lowestBar
                    local lowestY = 9999
                    for _, b in ipairs({ self.XP, self.Rep, self.Honor, self.HouseXp, self.Azerite }) do
                        if b and b.bar and b.bar:IsShown() then
                            local _, _, _, _, yValue = b.bar:GetPoint()
                            if yValue and yValue < lowestY then
                                lowestY = yValue; lowestBar = b.bar
                            end
                        end
                    end
                    if lowestBar then
                        container:ClearAllPoints()
                        container:SetPoint("TOP", lowestBar, "BOTTOM", 0, -5)
                    end
                else
                    -- For T2/T3 if not detached, default to follow T1 or just stay at center
                    container:ClearAllPoints()
                    container:SetPoint("TOP", UIParent, "TOP", gSet.x, gSet.y)
                end

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
            if self.textHolders[gKey] then self.textHolders[gKey]:Hide() end
        end
    end
end

function AB:UpdateDisplay(force)
    local CONSTANTS = AB.constants
    local now = GetTime()
    local isForce = (force == true) or self.state.isConfigMode
    if not isForce and (now - lastUpdate < CONSTANTS.UPDATE_THROTTLE) then
        if not self.state.updatePending then
            self.state.updatePending = true
            C_Timer.After(CONSTANTS.UPDATE_THROTTLE, function()
                self.state.updatePending = false
                self:UpdateDisplay(true)
            end)
        end
        return
    end
    lastUpdate = now
    local profile = self.db.profile
    self:ApplyTextStyles()
    local maxLevel = self:GetPlayerMaxLevel()
    local isMaxLevel = UnitLevel("player") >= maxLevel
    local shouldHideXP = isMaxLevel and profile.hideAtMaxLevel
    self:UpdateLayout(shouldHideXP)
    self:UpdateVisibility()
    if self.state.isConfigMode then
        self:RenderConfig()
        return
    end
    if profile.bars["XP"].enabled and not shouldHideXP then
        local cur, mx = UnitXP("player"), UnitXPMax("player")
        local xc = profile.useClassColorXP and self:GetClassColor() or profile.xpBarColor
        if not xc then xc = profile.xpBarColor or { r = 0, g = 0.4, b = 1 } end
        if xc then
            self.XP.bar:SetStatusBarColor(xc.r or 0, xc.g or 0.4, xc.b or 1, 1.0)
        end
        self.XP.bar:SetMinMaxValues(0, mx)
        self.XP.bar:SetValue(cur)
        if profile.sparkEnabled then
            local pct = (mx > 0) and (cur / mx) or 0
            self.XP.spark:SetPoint("CENTER", self.XP.bar, "LEFT", self.XP.bar:GetWidth() * pct, 0)
            self.XP.spark:Show()
        else
            self.XP.spark:Hide()
        end
        if profile.showRestedBar then
            local rested = GetXPExhaustion()
            if rested and rested > 0 then
                local rw = self.XP.bar:GetWidth() * (math.min(cur + rested, mx) / mx)
                self.XP.restedOverlay:SetSize(rw, profile.bars["XP"].freeHeight or 6)
                self.XP.restedOverlay:SetPoint("LEFT", self.XP.bar, "LEFT")
                self.XP.restedOverlay:SetColorTexture(
                    profile.restedBarColor.r,
                    profile.restedBarColor.g,
                    profile.restedBarColor.b,
                    profile.restedBarColor.a
                )
                self.XP.restedOverlay:Show()
            else
                if self.XP.restedOverlay then self.XP.restedOverlay:Hide() end
            end
        else
            if self.XP.restedOverlay then self.XP.restedOverlay:Hide() end
        end
        self.XP.text:SetText(self:FormatXP())
        self.XP.txFrame:Show()
    end
    local name = self:RenderReputation()
    self:RenderOptionalBars()
    self:UpdateTextAnchors(name, shouldHideXP)
end

function AB:RenderReputation()
    local profile = self.db.profile
    if not profile.bars["Rep"].enabled then
        self.Rep.bar:Hide()
        self.Rep.txFrame:Hide()
        return nil
    end
    local name, reaction, min, max, value, factionID, standingLabel
    local p = self.state.cachedPendingParagons
    if p and #p > 0 then
        local pc = profile.paragonPendingColor
        local hex = string.format("|cff%02x%02x%02x",
            math.floor((pc.r or 0) * 255),
            math.floor((pc.g or 1) * 255),
            math.floor((pc.b or 0) * 255)
        )
        local text = ""
        if profile.splitParagonText then
            local lines = {}
            for _, info in ipairs(p) do
                table.insert(lines, hex .. string.upper(info.name) .. L["REWARD_PENDING_SINGLE"] .. "|r")
            end
            text = table.concat(lines, "\n")
        else
            local names = {}
            for _, info in ipairs(p) do
                table.insert(names, string.upper(info.name))
            end
            local factionStr = ""
            if #names == 1 then
                factionStr = names[1]
            elseif #names == 2 then
                factionStr = names[1] .. L["AND"] .. names[2]
            else
                local last = table.remove(names)
                factionStr = table.concat(names, ", ") .. L["AND"] .. last
            end
            text = hex .. factionStr .. (#p > 1 and L["REWARD_PENDING_PLURAL"] or L["REWARD_PENDING_SINGLE"]) .. "|r"
        end
        self.paragonText:SetFont(self.fontToUse, profile.paragonTextSize or 18, "OUTLINE, THICK")
        self.paragonText:SetText(text)
        self.paragonText:Show()
        self.paragonText:ClearAllPoints()
        if profile.paragonOnTop then
            self.paragonText:SetPoint("TOP", UIParent, "TOP", 0, profile.paragonTextYOffset)
        else
            if profile.barAnchor == "BOTTOM" then
                self.paragonText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, -profile.paragonTextYOffset)
            else
                self.paragonText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, profile.paragonTextYOffset)
            end
        end
        name, reaction, min, max, value, standingLabel = p[1].name, 9, 0, 1, 1, L["REWARD_PENDING_STATUS"]
    else
        self.paragonText:Hide()
        local data = C_Reputation.GetWatchedFactionData()
        if data then
            name, reaction, factionID = data.name, data.reaction, data.factionID
            min, max, value = data.currentReactionThreshold, data.nextReactionThreshold, data.currentStanding
            if C_Reputation.IsFactionParagon(factionID) then
                local cv, th = C_Reputation.GetFactionParagonInfo(factionID)
                min, max, value, standingLabel, reaction = 0, th, cv % th, L["PARAGON"], 9
            elseif C_Reputation.IsMajorFaction(factionID) then
                local majorFactionData = C_MajorFactions.GetMajorFactionData(factionID)
                if majorFactionData then
                    min, max, value, standingLabel, reaction = 0, majorFactionData.renownLevelThreshold,
                        majorFactionData.renownReputationEarned,
                        string.format(L["RENOWN_LEVEL"], majorFactionData.renownLevel), 11
                else
                    standingLabel = _G["FACTION_STANDING_LABEL" .. reaction] or L["UNKNOWN_STANDING"]
                end
            else
                standingLabel = _G["FACTION_STANDING_LABEL" .. reaction] or L["UNKNOWN_STANDING"]
            end
        end
    end
    if name then
        self.Rep.bar:Show()
        self.Rep.txFrame:Show()
        local color = profile.useReactionColorRep and profile.repColors[reaction] or profile.repBarColor
        if not color then color = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 } end -- #00FF00
        self.Rep.bar:SetStatusBarColor(color.r, color.g, color.b, color.a or 1.0)
        self.Rep.bar:SetMinMaxValues(min, max)
        self.Rep.bar:SetValue(value)
        if profile.sparkEnabled then
            local pct = (max - min > 0) and (value - min) / (max - min) or 0
            self.Rep.spark:SetPoint("CENTER", self.Rep.bar, "LEFT", self.Rep.bar:GetWidth() * pct, 0)
            self.Rep.spark:Show()
        else
            self.Rep.spark:Hide()
        end
        local pct = (max - min > 0) and ((value - min) / (max - min) * 100) or 0
        local valueStr = BreakUpLargeNumbers(value - min)
        local maxStr = BreakUpLargeNumbers(max - min)
        if profile.showAbsoluteValues and profile.showPercentage then
            self.Rep.text:SetText(string.format("%s (%s) %s/%s (%.1f%%)",
                name, standingLabel, valueStr, maxStr, pct))
        elseif profile.showAbsoluteValues then
            self.Rep.text:SetText(string.format("%s (%s) %s/%s",
                name, standingLabel, valueStr, maxStr))
        elseif profile.showPercentage then
            self.Rep.text:SetText(string.format("%s (%s) %.1f%%",
                name, standingLabel, pct))
        else
            self.Rep.text:SetText(string.format("%s (%s)", name, standingLabel))
        end
    else
        self.Rep.bar:Hide()
        self.Rep.txFrame:Hide()
    end
    return name
end

function AB:RenderOptionalBars()
    local profile = self.db.profile
    local tc = profile.textColor
    if self.Honor and profile.bars["Honor"].enabled then
        self.Honor.bar:Show()
        self.Honor.txFrame:Show()
        local currentHonor = UnitHonor("player") or 0
        local maxHonor = UnitHonorMax("player") or 100
        if maxHonor == 0 then maxHonor = 1 end
        local honorColor = profile.honorColor
        if not honorColor then honorColor = { r = 0.8, g = 0.2, b = 0.2, a = 1.0 } end -- #CC3333
        self.Honor.bar:SetStatusBarColor(honorColor.r, honorColor.g, honorColor.b, honorColor.a)
        self.Honor.bar:SetMinMaxValues(0, maxHonor)
        self.Honor.bar:SetValue(currentHonor)
        if profile.sparkEnabled then
            local pct = (maxHonor > 0) and (currentHonor / maxHonor) or 0
            self.Honor.spark:SetPoint("CENTER", self.Honor.bar, "LEFT", self.Honor.bar:GetWidth() * pct, 0)
            self.Honor.spark:Show()
        else
            self.Honor.spark:Hide()
        end
        local percentage = (currentHonor / maxHonor) * 100
        self.Honor.text:SetText(string.format("Honor %d/%d (%.1f%%)", currentHonor, maxHonor, percentage))
        if tc then self.Honor.text:SetTextColor(tc.r, tc.g, tc.b, tc.a or 1) end
    elseif self.Honor then
        self.Honor.bar:Hide()
        self.Honor.txFrame:Hide()
    end
    if self.HouseXp and profile.bars["HouseXp"].enabled then
        self.HouseXp.bar:Show()
        self.HouseXp.txFrame:Show()
        local houseXpColor = profile.houseXpColor
        if not houseXpColor then houseXpColor = { r = 0.9, g = 0.5, b = 0.0, a = 1.0 } end -- #E68000
        local currentFavor = 0
        local minFavorBar = 0
        local maxFavorBar = 1
        local currentLevel = 1
        local houseName = "House Favor"
        local isMonitoringHouse = false
        local currentHouseAddress = ""
        local trackedGuid = nil
        if C_Housing and C_Housing.GetTrackedHouseGuid then
            trackedGuid = C_Housing.GetTrackedHouseGuid()
        end
        if trackedGuid and trackedGuid ~= 0 and trackedGuid ~= "0" and trackedGuid ~= "" and self.state and self.state.houseLevelFavor then
            local data = self.state.houseLevelFavor
            if data.houseGUID == trackedGuid then
                isMonitoringHouse = true
                currentFavor = data.houseFavor or 0
                currentLevel = data.houseLevel or 1
                local houseAddress = "House Favor"
                local guidStr = tostring(trackedGuid)
                self.state.houseNamesCache = self.state.houseNamesCache or {}
                if data.houseName or data.neighborhoodName then
                    houseAddress = data.houseName or data.neighborhoodName
                    self.state.houseNamesCache[guidStr] = houseAddress
                end
                if houseAddress == "House Favor" and self.state.houseNamesCache[guidStr] then
                    houseAddress = self.state.houseNamesCache[guidStr]
                end
                if houseAddress == "House Favor" and C_Housing and C_Housing.GetCurrentHouseInfo then
                    local currentInfo = C_Housing.GetCurrentHouseInfo()
                    if type(currentInfo) == "table" then
                        if currentInfo.houseGUID or currentInfo.neighborhoodGUID then
                            local cGuid = currentInfo.houseGUID or currentInfo.neighborhoodGUID
                            if cGuid and tostring(cGuid) == guidStr then
                                houseAddress = currentInfo.houseName or currentInfo.neighborhoodName or houseAddress
                                self.state.houseNamesCache[guidStr] = houseAddress
                            end
                        else
                            for _, info in pairs(currentInfo) do
                                if type(info) == "table" then
                                    local cGuid = info.houseGUID or info.neighborhoodGUID
                                    if cGuid and tostring(cGuid) == guidStr then
                                        houseAddress = info.houseName or info.neighborhoodName or houseAddress
                                        self.state.houseNamesCache[guidStr] = houseAddress
                                    end
                                end
                            end
                        end
                    end
                end
                if houseAddress == "House Favor" and C_Housing then
                    local function scanHouseList(list)
                        if type(list) == "table" then
                            for _, info in pairs(list) do
                                if type(info) == "table" then
                                    local cGuid = info.houseGUID or info.neighborhoodGUID
                                    if cGuid and tostring(cGuid) == guidStr then
                                        local found = info.houseName or info.neighborhoodName
                                        if found then
                                            self.state.houseNamesCache[guidStr] = found
                                            return found
                                        end
                                    end
                                end
                            end
                        end
                        return nil
                    end
                    if C_Housing.GetPlayerOwnedHouses then
                        houseAddress = scanHouseList(C_Housing.GetPlayerOwnedHouses()) or houseAddress
                    end
                end
                if houseAddress == "House Favor" then
                    local dashboard = _G["HousingDashboardFrame"]
                    if dashboard and dashboard.HouseInfoContent and dashboard.HouseInfoContent.ContentFrame and dashboard.HouseInfoContent.ContentFrame.HouseUpgradeFrame and dashboard.HouseInfoContent.ContentFrame.HouseUpgradeFrame.AddressText then
                        local uiText = dashboard.HouseInfoContent.ContentFrame.HouseUpgradeFrame.AddressText:GetText()
                        if uiText and uiText ~= "" then
                            houseAddress = uiText
                            self.state.houseNamesCache[guidStr] = houseAddress
                        end
                    end
                end
                currentHouseAddress = houseAddress
                houseName = string.format("%s - Level %d", houseAddress, currentLevel)
                if C_Housing and C_Housing.GetHouseLevelFavorForLevel then
                    minFavorBar = C_Housing.GetHouseLevelFavorForLevel(currentLevel) or 0
                    maxFavorBar = C_Housing.GetHouseLevelFavorForLevel(currentLevel + 1) or 1
                end
            end
        end
        if maxFavorBar <= minFavorBar then maxFavorBar = minFavorBar + 1 end
        self.HouseXp.bar:SetStatusBarColor(houseXpColor.r, houseXpColor.g, houseXpColor.b, houseXpColor.a)
        self.HouseXp.bar:SetMinMaxValues(minFavorBar, maxFavorBar)
        self.HouseXp.bar:SetValue(currentFavor)
        if profile.sparkEnabled then
            local range = maxFavorBar - minFavorBar
            local pct = (range > 0) and ((currentFavor - minFavorBar) / range) or 0
            self.HouseXp.spark:SetPoint("CENTER", self.HouseXp.bar, "LEFT", self.HouseXp.bar:GetWidth() * pct, 0)
            self.HouseXp.spark:Show()
        else
            self.HouseXp.spark:Hide()
        end
        if isMonitoringHouse then
            local currentProgress = currentFavor - minFavorBar
            local maxProgress = maxFavorBar - minFavorBar
            if maxProgress <= 0 then maxProgress = 1 end
            local percentage = (currentProgress / maxProgress) * 100
            if percentage >= 100 then
                self.HouseXp.text:SetText(houseName)
                if not self.houseRewardText then
                    self.houseRewardText = self.textHolder:CreateFontString(nil, "OVERLAY")
                end
                self.houseRewardText:SetFont(self.fontToUse, profile.paragonTextSize or 18, "OUTLINE, THICK")
                local rewardColor = profile.houseRewardTextColor or houseXpColor
                local hex = string.format("|cff%02x%02x%02x",
                    math.floor((rewardColor.r or 0.9) * 255), math.floor((rewardColor.g or 0.5) * 255),
                    math.floor((rewardColor.b or 0.0) * 255)) -- #E68000
                self.houseRewardText:SetText(hex .. "House Upgrades available for house " .. currentHouseAddress .. "|r")
                self.houseRewardText:Show()
                self.houseRewardText:ClearAllPoints()
                local offset = profile.houseRewardTextYOffset or profile.paragonTextYOffset or -40
                if profile.paragonOnTop then
                    self.houseRewardText:SetPoint("TOP", UIParent, "TOP", 0, offset - 20)
                else
                    if profile.barAnchor == "BOTTOM" then
                        self.houseRewardText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, -offset + 20)
                    else
                        self.houseRewardText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, offset - 20)
                    end
                end
            else
                local valueStr = BreakUpLargeNumbers(currentProgress)
                local maxStr = BreakUpLargeNumbers(maxProgress)
                if profile.showAbsoluteValues and profile.showPercentage then
                    self.HouseXp.text:SetText(string.format("%s %s/%s (%.1f%%)", houseName, valueStr, maxStr, percentage))
                elseif profile.showAbsoluteValues then
                    self.HouseXp.text:SetText(string.format("%s %s/%s", houseName, valueStr, maxStr))
                elseif profile.showPercentage then
                    self.HouseXp.text:SetText(string.format("%s %.1f%%", houseName, percentage))
                else
                    self.HouseXp.text:SetText(houseName)
                end
                if self.houseRewardText then self.houseRewardText:Hide() end
            end
        else
            self.HouseXp.bar:SetMinMaxValues(0, 1)
            self.HouseXp.bar:SetValue(0)
            self.HouseXp.text:SetText("No House Watched")
            if self.houseRewardText then self.houseRewardText:Hide() end
        end
        if tc then self.HouseXp.text:SetTextColor(tc.r, tc.g, tc.b, tc.a or 1) end
    elseif self.HouseXp then
        self.HouseXp.bar:Hide()
        self.HouseXp.txFrame:Hide()
        if self.houseRewardText then self.houseRewardText:Hide() end
    end
    if self.Azerite and profile.bars["Azerite"].enabled then
        self.Azerite.bar:Show()
        self.Azerite.txFrame:Show()
        local azeriteColor = profile.azeriteColor
        if not azeriteColor then azeriteColor = { r = 0.9, g = 0.8, b = 0.5, a = 1.0 } end -- #E6CC80
        local currentazerite = 0
        local maxazerite = 100
        if C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem then
            local activeAzeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
            if activeAzeriteItemLocation then
                local xp, totalLevelXP = C_AzeriteItem.GetAzeriteItemXPInfo(activeAzeriteItemLocation)
                if xp and totalLevelXP then
                    currentazerite = xp
                    maxazerite = totalLevelXP
                end
            end
        end
        if maxazerite == 0 then maxazerite = 1 end
        self.Azerite.bar:SetStatusBarColor(azeriteColor.r, azeriteColor.g, azeriteColor.b, azeriteColor.a)
        self.Azerite.bar:SetMinMaxValues(0, maxazerite)
        self.Azerite.bar:SetValue(currentazerite)
        if profile.sparkEnabled then
            local pct = (maxazerite > 0) and (currentazerite / maxazerite) or 0
            self.Azerite.spark:SetPoint("CENTER", self.Azerite.bar, "LEFT", self.Azerite.bar:GetWidth() * pct, 0)
            self.Azerite.spark:Show()
        else
            self.Azerite.spark:Hide()
        end
        local percentage = (currentazerite / maxazerite) * 100
        self.Azerite.text:SetText(string.format("Azerite Power %d/%d (%.1f%%)", currentazerite, maxazerite, percentage))
        if tc then self.Azerite.text:SetTextColor(tc.r, tc.g, tc.b, tc.a or 1) end
    elseif self.Azerite then
        self.Azerite.bar:Hide()
        self.Azerite.txFrame:Hide()
    end
end

function AB:RenderConfig()
    self.textHolder:Show()
    self.textHolder:SetAlpha(1)
    self.textHolder:SetFrameStrata("HIGH")
    local profile = self.db.profile
    local tc = profile.textColor
    if not tc then tc = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 } end -- #FFFFFF
    self.XP.bar:Show()
    self.XP.txFrame:Show()
    local xc = profile.useClassColorXP and self:GetClassColor() or profile.xpBarColor
    if not xc then xc = { r = 0.0, g = 0.4, b = 1.0, a = 1.0 } end -- #0066FF
    self.XP.bar:SetStatusBarColor(xc.r, xc.g, xc.b, 1)
    self.XP.bar:SetMinMaxValues(0, 100)
    self.XP.bar:SetValue(75)
    self.XP.text:SetText(L["XP_BAR_DATA"])
    self.XP.text:SetTextColor(tc.r, tc.g, tc.b, 1)
    if profile.showRestedBar then
        local w = self.XP.bar:GetWidth()
        if self.XP.restedOverlay then
            self.XP.restedOverlay:SetSize(w * 0.25, profile.bars["XP"].freeHeight or 6)
            self.XP.restedOverlay:ClearAllPoints()
            self.XP.restedOverlay:SetPoint("LEFT", self.XP.bar, "LEFT", w * 0.75, 0)
            self.XP.restedOverlay:SetColorTexture(
                profile.restedBarColor.r,
                profile.restedBarColor.g,
                profile.restedBarColor.b,
                profile.restedBarColor.a
            )
            self.XP.restedOverlay:Show()
        end
    else
        if self.XP.restedOverlay then self.XP.restedOverlay:Hide() end
    end
    self.Rep.bar:Show()
    self.Rep.txFrame:Show()
    local rc = profile.useReactionColorRep and profile.repColors[9] or profile.repBarColor
    if rc then
        self.Rep.bar:SetStatusBarColor(rc.r, rc.g, rc.b, 1)
    end
    self.Rep.bar:SetMinMaxValues(0, 100)
    self.Rep.bar:SetValue(50)
    self.Rep.text:SetText(L["REP_BAR_DATA"])
    self.Rep.text:SetTextColor(tc.r, tc.g, tc.b, 1)
    if self.Honor and profile.bars["Honor"].enabled then
        self.Honor.bar:Show()
        self.Honor.txFrame:Show()
        local honorColor = profile.honorColor
        if not honorColor then honorColor = { r = 0.8, g = 0.2, b = 0.2, a = 1.0 } end -- #CC3333
        self.Honor.bar:SetStatusBarColor(honorColor.r, honorColor.g, honorColor.b, honorColor.a)
        self.Honor.bar:SetMinMaxValues(0, 100)
        self.Honor.bar:SetValue(30)
        self.Honor.text:SetText(L["HONOR_BAR_DATA"])
        self.Honor.text:SetTextColor(tc.r, tc.g, tc.b, 1)
    elseif self.Honor then
        self.Honor.bar:Hide()
        self.Honor.txFrame:Hide()
    end
    if self.HouseXp and profile.bars["HouseXp"].enabled then
        self.HouseXp.bar:Show()
        self.HouseXp.txFrame:Show()
        local houseXpColor = profile.houseXpColor
        if not houseXpColor then houseXpColor = { r = 0.9, g = 0.5, b = 0.0, a = 1.0 } end -- #E68000
        self.HouseXp.bar:SetStatusBarColor(houseXpColor.r, houseXpColor.g, houseXpColor.b, houseXpColor.a)
        self.HouseXp.bar:SetMinMaxValues(0, 1000)
        self.HouseXp.bar:SetValue(600)
        local configText = L["HOUSE_XP_BAR_DATA"]
        if profile.showAbsoluteValues and profile.showPercentage then
            self.HouseXp.text:SetText(configText .. " | 600/1,000 (60.0%)")
        elseif profile.showAbsoluteValues then
            self.HouseXp.text:SetText(configText .. " | 600/1,000")
        elseif profile.showPercentage then
            self.HouseXp.text:SetText(configText .. " | 60.0%")
        else
            self.HouseXp.text:SetText(configText)
        end
        self.HouseXp.text:SetTextColor(tc.r, tc.g, tc.b, tc.a or 1)
        if not self.houseRewardText then
            self.houseRewardText = self.textHolder:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        end
        self.houseRewardText:SetFont(self.fontToUse, profile.paragonTextSize or 18, "OUTLINE, THICK")
        local rewardColor = profile.houseRewardTextColor or houseXpColor
        local hex = string.format("|cff%02x%02x%02x",
            math.floor((rewardColor.r or 0.9) * 255), math.floor((rewardColor.g or 0.5) * 255),
            math.floor((rewardColor.b or 0.0) * 255)) -- #E68000
        self.houseRewardText:SetText(hex .. "[CONFIG] HOUSE UPGRADE FOR ADDRESS|r")
        self.houseRewardText:Show()
        self.houseRewardText:ClearAllPoints()
        local offset = profile.houseRewardTextYOffset or profile.paragonTextYOffset or -40
        if profile.paragonOnTop then
            self.houseRewardText:SetPoint("TOP", UIParent, "TOP", 0, offset - 20)
        else
            if profile.barAnchor == "BOTTOM" then
                self.houseRewardText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, -offset + 20)
            else
                self.houseRewardText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, offset - 20)
            end
        end
    elseif self.HouseXp then
        self.HouseXp.bar:Hide()
        self.HouseXp.txFrame:Hide()
        if self.houseRewardText then self.houseRewardText:Hide() end
    end
    if self.Azerite and profile.bars["Azerite"].enabled then
        self.Azerite.bar:Show()
        self.Azerite.txFrame:Show()
        local azeriteColor = profile.azeriteColor
        if not azeriteColor then azeriteColor = { r = 0.9, g = 0.8, b = 0.5, a = 1.0 } end -- #E6CC80
        self.Azerite.bar:SetStatusBarColor(azeriteColor.r, azeriteColor.g, azeriteColor.b, azeriteColor.a)
        self.Azerite.bar:SetMinMaxValues(0, 100)
        self.Azerite.bar:SetValue(80)
        self.Azerite.text:SetText(L["AZERITE_BAR_DATA"])
        self.Azerite.text:SetTextColor(tc.r, tc.g, tc.b, 1)
    elseif self.Azerite then
        self.Azerite.bar:Hide()
        self.Azerite.txFrame:Hide()
    end
    local pc = profile.paragonPendingColor
    if pc then
        local hex = string.format("|cff%02x%02x%02x",
            math.floor((pc.r or 0) * 255),
            math.floor((pc.g or 1) * 255),
            math.floor((pc.b or 0) * 255)
        )
        self.paragonText:SetFont(self.fontToUse, profile.paragonTextSize or 18, "OUTLINE, THICK")
        if profile.splitParagonText then
            self.paragonText:SetText(hex ..
                (L["CONFIG_FACTION_A_REWARD"] or "Faction A") ..
                "|r\n" .. hex .. (L["CONFIG_FACTION_B_REWARD"] or "Faction B") .. "|r")
        else
            self.paragonText:SetText(hex .. (L["CONFIG_MULTIPLE_REWARDS"] or "Multiple Rewards Pending") .. "|r")
        end
    end
    self.paragonText:Show()
    self.paragonText:ClearAllPoints()
    if profile.paragonOnTop then
        self.paragonText:SetPoint("TOP", UIParent, "TOP", 0, profile.paragonTextYOffset)
    else
        if profile.barAnchor == "BOTTOM" then
            self.paragonText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, -profile.paragonTextYOffset)
        else
            self.paragonText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, profile.paragonTextYOffset)
        end
    end
    self:UpdateTextAnchors("Config", false)
end

function AB:UpdateLayout(shouldHideXP)
    local profile = self.db.profile
    local gap = profile.barGap or 1
    local blocks = { TOP = {}, BOTTOM = {}, FREE = {} }
    local barList = {
        { obj = self.XP,      key = "XP" },
        { obj = self.Rep,     key = "Rep" },
        { obj = self.Honor,   key = "Honor" },
        { obj = self.HouseXp, key = "HouseXp" },
        { obj = self.Azerite, key = "Azerite" }
    }
    for _, entry in ipairs(barList) do
        local config = profile.bars[entry.key]
        if config.enabled and not (entry.key == "XP" and shouldHideXP) then
            table.insert(blocks[config.block], entry)
            entry.obj.txFrame:Show()
        else
            entry.obj.bar:Hide()
            entry.obj.txFrame:Hide()
        end
    end
    local sortFn = function(a, b) return profile.bars[a.key].order < profile.bars[b.key].order end
    table.sort(blocks.TOP, sortFn)
    table.sort(blocks.BOTTOM, sortFn)
    for i, entry in ipairs(blocks.TOP) do
        local config = profile.bars[entry.key]
        entry.obj.bar:ClearAllPoints()
        entry.obj.bar:SetHeight(config.freeHeight or 6)
        if i == 1 then
            entry.obj.bar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, profile.yOffset)
            entry.obj.bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, profile.yOffset)
        else
            entry.obj.bar:SetPoint("TOPLEFT", blocks.TOP[i - 1].obj.bar, "BOTTOMLEFT", 0, -gap)
            entry.obj.bar:SetPoint("TOPRIGHT", blocks.TOP[i - 1].obj.bar, "BOTTOMRIGHT", 0, -gap)
        end
        entry.obj.bar:Show()
    end
    for i, entry in ipairs(blocks.BOTTOM) do
        local config = profile.bars[entry.key]
        entry.obj.bar:ClearAllPoints()
        entry.obj.bar:SetHeight(config.freeHeight or 6)
        if i == 1 then
            entry.obj.bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, math.abs(profile.yOffset))
            entry.obj.bar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, math.abs(profile.yOffset))
        else
            entry.obj.bar:SetPoint("BOTTOMLEFT", blocks.BOTTOM[i - 1].obj.bar, "TOPLEFT", 0, gap)
            entry.obj.bar:SetPoint("BOTTOMRIGHT", blocks.BOTTOM[i - 1].obj.bar, "TOPRIGHT", 0, gap)
        end
        entry.obj.bar:Show()
    end
    for _, entry in ipairs(blocks.FREE) do
        local config = profile.bars[entry.key]
        entry.obj.bar:ClearAllPoints()
        entry.obj.bar:SetSize(config.freeWidth, config.freeHeight)
        entry.obj.bar:SetPoint("CENTER", UIParent, "CENTER", config.freeX, config.freeY)
        entry.obj.bar:Show()
    end
end

function AB:UpdateVisibility()
    local alpha = 1
    if not self.state.isConfigMode then
        if self.db.profile.hideInCombat and self.state.inCombat then
            alpha = 0
        elseif self.db.profile.showOnMouseover and not self.state.isHovering then
            alpha = 0
        end
    end
    if self.XP and self.XP.bar then self.XP.bar:SetAlpha(alpha) end
    if self.Rep and self.Rep.bar then self.Rep.bar:SetAlpha(alpha) end
    if self.Honor and self.Honor.bar then self.Honor.bar:SetAlpha(alpha) end
    if self.HouseXp and self.HouseXp.bar then self.HouseXp.bar:SetAlpha(alpha) end
    if self.Azerite and self.Azerite.bar then self.Azerite.bar:SetAlpha(alpha) end
    if self.textHolder then self.textHolder:SetAlpha(alpha) end
end
