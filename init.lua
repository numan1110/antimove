require("ts3init")
require("ts3defs")
require("ts3errors")

require("antimove/events")
require("antimove/settings")

local function createMenus(moduleMenuItemID)
	-- Store value added to menuIDs to be able to calculate menuIDs for this module again for setPluginMenuEnabled (see demo.lua)
	antimove_events.moduleMenuItemID = moduleMenuItemID
	
	local generatedMenus = {
		{
			ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_GLOBAL,
			antimove_events.MenuIDs.MENU_ID_GLOBAL_1,
			"Toggle Anti-Move",
			""
		},
		{
			ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_GLOBAL,
			antimove_events.MenuIDs.MENU_ID_GLOBAL_2,
			"Get Server Unique ID",
			""
		}
	}
	return generatedMenus
end

local MODULE_NAME = "anti-move"

local registeredEvents = {
	createMenus = createMenus,
	onMenuItemEvent = antimove_events.onMenuItemEvent,
	onClientMoveMovedEvent = antimove_events.onClientMoveMovedEvent,
	onClientKickFromChannelEvent = antimove_events.onClientKickFromChannelEvent
}

-- Will store factor to add to menuID to calculate the real menuID used in the TeamSpeak client (to support menus from multiple Lua modules)
-- Add this value to above menuID when passing the ID to setPluginMenuEnabled. See demo.lua for an example.
local moduleMenuItemID = 0

ts3RegisterModule(MODULE_NAME, registeredEvents)
