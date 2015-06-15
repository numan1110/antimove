require("ts3init")
require("ts3defs")
require("ts3errors")
--require("ts3events")
require("anti-move/events")
require("anti-move/settings")

local function createMenus(moduleMenuItemID)
	-- Store value added to menuIDs to be able to calculate menuIDs for this module again for setPluginMenuEnabled (see demo.lua)
	antimove_events.moduleMenuItemID = moduleMenuItemID
	return {
		{ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_GLOBAL, antimove_events.MenuIDs.MENU_ID_GLOBAL_1, "Toggle Anti-Move", ""},
		}
end

local MODULE_NAME = "notifier"

local registeredEvents = {
	createMenus = createMenus,
	--["onClientMoveEvent"] = antimove_events.onClientMoveEvent,
	["onMenuItemEvent"] = antimove_events.onMenuItemEvent,
	["onClientMoveMovedEvent"] = antimove_events.onClientMoveMovedEvent
}

-- Will store factor to add to menuID to calculate the real menuID used in the TeamSpeak client (to support menus from multiple Lua modules)
-- Add this value to above menuID when passing the ID to setPluginMenuEnabled. See demo.lua for an example.
local moduleMenuItemID = 0

ts3RegisterModule(MODULE_NAME, registeredEvents)
