# SM-RestoreOldEncryptors
This is a scrap mechanic **File mod** that restores the old functionality of the Encryptor & Protector before they were removed in the first public release of survival

I dont have accsess to any of the survival early accsess files, this was put together from screenshots from "https://scrapmechanic.fandom.com/wiki/Encryptor" and old code and descriptions left in by the devs

### Current working versions (Tested)
- 0.7.3 (Latest as of may 2025)

## Details
Functionality on decryping and encrpting is handeld though leftover code, I have reformated it to fix bugs including permantly encrypting things.

The warehouse rooms encryptor have been restored to what they used to look like (Check Wiki Screenshots). Scrap mechanic dosent allow you to edit the prefab files in any way otherwise it just crashed so to workourd this i have editied the file to change nothing apart from which blueprint it is pointing to (by keeping the name the same charecter length) (This was though a hex editor) and created almost blank blueprints that contain one piece of glass that is 40 blocks raised. To provide details on the podiums themselves i simiply edited them with the added details.
> Due to this process there are singular glass blocks somewhere in the warehouse celiling XD

The battery functionality is from the description of the part which mensions it. It currently drains one battery every 5 seconds (which may be ajusted in the future) and the encryptor itself can be controlled by a logic input and it has a logic output.

This mod is a file mod due to the fact that the blueprints and prefabs that make up the warehouses are only stored in your survival folder and custom game dosent have any independent way of adjusting them.

## Installation
In the release there are two folders, the one labeled [Dev] has g_survivalDev = true included. If you do not know which one to use, use the non dev one. For now ignore the Uninstall folder
1. Go to steam and click on Scrap Mechanic
2. On the right side of the screen hit the ⚙ icon then go to Manage > Browse Local Files
3. In another file exporer window Download and Exract the mod files
4. Drag and Merge the files. Make sure you copy the mod files into the game files
5. You will need to replace 7 files

## Unistall
In the release there is unistall folder download and extract that.
Merge the files from the uninstall folder with your game files. (Repeat the steps from the install guide)
Custom Files will remain however they will be inactive. If you do not want these:
1. Go to scrap mechanic on steam
2. On the right side of the screen hit the ⚙ icon then go to Properies, This will open up a new window
3. On the left go to Installed Files > Verify integrity of game files.
