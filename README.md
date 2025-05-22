# SM-RestoreOldEncryptors
This is a personal project where I restore the functionality of the encryptors in scrap mechanic.

The current files just restore the functionality to the encryptors themselves nothing else additinal
There are two folders one labled [Dev], this has G_SurvivalDev = true included if you want otherwise use the regular version

## Current Progress 22/05/2025
Fun Fact today is the 5th year anavarsary of me owning and playing the game (and now i have over 800 hours)
### Done:
- Restored Animations
- Restored Old Functionality
- Modified to fix Encrypor State Syncing when destoryed
- Modified to fix Encrypor State Syncing when detached from creation
Checks:
    - On TNT Blowup
    - On Player Remove
    - On Unload
    - Applies in warehouse
### Todo:
- Restore Old Encryptor / Protector Room in Warehouse (See Lower)
- Add the battery funtionality taked about in description

### Restoring the Old Encryptor / protector room in warehouse
Current Issue: Game crashed when loading moddified prefab
- Warehouse world are made up of the "tile" stored in Survival/DungeonTiles, these hold the data todo with the "Prefabs" that make up the warehouse layout (as far as i can tell)
- The "Prefabs" that make up the "tile" are stored in Survival/LocalPrefabs, these hold the data todo with the "blueprints" that make up the "Prefab" (as far as i can tell)
    - The "Prefabs" use the file extension .PREFAB which A: is not read by the built in SM Tile editor & B: is not a JSON (or other readable) format & C: is not a tile in disquise by chaning the exrension to .tile
- The "Blueprints" hold the Shapes/Parts (I have not looked in to this anymore)

I have figured out that i would need to edit the prfab and which blueprints in the prefab that cover up the old encryptor area. Alongside that using the images off "https://scrapmechanic.fandom.com/wiki/Encryptor" i would want to add the missing parts.
Currently I cannot change the warehouse prefab as any changes i do lead to it being a crash, so far i have tried:
- [Crash] - Opening the Warehouse tile and navigating to the prefab in the creative tile editor > Requires Creative mod that adds survival parts
- [Crash] - Opening the Warehouse tile and navigating to the prefab in the custom gamemode tile editor though the mod tool
- [Crash] - Using a hex editor and manualy searching for the blueprints to remove
- [Intended Behaviour] - Swapping the Prefab with another of the same size and renaming it.

Other key notes:
- to get all of the survival specific stuff in the tile editor:
  1. use the mod manager
  2. custom game (survival template)
  3. editor
  4. tile editor
  5. open tile (scroll to bottom)
  6. third "Warehouse interior" at the top
  7. Object list: Search Pipe
  8. Open prefab.
- the blueprints covering up the old layout are the only ones in that prefab, they are:
    - kit_warehouse_storage_2ndFloor_Filler
    - kit_warehouse_storage_ceiling_8x8
    - kit_warehouse_utilityclutter_ducts_bracket
    - kit_warehouse_storage_wall_middle_x32
