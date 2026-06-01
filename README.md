Piyo Camera Height Fix | FiveM

Open source script to correct camera height for child peds. Free to use and available on GitHub and the Piyo Store. Place fxmanifest.lua and ped_config.lua in the resource root and update the ped name in PED_MODEL_NAME.

Files included
-fxmanifest.lua
-ped_config.lua

Installation
Copy fxmanifest.lua and ped_config.lua to the resource root.
Open ped_config.lua and edit the line below, replacing the example with the exact ped name used on your server:

.lua
local PED_MODEL_NAME = "ped_name"
Save the files.

Restart the resource or the server.

Configuration
To fine tune the camera, edit the values in CAM_SETTINGS_PED and CAM_SETTINGS_VEHICLE inside ped_config.lua.

The script automatically detects whether the player is on foot or in a vehicle and applies the corresponding settings.

Usage rules
Open source: the script is public and accessible to anyone.

Do not sell or monetize this script. Do not claim it as your own work.

Misuse may result in the responsible account being added to a community blacklist and losing support privileges.

Support and license
Free support: open a ticket in the Piyo Store Discord: https://discord.gg/Nc6XjRFBnw.

Final note  
Place both files in the resource root, update PED_MODEL_NAME, and restart the resource to apply the camera correction.
