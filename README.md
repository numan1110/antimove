# antimove
Auto return to the last channel with a TeamSpeak3 lua plugin after being moved or kicked from a channel. Whitelist support to allow people to move or kick you from a channel.

# Install

- Using lastest version:

```bash
cd TEAMSPEAK/plugins/lua_plugins #T EAMSPEAK is your Teamspeak root folder.
git clone https://github.com/fullinterest/antimove.git
```
- You can also use the release version, a version in the ts3 plugin format, see on teamspeak 3 if there's no application assigned to the ts3_plugin file.

# Settings

The settings are included in the settings.lua file.

Whitelist of unique identifiers, comma separated list like with the default example, of people allowed to move you (so no move back to the last channel)

antimove_enabled stores if the script should be working by default when loaded (true by default, so, working)
