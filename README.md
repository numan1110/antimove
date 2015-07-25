# antimove
Auto return to the last channel with a TeamSpeak3 lua plugin after being moved or kicked from a channel. Whitelist support to allow people to move or kick you from a channel.

# Install

- Using lastest version:

```bash
cd TEAMSPEAK/plugins/lua_plugins # TEAMSPEAK is your Teamspeak root folder.
git clone https://github.com/fullinterest/antimove.git
```
- You can also use the release version, a version in the ts3 plugin format, see on teamspeak 3 if there's no application assigned to the ts3_plugin file.

# Update

Don't forget to check if new settings have been added in the settings.lua as it's in the .gitignore and it might not work well if there's missing setting(s)

# Settings

The settings are included in the settings.lua file.

Whitelist of unique identifiers, comma separated list like with the default example, of people allowed to move you (so no move back to the last channel)

The server group whitelist have to be like this: 
```
antimove_servergroup_whitelist={["58VyjHBTkYCeGnUGN+Xe1s95M2o="]="1,2,3"}
```
- You can get the server ID by clicking on Plugins \ Lua plugin \ Get Server Unique ID.
- "1,2,3" are the server group ID (comma separated list) whitelisted in the server ID "58VyjHBTkYCeGnUGN+Xe1s95M2o="
- You can add several servers, the main {} is comma separated list too, just don't forget to put the server ID in [ ] like in the example.

antimove_enabled stores if the script should be working by default when loaded (true by default, so, working)
