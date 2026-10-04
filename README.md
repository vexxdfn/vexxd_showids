# Show IDs

Hold a key to see the server ID of every player near you, floating above their head. Standalone: works on any FiveM server with no framework or dependencies.

Support: [discord.gg/TzNJ6Z92Y5](https://discord.gg/TzNJ6Z92Y5)

<img width="767" height="754" alt="image" src="https://github.com/user-attachments/assets/227220a1-6557-4260-af80-6a011dffbe9a" />
<img width="478" height="572" alt="image" src="https://github.com/user-attachments/assets/8d38f580-cc10-4356-8b1e-257d3c51e8e2" />



## Features

- Hold **G** to show IDs, release to hide them
- IDs turn green while that player is talking
- Hidden behind walls, so it can't be used to spot people through cover
- Hidden for invisible players, such as staff in noclip
- Shows your own ID too (optional)
- Players can rebind the key in Settings > Key Bindings > FiveM
- Uses nothing while the key isn't held

## Install

1. Put the `vexxd_showids` folder in your resources.
2. Add `ensure vexxd_showids` to `server.cfg`.
3. Restart the server.

## Config

The settings are at the top of `client.lua`.

| Setting | Default | What it does |
|---|---|---|
| `key` | `'G'` | Default key. Players can rebind it themselves |
| `radius` | `20.0` | How far away IDs are shown |
| `showSelf` | `true` | Show your own ID |
| `requireLineOfSight` | `true` | Hide IDs of players behind walls |
| `hideInvisible` | `true` | Hide IDs of invisible players |
| `talkingColor` | green | Colour of an ID while that player is talking |
| `refreshMs` | `200` | How often the nearby player list is rebuilt |
