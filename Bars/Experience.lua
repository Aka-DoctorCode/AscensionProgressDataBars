-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Experience.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------
---
local addonName, addonTable = ...
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

function ascensionBars:renderExperience(shouldHideXP)
    local profile = self.db and self.db.profile
    if not profile then return end
    local bars = profile.bars

    if bars and bars["XP"] and bars["XP"].enabled and not shouldHideXP then
        local currentXP = UnitXP("player") or 0
        local maxXP = UnitXPMax("player") or 1
        local xpColor = profile.xpBarColor or { r = 0, g = 0.4, b = 0.9, a = 1 }
        local classColor = profile.useClassColorXP and self:getClassColor() or xpColor
        local xpObj = self.xp

        if xpObj then
            self:setupBar(xpObj, 0, maxXP, currentXP, classColor)

            if profile.showRestedBar then
                local rested = GetXPExhaustion()
                local overlay = xpObj.restedOverlay
                local bar = xpObj.bar
                if rested and rested > 0 and overlay and bar then
                    local rw = bar:GetWidth() * (math.min(currentXP + rested, maxXP) / maxXP)
                    overlay:SetSize(rw, bar:GetHeight())
                    overlay:SetPoint("LEFT", bar, "LEFT")
                    local rBarColor = profile.restedBarColor
                    if rBarColor then
                        overlay:SetColorTexture(rBarColor.r or 0.6, rBarColor.g or 0.4, rBarColor.b or 0.8,
                            rBarColor.a or 1)
                    end
                    overlay:Show()
                elseif overlay then
                    overlay:Hide()
                end
            elseif xpObj.restedOverlay then
                xpObj.restedOverlay:Hide()
            end

            local xpText = self:formatXP()
            if xpObj.text then
                xpObj.text:SetText(xpText or "")
            end
            if xpObj.txFrame then
                xpObj.txFrame:Show()
            end
        end
    elseif self.xp then
        if self.xp.bar then self.xp.bar:Hide() end
        if self.xp.txFrame then self.xp.txFrame:Hide() end
    end
end

function ascensionBars:configExperience(profile, bars, textColor)
    local xpObj = self.xp
    if xpObj then
        if xpObj.bar then xpObj.bar:Show() end
        if xpObj.txFrame then xpObj.txFrame:Show() end
        local xpConfig = bars["XP"]
        local xpColor = profile.xpBarColor or { r = 0, g = 0.4, b = 0.9, a = 1 }
        local classColor = xpConfig and profile.useClassColorXP and self:getClassColor() or xpColor
        self:setupBar(xpObj, 0, 100, 75, classColor)

        if xpObj.text then
            xpObj.text:SetText(Locales["XP_BAR_DATA"])
            xpObj.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)
        end

        if profile.showRestedBar then
            local bar = xpObj.bar
            local overlay = xpObj.restedOverlay
            if bar and overlay then
                local barWidth = bar:GetWidth() or 0
                overlay:SetSize(barWidth * 0.25, bar:GetHeight() or 6)
                overlay:ClearAllPoints()
                overlay:SetPoint("LEFT", bar, "LEFT", barWidth * 0.75, 0)
                local rBarColor = profile.restedBarColor
                if rBarColor then
                    overlay:SetColorTexture(
                        rBarColor.r or 0.6,
                        rBarColor.g or 0.4,
                        rBarColor.b or 0.8,
                        rBarColor.a or 1
                    )
                end
                overlay:Show()
            end
        elseif xpObj.restedOverlay then
            xpObj.restedOverlay:Hide()
        end
    end
end
