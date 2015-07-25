require("antimove/settings")

local MenuIDs = {
	MENU_ID_GLOBAL_1 = 1,
	MENU_ID_GLOBAL_2 = 2
}

-- Will store factor to add to menuID to calculate the real menuID used in the TeamSpeak client (to support menus from multiple Lua modules)
-- Add this value to above menuID when passing the ID to setPluginMenuEnabled. See demo.lua for an example.
local moduleMenuItemID = 0

-- Whitelist of unique identifiers, of people allowed to move you (so no move back to the last channel)
local whitelist = antimove_whitelist
local servergroup_whitelist = antimove_servergroup_whitelist

-- Stores if the script should be working by default when loaded (true by default, so, working)
local enabled = antimove_enabled

function antimove_toggle(serverConnectionHandlerID)
	enabled = not enabled
	if enabled then
		ts3.printMessageToCurrentTab("Anti-move: Now enabled")
	else
		ts3.printMessageToCurrentTab("Anti-move: Now disabled")
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
	if menuItemID == 1 then
		antimove_toggle(serverConnectionHandlerID)
	elseif menuItemID == 2 then
		ts3.printMessageToCurrentTab("Current server unique ID: " .. getServerId(serverConnectionHandlerID));
	end
end

local function inter(grp1,grp2)
	local x = 0;
	local y = 0;
	local result = {};

	for x, name1 in ipairs(grp1) do
		for y, name2 in ipairs(grp2) do
			if (name1 == name2) then
				result[#result+1] = name1;
			end
		end
	end
	
	return result;
end

function getServerId(serverConnectionHandlerID)
	local VirtualServerId, error = ts3.getServerVariableAsString(serverConnectionHandlerID, ts3defs.VirtualServerProperties.VIRTUALSERVER_UNIQUE_IDENTIFIER);
	if error ~= ts3errors.ERROR_ok then
		print("Error getting server infos: " .. error)
		return
	end
	
	return VirtualServerId
end

-- This split function is from https://stackoverflow.com/questions/19262761/lua-need-to-split-at-comma#29497100
local function split(source, delimiters)
	local elements = {}
	local pattern = '([^'..delimiters..']+)'
	string.gsub(source, pattern, function(value) elements[#elements + 1] = value;  end);
	return elements
end

local function getClientServerGroups(serverConnectionHandlerID, clientID)
	return split(ts3.getClientVariableAsString(serverConnectionHandlerID, clientID, ts3defs.ClientProperties.CLIENT_SERVERGROUPS),",")
end

local function returntolastchannel(serverConnectionHandlerID, clientID, oldChannelID, moverUniqueIdentifier,moverID)
	local myClientID, error = ts3.getClientID(serverConnectionHandlerID)
	if error ~= ts3errors.ERROR_ok then
		print("Error getting own client ID: " .. error)
		return
	end
	if myClientID == 0 then
		ts3.printMessageToCurrentTab("Not connected")
		return
	end

	local password = ""

	if myClientID == clientID then -- Seems to have some errors when moving in another tab, this make sure to not have them
		if not enabled then
			ts3.printMessageToCurrentTab("Anti-move: Disabled, ignoring")
			return
		end
		
		for i = 1, #whitelist do
			if moverUniqueIdentifier == whitelist[i] then
				ts3.printMessageToCurrentTab("Anti-move: Whitelisted mover/kicker unique identifier")
				return
			end
		end
		
		local serverID = getServerId(serverConnectionHandlerID)
		if servergroup_whitelist[serverID] ~= nil then
			local compare = inter(getClientServerGroups(serverConnectionHandlerID,moverID),split(servergroup_whitelist[serverID],","))
			if #compare > 0 then
				ts3.printMessageToCurrentTab("Anti-move: Whitelisted Server Group")
				return
			end
		end
		ts3.requestClientMove(serverConnectionHandlerID, clientID, oldChannelID, password)
	end
end

local function onClientMoveMovedEvent(serverConnectionHandlerID, clientID, oldChannelID, newChannelID, visibility, moverID, moverName, moverUniqueIdentifier, moveMessage)
	returntolastchannel(serverConnectionHandlerID, clientID, oldChannelID, moverUniqueIdentifier, moverID)
end

local function onClientKickFromChannelEvent(serverConnectionHandlerID, clientID, oldChannelID, newChannelID, visibility, kickerID, kickerName, kickerUniqueIdentifier, kickMessage)
	returntolastchannel(serverConnectionHandlerID, clientID, oldChannelID, kickerUniqueIdentifier, kickerID)
end

antimove_events = {
	MenuIDs = MenuIDs,
	moduleMenuItemID = moduleMenuItemID,
	onMenuItemEvent = onMenuItemEvent,
	onClientMoveMovedEvent = onClientMoveMovedEvent,
	onClientKickFromChannelEvent = onClientKickFromChannelEvent
}
