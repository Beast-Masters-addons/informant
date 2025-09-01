local addonName = ...

local AceConfig = _G.LibStub("AceConfig-3.0")
local AceConfigDialog = _G.LibStub("AceConfigDialog-3.0")

local addon = _G.LibStub("AceAddon-3.0"):GetAddon("Informant")
---@class Informant_Settings
local options = addon:NewModule("Informant_Settings")

---@type BMUtilsBasic
local basic = _G.LibStub("BMUtilsBasic")

options.defaults = {
    profile = {
        ['enable'] = true,
        ['embed'] = false,
        ['show_vendor'] = true,
        ['show_vendor_buy'] = true,
        ['show_vendor_sell'] = true,
        ['show_usage'] = true,
        ['show_stack'] = true,
        ['show_merchant'] = true,
        ['show_zero_merchants'] = true,
        ['show_quest'] = true,
        ['show_ilevel'] = true,
        ['show_link'] = false,
        ['auto_update'] = false,
        ['ModTTShow'] = "always",
        ['show_binding'] = false,
        ['altchatlink_tooltip'] = false,
        ['show_crafted'] = false,
        ['locale'] = _G.GetLocale(),
        ['welcomed'] = false,
    }
}

function options:getOptionsTable()
    ---@type Informant_Locale
    local localize = addon:GetModule("Informant_Locale")
    local _TRANS = localize.Translate

    local informantOptionsTable = {
        type = "group",
        get = function(info)
            return options.db.profile[info[#info]]
        end,
        set = function(info, value)
            options.db.profile[info[#info]] = value
        end,
        args = {
            general_header = {
                order = 10,
                type = "header",
                width = "double",
                name = _TRANS('INF_Interface_GeneralOptions'),
            },
            enable = {
                order = 11,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_EnableInformant'),
                desc = _TRANS('INF_HelpTooltip_EnableInformant'),
            },
            embed = {
                order = 12,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_Embed'),
                desc = _TRANS('INF_HelpTooltip_Embed'),
            },
            show_binding = {
                order = 13,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_ShowBindinginTT'),
                desc = _TRANS('INF_HelpTooltip_ShowBindinginTT'),
            },
            altchatlink_tooltip = {
                order = 15,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_AltChatLink'),
                desc = _TRANS('INF_HelpTooltip_AltChatLink'),
            },
            ModTTShow = {
                order = 16,
                type = "select",
                --width = "double",
                name = _TRANS('INF_Interface_ModTTShow'),
                desc = _TRANS('INF_HelpTooltip_ModTTShow'),
                sorting = { "always", "alt", "noalt", "shift", "noshift", "ctrl", "noctrl", "never" },
                values = {
                    ["always"] = _TRANS('INF_Interface_MTS_Always'),
                    ["alt"] = _TRANS('INF_Interface_MTS_Alt'),
                    ["noalt"] = _TRANS('INF_Interface_MTS_NoAlt'),
                    ["shift"] = _TRANS('INF_Interface_MTS_Shift'),
                    ["noshift"] = _TRANS('INF_Interface_MTS_NoShift'),
                    ["ctrl"] = _TRANS('INF_Interface_MTS_Ctrl'),
                    ["noctrl"] = _TRANS('INF_Interface_MTS_NoCtrl'),
                    ["never"] = _TRANS('INF_Interface_MTS_Never'),
                }
            },
            locale = {
                order = 17,
                type = "select",
                --width = "double",
                name = "Language:",
                desc = "The selected Locale takes effect after a /reload or on next login",
                values = function()
                    local values = {}
                    for _, locale in ipairs(localize.GetLocaleList()) do
                        values[locale] = locale
                    end
                    return values
                end
            },

            vendor_header = {
                order = 20,
                name = "Vendor",
                width = "double",
                type = "header",
            },
            show_vendor = {
                order = 21,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_VendorToggle'),
                desc = _TRANS('INF_HelpTooltip_VendorToggle'),
            },
            show_vendor_buy = {
                order = 22,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_ShowVendorBuy'),
                desc = _TRANS('INF_HelpTooltip_ShowVendorBuy'),
            },
            show_vendor_sell = {
                order = 23,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_ShowVendorSell'),
                desc = _TRANS('INF_HelpTooltip_ShowVendorSell'),
            },
            show_merchant = {
                order = 24,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_ShowMerchant'),
                desc = _TRANS('INF_HelpTooltip_ShowMerchant'),
            },
            show_zero_merchants = {
                order = 25,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_ShowZeroMerchants'),
                desc = _TRANS('INF_HelpTooltip_ShowZeroMerchants'),
            },
            auto_update = {
                order = 26,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_AutoUpdate'),
                desc = _TRANS('INF_HelpTooltip_AutoUpdate'),
            },
            basic_header = {
                order = 30,
                name = "Basic item properties",
                width = "double",
                type = "header",
            },
            show_stack = {
                order = 32,
                type = "toggle",
                --width = "double",
                name = _TRANS('INF_Interface_ShowStack'),
                desc = _TRANS('INF_HelpTooltip_ShowStack'),
            },
            show_ilevel = {
                order = 33,
                type = "toggle",
                --width = "double",
                name = _TRANS('INF_Interface_ShowIlevel'),
                desc = _TRANS('INF_HelpTooltip_ShowIlevel'),
            },
            show_link = {
                order = 34,
                type = "toggle",
                --width = "double",
                name = _TRANS('INF_Interface_ShowLink'),
                desc = _TRANS('INF_HelpTooltip_ShowLink'),
            },
            usage_header = {
                order = 40,
                name = "Item usage",
                width = "double",
                type = "header",
            },
            show_usage = {
                order = 41,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_ShowUsage'),
                desc = _TRANS('INF_HelpTooltip_ShowUsage'),
            },
            show_quest = {
                order = 42,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_ShowQuest'),
                desc = _TRANS('INF_HelpTooltip_ShowQuest'),
            },
            show_crafted = {
                order = 43,
                type = "toggle",
                width = "double",
                name = _TRANS('INF_Interface_ShowCrafted'),
                desc = _TRANS('INF_HelpTooltip_ShowCrafted'),
            },


        }
    }
    --informantOptionsTable.args.profiles = _G.LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

    return informantOptionsTable
end

function options:reset()
    self.db.ResetProfile()
end

function options:OnInitialize()
    self.db = _G.LibStub("AceDB-3.0"):New("InformantDB", self.defaults, true)

    if basic.empty(self.db) then
        print('DB empty, reset')
        self:reset()
    end
    self.visible = false
end

function options:OnEnable()
    -- Register the config
    AceConfig:RegisterOptionsTable(addonName, self:getOptionsTable(), { "inface" })
    AceConfigDialog:AddToBlizOptions(addonName, addonName)
end

function options:open()
    AceConfigDialog:Open(addonName)
end

function options:close()
    AceConfigDialog:Close(addonName)
end

function options:toggle()
    if self.visible then
        self:close()
        self.visible = false
    else
        self:open()
        self.visible = true
    end
end

function options.get(setting)
    setting = setting:gsub('-', '_')
    if options.db.profile[setting] == nil then
        error(('Invalid option %s'):format(setting))
    end
    return options.db.profile[setting]
end

function options.set(setting, value)
    options.db.profile[setting] = value
end