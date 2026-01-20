local AB = LibStub("AceAddon-3.0"):GetAddon("AscensionBars")

function AB:GetOptionsTable()
    local CONSTANTS = AB.constants
    local options = {
        name = "Ascension Bars",
        type = "group",
        childGroups = "tab",
        args = {
            configMode = {
                name = "Config Mode",
                desc = "Show dummy bars to visualize changes in real-time.",
                type = "toggle",
                order = 0,
                get = function() return self.state.isConfigMode end,
                set = function(_, val)
                    self.state.isConfigMode = val
                    self:UpdateDisplay()
                end,
            },
            general = {
                name = "Appearance",
                type = "group",
                order = 10,
                args = {
                    headerPos = { type = "header", name = "Position & Size", order = 1 },
                    yOffset = {
                        name = "Vertical Position (Y)",
                        type = "range",
                        min = -1080,
                        max = 0,
                        step = 1,
                        bigStep = 10,
                        order = 2,
                        get = function() return self.db.profile.yOffset end,
                        set = function(_, v)
                            self.db.profile.yOffset = v
                            self:UpdateDisplay()
                        end,
                    },
                    barHeightXP = {
                        name = "XP Bar Height",
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
                        name = "Reputation Bar Height",
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
                    textSize = {
                        name = "Font Size",
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
                        name = "Text Color",
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
                name = "Visibility",
                type = "group",
                order = 20,
                args = {
                    showOnMouseover = {
                        name = "Show on Mouseover",
                        type = "toggle",
                        order = 1,
                        get = function() return self.db.profile.showOnMouseover end,
                        set = function(_, v)
                            self.db.profile.showOnMouseover = v
                            self:UpdateDisplay()
                        end,
                    },
                    hideInCombat = {
                        name = "Hide in Combat",
                        type = "toggle",
                        order = 2,
                        get = function() return self.db.profile.hideInCombat end,
                        set = function(_, v)
                            self.db.profile.hideInCombat = v
                            self:UpdateDisplay()
                        end,
                    },
                }
            },
            colors = {
                name = "Colors",
                type = "group",
                order = 30,
                args = {
                    headerXP = { type = "header", name = "Experience", order = 1 },
                    useClassColorXP = {
                        name = "Use Class Color",
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
                        name = "Custom XP Color",
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
                        name = "Show Rested Bar",
                        type = "toggle",
                        order = 4,
                        get = function() return self.db.profile.showRestedBar end,
                        set = function(_, v)
                            self.db.profile.showRestedBar = v
                            self:UpdateDisplay()
                        end,
                    },
                    restedBarColor = {
                        name = "Rested Color",
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
                    headerRep = { type = "header", name = "Reputation", order = 10 },
                    useReactionColorRep = {
                        name = "Use Reaction Colors",
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
                        name = "Custom Rep Color",
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
                }
            },
            paragonSettings = {
                name = "Paragon Alerts",
                type = "group",
                order = 40,
                args = {
                    paragonOnTop = {
                        name = "Show on Top",
                        type = "toggle",
                        order = 1,
                        get = function() return self.db.profile.paragonOnTop end,
                        set = function(_, v)
                            self.db.profile.paragonOnTop = v
                            self:UpdateDisplay()
                        end,
                    },
                    split = {
                        name = "Split Lines",
                        type = "toggle",
                        order = 2,
                        get = function() return self.db.profile.splitParagonText end,
                        set = function(_, v)
                            self.db.profile.splitParagonText = v
                            self:UpdateDisplay()
                        end,
                    },
                    paragonTextSize = {
                        name = "Text Size",
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
                        name = "Vertical Offset (Y)",
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
                        name = "Alert Color",
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
                name = "Faction Colors",
                type = "group",
                order = 50,
                args = {}
            },
            advanced = {
                name = "Advanced",
                type = "group",
                order = 60,
                args = {
                    showPercentage = {
                        name = "Show Percentage",
                        type = "toggle",
                        order = 1,
                        get = function() return self.db.profile.showPercentage end,
                        set = function(_, v)
                            self.db.profile.showPercentage = v
                            self:UpdateDisplay()
                        end,
                    },
                    showAbsoluteValues = {
                        name = "Show Absolute Values",
                        type = "toggle",
                        order = 2,
                        get = function() return self.db.profile.showAbsoluteValues end,
                        set = function(_, v)
                            self.db.profile.showAbsoluteValues = v
                            self:UpdateDisplay()
                        end,
                    },
                    sparkEnabled = {
                        name = "Show Spark",
                        type = "toggle",
                        order = 3,
                        get = function() return self.db.profile.sparkEnabled end,
                        set = function(_, v)
                            self.db.profile.sparkEnabled = v
                            self:UpdateDisplay()
                        end,
                    },
                    debugMode = {
                        name = "Debug Mode",
                        desc = "Enable debug output in chat",
                        type = "toggle",
                        order = 10,
                        get = function() return self.db.profile.debugMode end,
                        set = function(_, v)
                            self.db.profile.debugMode = v
                            self:ToggleDebugMode()
                        end,
                    },
                }
            },
        }
    }

    local labels = {
        "1. Hated", "2. Hostile", "3. Unfriendly", "4. Neutral", "5. Friendly",
        "6. Honored", "7. Revered", "8. Exalted", "9. Paragon", "10. Maxed", "11. Renown"
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
