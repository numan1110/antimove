require("antimove/settings")

local MenuIDs = {
	MENU_ID_GLOBAL_1 = 1
}

-- Will store factor to add to menuID to calculate the real menuID used in the TeamSpeak client (to support menus from multiple Lua modules)
-- Add this value to above menuID when passing the ID to setPluginMenuEnabled. See demo.lua for an example.
local moduleMenuItemID = 0

-- Whitelist of unique identifiers, of people allowed to move you (so no move back to the last channel)
local whitelist = antimove_whitelist

-- Stores if the script should be working by default when loaded (true by default, so, working)
local enabled = antimove_enabled

function antimove_toggle(serverConnectionHandlerID)
	if enabled==true then
		enabled=false
		ts3.printMessageToCurrentTab("Anti-move: Now disabled")
	else
		enabled=true
		ts3.printMessageToCurrentTab("Anti-move: Now enabled")
	end
end

--
-- Called when a plugin menu item (see ts3plugin_initMenus) is triggered. Optional function, when not using plugin menus, do not implement this.
--
-- Parameters:
--  serverConnectionHandlerID: ID of the current server tab
--  type: Type of the menu (ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_CHANNEL, ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_CLIENT or ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_GLOBAL)
--  menuItemID: Id used when creating the menu item
--  selectedItemID: Channel or Client ID in the case of PLUGIN_MENU_TYPE_CHANNEL and PLUGIN_MENU_TYPE_CLIENT. 0 for PLUGIN_MENU_TYPE_GLOBAL.
--
local function onMenuItemEvent(serverConnectionHandlerID, menuType, menuItemID, selectedItemID)
	--ts3.printMessageToCurrentTab("massznmtools: onMenuItemEvent: " .. serverConnectionHandlerID .. " " .. menuType .. " " .. menuItemID .. " " .. selectedItemID.." "..moduleMenuItemID)
	if menuItemID==1 then
		antimove_toggle(serverConnectionHandlerID)
	end
end

--local function onClientMoveEvent(serverConnectionHandlerID, clientID, oldChannelID, newChannelID, visibility, moveMessage)
--	ts3.printMessageToCurrentTab(serverConnectionHandlerID.." -- "..clientID.." -- "..oldChannelID.." -- "..newChannelID.." -- "..visibility.." -- "..MoveMessage)
--end

local function onClientMoveMovedEvent(serverConnectionHandlerID, clientID, oldChannelID, newChannelID, visibility, moverID, moverName, moverUniqueIdentifier, moveMessage)
	--ts3.printMessageToCurrentTab(serverConnectionHandlerID .. " -- " .. clientID .. " -- " .. oldChannelID .. " -- " .. newChannelID .. " -- " .. visibility .. " -- " .. moverID .. " -- " .. moverName .. " -- " .. moverUniqueIdentifier .. " -- " .. moveMessage)
	local myClientID, error = ts3.getClientID(serverConnectionHandlerID)
	if error ~= ts3errors.ERROR_ok then
		print("Error getting own client ID: " .. error)
		return
	end
	if myClientID == 0 then
		ts3.printMessageToCurrentTab("Not connected")
		return
	end

	local password=""

	if myClientID==clientID then -- Seems to have some errors when moving in another tab, this make sure to not have them
		if enabled==false then
			ts3.printMessageToCurrentTab("Anti-move: Disabled, ignoring")
			return
		end
		if #whitelist>0 then
			for i=1, #whitelist do
				if moverUniqueIdentifier == whitelist[i] then
					ts3.printMessageToCurrentTab("Anti-move: Whitelisted mover unique identifier")
					return
				end
			end
		end
		ts3.requestClientMove(serverConnectionHandlerID, clientID, oldChannelID, password)
	end
end

antimove_events= {
	MenuIDs = MenuIDs,
	moduleMenuItemID = moduleMenuItemID,
	["onMenuItemEvent"] = onMenuItemEvent,
	--["onClientMoveEvent"] = onClientMoveEvent,
	["onClientMoveMovedEvent"] = onClientMoveMovedEvent
}
