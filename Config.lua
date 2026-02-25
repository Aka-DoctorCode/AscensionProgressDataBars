-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Config.lua
-- Version: 29
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

function AB:GetOptionsTable()
    local CONSTANTS = AB.constants
    local options = {
        name = "Ascension Bars",
        type = "group",
        childGroups = "tab",
        args = {
            configMode = {
                name = L["CONFIG_MODE"],
                desc = L["CONFIG_MODE_DESC"],
                type = "toggle",
                order = 0,
                get = function() return self.state.isConfigMode end,
                set = function(_, val)
                    self.state.isConfigMode = val
                    self:UpdateDisplay()
                end,
            },
            general = {
                name = L["APPEARANCE"],
                type = "group",
                order = 10,
                args = {
                    headerPos = { type = "header", name = L["POSITION_SIZE"], order = 1 },
                    barAnchor = {
                        name = L["BAR_ANCHOR"],
                        desc = L["ANCHOR_DESC"],
                        type = "select",
                        order = 1.5,
                        values = {
                            ["TOP"] = L["ANCHOR_TOP"],
                            ["BOTTOM"] = L["ANCHOR_BOTTOM"],
                        },
                        get = function() return self.db.profile.barAnchor end,
                        set = function(_, v)
                            self.db.profile.barAnchor = v
                            self:UpdateDisplay()
                        end,
                    },
                    barGap = {
                        name = L["BAR_GAP"],
                        desc = L["BAR_GAP_DESC"],
                        type = "range",
                        min = 0,
                        max = 50,
                        step = 1,
                        order = 1.6,
                        get = function() return self.db.profile.barGap end,
                        set = function(_, v)
                            self.db.profile.barGap = v
                            self:UpdateDisplay()
                        end,
                    },
                    yOffset = {
                        name = L["VERTICAL_POSITION"],
                        type = "range",
                        min = -1080,
                        max = 1080,
                        step = 1,
                        bigStep = 10,
                        order = 2,
                        get = function() return self.db.profile.yOffset end,
                        set = function(_, v)
                            self.db.profile.yOffset = v
                            self:UpdateDisplay()
                        end,
                    },
                    textGap = {
                        name = L["TEXT_GAP"],
                        type = "range",
                        min = -50,
                        max = 100,
                        step = 0.5,
                        order = 2.5,
                        get = function() return self.db.profile.textGap end,
                        set = function(_, v)
                            self.db.profile.textGap = v
                            self:UpdateDisplay()
                        end,
                    },
                    barHeightXP = {
                        name = L["XP_BAR_HEIGHT"],
                        type = "range",
                        min = CONSTANTS.MIN_BAR_HEIGHT,
                        max = CONSTANTS.MAX_BAR_HEIGHT,
                        step = 1,
                        order = 3,
                        get = function() return self.db.profile.barHeightXP end,
                        set = function(_, v)
                            self.db.profile.barHeightXP = v
                            self:UpdateDisplay()
                        end,
                    },
                    barHeightRep = {
                        name = L["REP_BAR_HEIGHT"],
                        type = "range",
                        min = CONSTANTS.MIN_BAR_HEIGHT,
                        max = CONSTANTS.MAX_BAR_HEIGHT,
                        step = 1,
                        order = 4,
                        get = function() return self.db.profile.barHeightRep end,
                        set = function(_, v)
                            self.db.profile.barHeightRep = v
                            self:UpdateDisplay()
                        end,
                    },
                    barHeightHouse = {
                        name = L["HOUSE_BAR_HEIGHT"],
                        type = "range",
                        min = CONSTANTS.MIN_BAR_HEIGHT,
                        max = CONSTANTS.MAX_BAR_HEIGHT,
                        step = 1,
                        order = 4.5,
                        get = function() return self.db.profile.barHeightHouse or self.db.profile.barHeightXP end,
                        set = function(_, v)
                            self.db.profile.barHeightHouse = v
                            self:UpdateDisplay()
                        end,
                    },
                    barHeightHonor = {
                        name = L["HONOR_BAR_HEIGHT"],
                        type = "range",
                        min = CONSTANTS.MIN_BAR_HEIGHT,
                        max = CONSTANTS.MAX_BAR_HEIGHT,
                        step = 1,
                        order = 4.6,
                        get = function() return self.db.profile.barHeightHonor or self.db.profile.barHeightXP end,
                        set = function(_, v)
                            self.db.profile.barHeightHonor = v
                            self:UpdateDisplay()
                        end,
                    },
                    barHeightAzerite = {
                        name = L["AZERITE_BAR_HEIGHT"],
                        type = "range",
                        min = CONSTANTS.MIN_BAR_HEIGHT,
                        max = CONSTANTS.MAX_BAR_HEIGHT,
                        step = 1,
                        order = 4.7,
                        get = function() return self.db.profile.barHeightAzerite or self.db.profile.barHeightXP end,
                        set = function(_, v)
                            self.db.profile.barHeightAzerite = v
                            self:UpdateDisplay()
                        end,
                    },
                    textSize = {
                        name = L["FONT_SIZE"],
                        type = "range",
                        min = CONSTANTS.MIN_TEXT_SIZE,
                        max = CONSTANTS.MAX_TEXT_SIZE,
                        step = 1,
                        order = 5,
                        get = function() return self.db.profile.textSize end,
                        set = function(_, v)
                            self.db.profile.textSize = v
                            self:UpdateDisplay()
                        end,
                    },
                    globalColor = {
                        name = L["TEXT_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 6,
                        get = function()
                            local t = self.db.profile.textColor
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(_, r, g, b, a)
                            local t = self.db.profile.textColor
                            t.r, t.g, t.b, t.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                }
            },
            behavior = {
                name = L["VISIBILITY"],
                type = "group",
                order = 20,
                args = {
                    showOnMouseover = {
                        name = L["SHOW_ON_MOUSEOVER"],
                        type = "toggle",
                        order = 1,
                        get = function() return self.db.profile.showOnMouseover end,
                        set = function(_, v)
                            self.db.profile.showOnMouseover = v
                            self:UpdateDisplay()
                        end,
                    },
                    hideInCombat = {
                        name = L["HIDE_IN_COMBAT"],
                        type = "toggle",
                        order = 2,
                        get = function() return self.db.profile.hideInCombat end,
                        set = function(_, v)
                            self.db.profile.hideInCombat = v
                            self:UpdateDisplay()
                        end,
                    },
                    hideAtMaxLevel = {
                        name = L["HIDE_AT_MAX_LEVEL"],
                        type = "toggle",
                        order = 3,
                        get = function() return self.db.profile.hideAtMaxLevel end,
                        set = function(_, v)
                            self.db.profile.hideAtMaxLevel = v
                            self:UpdateDisplay()
                        end,
                    },
                    headerOptionalBars = { type = "header", name = L["OPTIONAL_BARS"], order = 4 },
                    honorBarEnabled = {
                        name = L["ENABLE_HONOR_BAR"],
                        type = "toggle",
                        order = 5,
                        get = function() return self.db.profile.honorBarEnabled end,
                        set = function(_, v)
                            self.db.profile.honorBarEnabled = v
                            self:UpdateDisplay()
                        end,
                    },
                    houseXpBarEnabled = {
                        name = L["ENABLE_HOUSE_XP_BAR"],
                        type = "toggle",
                        order = 6,
                        get = function() return self.db.profile.houseXpBarEnabled end,
                        set = function(_, v)
                            self.db.profile.houseXpBarEnabled = v
                            self:UpdateDisplay()
                        end,
                    },
                    azeriteBarEnabled = {
                        name = L["ENABLE_AZERITE_BAR"],
                        type = "toggle",
                        order = 7,
                        get = function() return self.db.profile.azeriteBarEnabled end,
                        set = function(_, v)
                            self.db.profile.azeriteBarEnabled = v
                            self:UpdateDisplay()
                        end,
                    },
                }
            },
            colors = {
                name = L["COLORS"],
                type = "group",
                order = 30,
                args = {
                    headerXP = { type = "header", name = L["EXPERIENCE"], order = 1 },
                    useClassColorXP = {
                        name = L["USE_CLASS_COLOR"],
                        type = "toggle",
                        order = 2,
                        width = "full",
                        get = function() return self.db.profile.useClassColorXP end,
                        set = function(_, v)
                            self.db.profile.useClassColorXP = v
                            self:UpdateDisplay()
                        end,
                    },
                    xpBarColor = {
                        name = L["CUSTOM_XP_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 3,
                        disabled = function() return self.db.profile.useClassColorXP end,
                        get = function()
                            local c = self.db.profile.xpBarColor
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            local c = self.db.profile.xpBarColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                    showRestedBar = {
                        name = L["SHOW_RESTED_BAR"],
                        type = "toggle",
                        order = 4,
                        get = function() return self.db.profile.showRestedBar end,
                        set = function(_, v)
                            self.db.profile.showRestedBar = v
                            self:UpdateDisplay()
                        end,
                    },
                    restedBarColor = {
                        name = L["RESTED_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 5,
                        disabled = function() return not self.db.profile.showRestedBar end,
                        get = function()
                            local c = self.db.profile.restedBarColor
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            local c = self.db.profile.restedBarColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                    headerRep = { type = "header", name = L["REPUTATION"], order = 10 },
                    useReactionColorRep = {
                        name = L["USE_REACTION_COLORS"],
                        type = "toggle",
                        order = 11,
                        width = "full",
                        get = function() return self.db.profile.useReactionColorRep end,
                        set = function(_, v)
                            self.db.profile.useReactionColorRep = v
                            self:UpdateDisplay()
                        end,
                    },
                    repBarColor = {
                        name = L["CUSTOM_REP_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 12,
                        disabled = function() return self.db.profile.useReactionColorRep end,
                        get = function()
                            local c = self.db.profile.repBarColor
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            local c = self.db.profile.repBarColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                    headerHonor = { type = "header", name = L["HONOR"], order = 13 },
                    honorColor = {
                        name = L["HONOR_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 14,
                        get = function()
                            local c = self.db.profile.honorColor
                            if not c then return 0.8, 0.2, 0.2, 1.0 end -- #CC3333
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            if not self.db.profile.honorColor then
                                self.db.profile.honorColor = {}
                            end
                            local c = self.db.profile.honorColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                    headerHouseFavor = { type = "header", name = L["HOUSE_XP"], order = 15 },
                    houseXpColor = {
                        name = L["HOUSE_XP_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 16,
                        get = function()
                            local c = self.db.profile.houseXpColor
                            if not c then return 0.9, 0.5, 0.0, 1.0 end -- #E68000
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            if not self.db.profile.houseXpColor then
                                self.db.profile.houseXpColor = {}
                            end
                            local c = self.db.profile.houseXpColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                    houseRewardTextColor = {
                        name = L["HOUSE_REWARD_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 16.1,
                        get = function()
                            local c = self.db.profile.houseRewardTextColor
                            if not c then
                                local fallback = self.db.profile.houseXpColor
                                if fallback then return fallback.r, fallback.g, fallback.b, fallback.a end
                                return 0.9, 0.5, 0.0, 1.0 -- #E68000
                            end
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            if not self.db.profile.houseRewardTextColor then
                                self.db.profile.houseRewardTextColor = {}
                            end
                            local c = self.db.profile.houseRewardTextColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                    houseRewardTextYOffset = {
                        name = L["HOUSE_REWARD_Y_OFFSET"],
                        type = "range",
                        min = -1000,
                        max = 500,
                        step = 5,
                        order = 16.2,
                        get = function()
                            return self.db.profile.houseRewardTextYOffset or
                                self.db.profile.paragonTextYOffset or -40
                        end,
                        set = function(_, v)
                            self.db.profile.houseRewardTextYOffset = v
                            self:UpdateDisplay()
                        end,
                    },
                    headerAzerite = { type = "header", name = L["AZERITE"], order = 17 },
                    azeriteColor = {
                        name = L["AZERITE_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 18,
                        get = function()
                            local c = self.db.profile.azeriteColor
                            if not c then return 0.9, 0.8, 0.5, 1.0 end -- #E6CC80
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            if not self.db.profile.azeriteColor then
                                self.db.profile.azeriteColor = {}
                            end
                            local c = self.db.profile.azeriteColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                }
            },
            paragonSettings = {
                name = L["PARAGON_ALERTS"],
                type = "group",
                order = 40,
                args = {
                    paragonOnTop = {
                        name = L["SHOW_ON_TOP"],
                        type = "toggle",
                        order = 1,
                        get = function() return self.db.profile.paragonOnTop end,
                        set = function(_, v)
                            self.db.profile.paragonOnTop = v
                            self:UpdateDisplay()
                        end,
                    },
                    split = {
                        name = L["SPLIT_LINES"],
                        type = "toggle",
                        order = 2,
                        get = function() return self.db.profile.splitParagonText end,
                        set = function(_, v)
                            self.db.profile.splitParagonText = v
                            self:UpdateDisplay()
                        end,
                    },
                    paragonTextSize = {
                        name = L["TEXT_SIZE"],
                        type = "range",
                        min = 10,
                        max = 40,
                        step = 1,
                        order = 3,
                        get = function() return self.db.profile.paragonTextSize end,
                        set = function(_, v)
                            self.db.profile.paragonTextSize = v
                            self:UpdateDisplay()
                        end,
                    },
                    paragonTextYOffset = {
                        name = L["VERTICAL_OFFSET_Y"],
                        type = "range",
                        min = -1000,
                        max = 500,
                        step = 5,
                        order = 4,
                        get = function() return self.db.profile.paragonTextYOffset end,
                        set = function(_, v)
                            self.db.profile.paragonTextYOffset = v
                            self:UpdateDisplay()
                        end,
                    },
                    pColor = {
                        name = L["ALERT_COLOR"],
                        type = "color",
                        order = 5,
                        get = function()
                            local c = self.db.profile.paragonPendingColor
                            return c.r, c.g, c.b
                        end,
                        set = function(_, r, g, b)
                            local c = self.db.profile.paragonPendingColor
                            c.r, c.g, c.b = r, g, b
                            self:UpdateDisplay()
                        end,
                    },
                }
            },
            standingColors = {
                name = L["FACTION_COLORS"],
                type = "group",
                order = 50,
                args = {}
            },
            advanced = {
                name = L["ADVANCED"],
                type = "group",
                order = 60,
                args = {
                    showPercentage = {
                        name = L["SHOW_PERCENTAGE"],
                        type = "toggle",
                        order = 1,
                        get = function() return self.db.profile.showPercentage end,
                        set = function(_, v)
                            self.db.profile.showPercentage = v
                            self:UpdateDisplay()
                        end,
                    },
                    showAbsoluteValues = {
                        name = L["SHOW_ABSOLUTE_VALUES"],
                        type = "toggle",
                        order = 2,
                        get = function() return self.db.profile.showAbsoluteValues end,
                        set = function(_, v)
                            self.db.profile.showAbsoluteValues = v
                            self:UpdateDisplay()
                        end,
                    },
                    sparkEnabled = {
                        name = L["SHOW_SPARK"],
                        type = "toggle",
                        order = 3,
                        get = function() return self.db.profile.sparkEnabled end,
                        set = function(_, v)
                            self.db.profile.sparkEnabled = v
                            self:UpdateDisplay()
                        end,
                    },
                }
            },
        }
    }
    local labels = {
        L["HATED"], L["HOSTILE"], L["UNFRIENDLY"], L["NEUTRAL"], L["FRIENDLY"],
        L["HONORED"], L["REVERED"], L["EXALTED"], L["PARAGON"], L["MAXED"], L["RENOWN"]
    }
    for i = 1, 11 do
        options.args.standingColors.args["rank" .. i] = {
            name = labels[i],
            type = "color",
            hasAlpha = true,
            order = i,
            get = function()
                local c = self.db.profile.repColors[i]
                return c.r, c.g, c.b, c.a
            end,
            set = function(_, r, g, b, a)
                local c = self.db.profile.repColors[i]
                c.r, c.g, c.b, c.a = r, g, b, a
                self:UpdateDisplay()
            end,
        }
    end
    return options
end
