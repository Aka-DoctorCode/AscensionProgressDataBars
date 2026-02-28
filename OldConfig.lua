-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Config.lua
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

local function cleanBlockOrders(profile, block)
    local temp = {}
    for k, bar in pairs(profile.bars) do
        if bar.block == block then
            table.insert(temp, { key = k, order = bar.order or 99 })
        end
    end
    table.sort(temp, function(a, b) return a.order < b.order end)
    for i, data in ipairs(temp) do
        profile.bars[data.key].order = i
    end
end

local function getBlockCount(profile, block)
    local count = 0
    for _, bar in pairs(profile.bars) do
        if bar.block == block then count = count + 1 end
    end
    return count
end

local function generateBarOptions(self, barKey, barName, targetBlock)
    local profile = self.db.profile
    return {
        name = barName,
        type = "group",
        order = function() return profile.bars[barKey].order end,
        hidden = function() return profile.bars[barKey].block ~= targetBlock end,
        args = {
            enabled = {
                name = L["ENABLE_BAR"],
                type = "toggle",
                order = 1,
                get = function() return profile.bars[barKey].enabled end,
                set = function(_, v)
                    profile.bars[barKey].enabled = v
                    self:UpdateDisplay()
                end,
            },
            block = {
                name = L["LAYOUT_BLOCK"],
                type = "select",
                order = 2,
                values = { ["TOP"] = L["ANCHOR_TOP"], ["BOTTOM"] = L["ANCHOR_BOTTOM"], ["FREE"] = "Free Mode" },
                get = function() return profile.bars[barKey].block end,
                set = function(_, v)
                    local oldBlock = profile.bars[barKey].block
                    profile.bars[barKey].block = v
                    cleanBlockOrders(profile, oldBlock)
                    local newCount = getBlockCount(profile, v)
                    profile.bars[barKey].order = (newCount > 0) and newCount or 1
                    self:UpdateDisplay()
                    LibStub("AceConfigRegistry-3.0"):NotifyChange("AscensionBars")
                end,
            },
            order = {
                name = L["BAR_ORDER"],
                type = "select",
                order = 3,
                values = function()
                    local count = getBlockCount(profile, profile.bars[barKey].block)
                    local vals = {}
                    for i = 1, count do vals[i] = tostring(i) end
                    return vals
                end,
                get = function() return profile.bars[barKey].order end,
                set = function(_, v)
                    local oldOrder = profile.bars[barKey].order
                    local newOrder = v
                    local block = profile.bars[barKey].block
                    if oldOrder == newOrder then return end
                    for k, bar in pairs(profile.bars) do
                        if k ~= barKey and bar.block == block then
                            if oldOrder < newOrder then
                                if bar.order > oldOrder and bar.order <= newOrder then
                                    bar.order = bar.order - 1
                                end
                            else
                                if bar.order >= newOrder and bar.order < oldOrder then
                                    bar.order = bar.order + 1
                                end
                            end
                        end
                    end
                    profile.bars[barKey].order = newOrder
                    self:UpdateDisplay()
                    LibStub("AceConfigRegistry-3.0"):NotifyChange("AscensionBars")
                end,
            },
            freeHeader = { type = "header", name = "Bar Settings", order = 10 },
            freeWidth = {
                name = L["BAR_WIDTH"],
                type = "range",
                min = 50,
                max = 2000,
                step = 1,
                order = 11,
                hidden = function() return profile.bars[barKey].block ~= "FREE" end,
                get = function() return profile.bars[barKey].freeWidth end,
                set = function(_, v)
                    profile.bars[barKey].freeWidth = v; self:UpdateDisplay()
                end,
            },
            freeHeight = {
                name = L["BAR_HEIGHT"],
                type = "range",
                min = 1,
                max = 50,
                step = 1,
                order = 12,
                get = function() return profile.bars[barKey].freeHeight end,
                set = function(_, v)
                    profile.bars[barKey].freeHeight = v; self:UpdateDisplay()
                end,
            },
            freeX = {
                name = "Horizontal Position (X)",
                type = "range",
                min = -1000,
                max = 1000,
                step = 1,
                order = 13,
                hidden = function() return profile.bars[barKey].block ~= "FREE" end,
                get = function() return profile.bars[barKey].freeX end,
                set = function(_, v)
                    profile.bars[barKey].freeX = v; self:UpdateDisplay()
                end,
            },
            freeY = {
                name = "Vertical Position (Y)",
                type = "range",
                min = -1000,
                max = 1000,
                step = 1,
                order = 14,
                hidden = function() return profile.bars[barKey].block ~= "FREE" end,
                get = function() return profile.bars[barKey].freeY end,
                set = function(_, v)
                    profile.bars[barKey].freeY = v; self:UpdateDisplay()
                end,
            },
            textHeader = {
                type = "header",
                name = "Text Offsets",
                order = 20,
                hidden = function() return profile.textLayoutMode ~= "INDIVIDUAL_LINES" end
            },
            textX = {
                name = "Text X Offset",
                type = "range",
                min = -500,
                max = 500,
                step = 1,
                order = 21,
                hidden = function() return profile.textLayoutMode ~= "INDIVIDUAL_LINES" end,
                get = function() return profile.bars[barKey].textX end,
                set = function(_, v)
                    profile.bars[barKey].textX = v; self:UpdateDisplay()
                end,
            },
            textY = {
                name = "Text Y Offset",
                type = "range",
                min = -500,
                max = 500,
                step = 1,
                order = 22,
                hidden = function() return profile.textLayoutMode ~= "INDIVIDUAL_LINES" end,
                get = function() return profile.bars[barKey].textY end,
                set = function(_, v)
                    profile.bars[barKey].textY = v; self:UpdateDisplay()
                end,
            },
        }
    }
end

function AB:GetOptionsTable()
    local constants = AB.constants
    local options = {
        name = "Ascension Bars",
        type = "group",
        childGroups = "tab",
        args = {
            configMode = {
                name = L["CONFIG_MODE"],
                desc = L["CONFIG_MODE_DESC"],
                type = "toggle",
                order = 1,
                get = function() return self.state.isConfigMode end,
                set = function(_, val)
                    self.state.isConfigMode = val
                    self:UpdateDisplay()
                end,
            },
            -----------------------------------------------------------------------
            -- LAYOUT TAB: Structural settings and bar placement
            -----------------------------------------------------------------------
            layout = {
                name = L["LAYOUT"] or "Layout",
                type = "group",
                order = 10,
                args = {
                    headerBlocks = { type = "header", name = "Global Positioning", order = 1 },
                    yOffset = {
                        name = "Global Blocks Offset",
                        desc = "Vertical distance for TOP and BOTTOM blocks.",
                        type = "range",
                        min = -100,
                        max = 100,
                        step = 1,
                        order = 2,
                        get = function() return self.db.profile.yOffset end,
                        set = function(_, v)
                            self.db.profile.yOffset = v
                            self:UpdateDisplay()
                        end,
                    },
                    globalBarHeight = {
                        name = L["BAR_HEIGHT"] or "Global Bar Height",
                        type = "range",
                        min = 1,
                        max = 50,
                        step = 1,
                        order = 3,
                        get = function() return self.db.profile.globalBarHeight end,
                        set = function(_, v)
                            self.db.profile.globalBarHeight = v
                            for _, barConfig in pairs(self.db.profile.bars) do
                                barConfig.freeHeight = v
                            end
                            self:UpdateDisplay()
                        end,
                    },
                    headerBars = { type = "header", name = "Bar Management", order = 10 },
                    barsGroup = {
                        name = "Active Bars",
                        type = "group",
                        inline = true,
                        order = 11,
                        args = {
                            topBlock = {
                                name = L["ANCHOR_TOP"],
                                type = "group",
                                inline = true,
                                order = 1,
                                args = {
                                    xp = generateBarOptions(self, "XP", L["EXPERIENCE"], "TOP"),
                                    rep = generateBarOptions(self, "Rep", L["REPUTATION"], "TOP"),
                                    honor = generateBarOptions(self, "Honor", L["HONOR"], "TOP"),
                                    house = generateBarOptions(self, "HouseXp", L["HOUSE_XP"], "TOP"),
                                    azerite = generateBarOptions(self, "Azerite", L["AZERITE"], "TOP"),
                                }
                            },
                            bottomBlock = {
                                name = L["ANCHOR_BOTTOM"],
                                type = "group",
                                inline = true,
                                order = 2,
                                args = {
                                    xp = generateBarOptions(self, "XP", L["EXPERIENCE"], "BOTTOM"),
                                    rep = generateBarOptions(self, "Rep", L["REPUTATION"], "BOTTOM"),
                                    honor = generateBarOptions(self, "Honor", L["HONOR"], "BOTTOM"),
                                    house = generateBarOptions(self, "HouseXp", L["HOUSE_XP"], "BOTTOM"),
                                    azerite = generateBarOptions(self, "Azerite", L["AZERITE"], "BOTTOM"),
                                }
                            },
                            freeBlock = {
                                name = "Free Mode",
                                type = "group",
                                inline = true,
                                order = 3,
                                args = {
                                    xp = generateBarOptions(self, "XP", L["EXPERIENCE"], "FREE"),
                                    rep = generateBarOptions(self, "Rep", L["REPUTATION"], "FREE"),
                                    honor = generateBarOptions(self, "Honor", L["HONOR"], "FREE"),
                                    house = generateBarOptions(self, "HouseXp", L["HOUSE_XP"], "FREE"),
                                    azerite = generateBarOptions(self, "Azerite", L["AZERITE"], "FREE"),
                                }
                            },
                        }
                    },
                }
            },
            -----------------------------------------------------------------------
            -- APPEARANCE TAB: Visual styles, text and colors
            -----------------------------------------------------------------------
            appearance = {
                name = L["APPEARANCE"],
                type = "group",
                order = 20,
                args = {
                    headerText = { type = "header", name = "Text & Font", order = 1 },
                    textLayoutMode = {
                        name = "Layout Mode",
                        type = "select",
                        order = 2,
                        values = { ["SINGLE_LINE"] = "All in one line", ["INDIVIDUAL_LINES"] = "Multiple lines" },
                        get = function() return self.db.profile.textLayoutMode end,
                        set = function(_, v)
                            self.db.profile.textLayoutMode = v; self:UpdateDisplay()
                        end,
                    },
                    textFollowBar = {
                        name = "Text follows its Bar",
                        desc = "If disabled, text will anchor to the global center.",
                        type = "toggle",
                        order = 2.1,
                        hidden = function() return self.db.profile.textLayoutMode == "SINGLE_LINE" end,
                        get = function() return self.db.profile.textFollowBar end,
                        set = function(_, v)
                            self.db.profile.textFollowBar = v; self:UpdateDisplay()
                        end,
                    },
                    textSize = {
                        name = L["FONT_SIZE"],
                        type = "range",
                        order = 3,
                        min = constants.MIN_TEXT_SIZE,
                        max = constants.MAX_TEXT_SIZE,
                        step = 1,
                        get = function() return self.db.profile.textSize end,
                        set = function(_, v)
                            self.db.profile.textSize = v; self:UpdateDisplay()
                        end,
                    },
                    globalColor = {
                        name = L["TEXT_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 4,
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
                    headerData = { type = "header", name = "Data Display", order = 10 },
                    showPercentage = {
                        name = L["SHOW_PERCENTAGE"],
                        type = "toggle",
                        order = 11,
                        get = function() return self.db.profile.showPercentage end,
                        set = function(_, v)
                            self.db.profile.showPercentage = v
                            self:UpdateDisplay()
                        end,
                    },
                    showAbsoluteValues = {
                        name = L["SHOW_ABSOLUTE_VALUES"],
                        type = "toggle",
                        order = 12,
                        get = function() return self.db.profile.showAbsoluteValues end,
                        set = function(_, v)
                            self.db.profile.showAbsoluteValues = v
                            self:UpdateDisplay()
                        end,
                    },
                    sparkEnabled = {
                        name = L["SHOW_SPARK"],
                        type = "toggle",
                        order = 13,
                        get = function() return self.db.profile.sparkEnabled end,
                        set = function(_, v)
                            self.db.profile.sparkEnabled = v
                            self:UpdateDisplay()
                        end,
                    },
                }
            },
            -----------------------------------------------------------------------
            -- BEHAVIOR TAB: Visibility and automatic logic
            -----------------------------------------------------------------------
            behavior = {
                name = L["VISIBILITY"] or "Behavior",
                type = "group",
                order = 30,
                args = {
                    headerVisibility = { type = "header", name = "Auto-Hide Logic", order = 1 },
                    showOnMouseover = {
                        name = L["SHOW_ON_MOUSEOVER"],
                        type = "toggle",
                        order = 2,
                        get = function() return self.db.profile.showOnMouseover end,
                        set = function(_, v)
                            self.db.profile.showOnMouseover = v
                            self:UpdateDisplay()
                        end,
                    },
                    hideInCombat = {
                        name = L["HIDE_IN_COMBAT"],
                        type = "toggle",
                        order = 3,
                        get = function() return self.db.profile.hideInCombat end,
                        set = function(_, v)
                            self.db.profile.hideInCombat = v
                            self:UpdateDisplay()
                        end,
                    },
                    hideAtMaxLevel = {
                        name = L["HIDE_AT_MAX_LEVEL"],
                        type = "toggle",
                        order = 4,
                        get = function() return self.db.profile.hideAtMaxLevel end,
                        set = function(_, v)
                            self.db.profile.hideAtMaxLevel = v
                            self:UpdateDisplay()
                        end,
                    },
                }
            },
            -----------------------------------------------------------------------
            -- COLORS TAB: Specific bar and faction colors
            -----------------------------------------------------------------------
            colors = {
                name = L["COLORS"],
                type = "group",
                order = 40,
                args = {
                    -- Experience Section
                    headerXP = { type = "header", name = L["EXPERIENCE"], order = 1 },
                    useClassColorXP = {
                        name = L["USE_CLASS_COLOR"],
                        type = "toggle",
                        width = "full",
                        order = 2,
                        get = function() return self.db.profile.useClassColorXP end,
                        set = function(_, v)
                            self.db.profile.useClassColorXP = v; self:UpdateDisplay()
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
                            self.db.profile.showRestedBar = v; self:UpdateDisplay()
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
                    -- Reputation Section
                    headerRep = { type = "header", name = L["REPUTATION"], order = 10 },
                    useReactionColorRep = {
                        name = L["USE_REACTION_COLORS"],
                        type = "toggle",
                        width = "full",
                        order = 11,
                        get = function() return self.db.profile.useReactionColorRep end,
                        set = function(_, v)
                            self.db.profile.useReactionColorRep = v; self:UpdateDisplay()
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
                    standingColors = {
                        name = L["FACTION_COLORS"],
                        type = "group",
                        order = 13,
                        inline = true,
                        args = {} -- Dynamically filled
                    },
                    -- Honor Section
                    headerHonor = { type = "header", name = L["HONOR"], order = 20 },
                    honorColor = {
                        name = L["HONOR_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 21,
                        get = function()
                            local c = self.db.profile.honorColor
                            if not c then return 0.8, 0.2, 0.2, 1.0 end -- #CC3333
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            if not self.db.profile.honorColor then self.db.profile.honorColor = {} end
                            local c = self.db.profile.honorColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                    -- House Favor Section
                    headerHouse = { type = "header", name = L["HOUSE_XP"], order = 30 },
                    houseXpColor = {
                        name = L["HOUSE_XP_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 31,
                        get = function()
                            local c = self.db.profile.houseXpColor
                            if not c then return 0.9, 0.5, 0.0, 1.0 end -- #E68000
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            if not self.db.profile.houseXpColor then self.db.profile.houseXpColor = {} end
                            local c = self.db.profile.houseXpColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                    houseRewardTextColor = {
                        name = L["HOUSE_REWARD_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 32,
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
                            if not self.db.profile.houseRewardTextColor then self.db.profile.houseRewardTextColor = {} end
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
                        order = 33,
                        get = function() return self.db.profile.houseRewardTextYOffset or -40 end,
                        set = function(_, v)
                            self.db.profile.houseRewardTextYOffset = v; self:UpdateDisplay()
                        end,
                    },
                    -- Azerite Section
                    headerAzerite = { type = "header", name = L["AZERITE"], order = 40 },
                    azeriteColor = {
                        name = L["AZERITE_COLOR"],
                        type = "color",
                        hasAlpha = true,
                        order = 41,
                        get = function()
                            local c = self.db.profile.azeriteColor
                            if not c then return 0.9, 0.8, 0.5, 1.0 end -- #E6CC80
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            if not self.db.profile.azeriteColor then self.db.profile.azeriteColor = {} end
                            local c = self.db.profile.azeriteColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            self:UpdateDisplay()
                        end,
                    },
                },
            },
            paragonSettings = {
                name = L["PARAGON_ALERTS"],
                type = "group",
                order = 50,
                args = {
                    headerParagon = { type = "header", name = "Alert Styling", order = 1 },
                    paragonOnTop = {
                        name = L["SHOW_ON_TOP"],
                        type = "toggle",
                        order = 2,
                        get = function() return self.db.profile.paragonOnTop end,
                        set = function(_, v)
                            self.db.profile.paragonOnTop = v; self:UpdateDisplay()
                        end,
                    },
                    split = {
                        name = L["SPLIT_LINES"],
                        type = "toggle",
                        order = 3,
                        get = function() return self.db.profile.splitParagonText end,
                        set = function(_, v)
                            self.db.profile.splitParagonText = v; self:UpdateDisplay()
                        end,
                    },
                    paragonTextSize = {
                        name = L["TEXT_SIZE"],
                        type = "range",
                        min = 10,
                        max = 40,
                        step = 1,
                        order = 4,
                        get = function() return self.db.profile.paragonTextSize end,
                        set = function(_, v)
                            self.db.profile.paragonTextSize = v; self:UpdateDisplay()
                        end,
                    },
                    paragonTextYOffset = {
                        name = L["VERTICAL_OFFSET_Y"],
                        type = "range",
                        min = -1000,
                        max = 500,
                        step = 5,
                        order = 5,
                        get = function() return self.db.profile.paragonTextYOffset end,
                        set = function(_, v)
                            self.db.profile.paragonTextYOffset = v; self:UpdateDisplay()
                        end,
                    },
                    pColor = {
                        name = L["ALERT_COLOR"],
                        type = "color",
                        order = 6,
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
        }
    }

    -- Dynamic rank color generation for reputation standings
    local labels = {
        L["HATED"], L["HOSTILE"], L["UNFRIENDLY"], L["NEUTRAL"], L["FRIENDLY"],
        L["HONORED"], L["REVERED"], L["EXALTED"], L["PARAGON"], L["MAXED"], L["RENOWN"]
    }

    for i = 1, 11 do
        options.args.colors.args.standingColors.args["rank" .. i] = {
            name = labels[i] or ("Rank " .. i),
            type = "color",
            hasAlpha = true,
            order = i,
            get = function()
                local c = self.db.profile.repColors[i]
                if not c then return 1, 1, 1, 1 end -- Default fallback #FFFFFF
                return c.r, c.g, c.b, c.a
            end,
            set = function(_, r, g, b, a)
                -- Initialize table if it does not exist to avoid nil index errors
                if not self.db.profile.repColors[i] then
                    self.db.profile.repColors[i] = {}
                end
                local c = self.db.profile.repColors[i]
                -- Corrected assignment: using c.g instead of global g
                c.r, c.g, c.b, c.a = r, g, b, a
                self:UpdateDisplay()
            end,
        }
    end

    return options
end
