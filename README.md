# SM-RestoreOldEncryptors
This is a scrap mechanic **File mod** that restores the old functionality of the Encryptor & Protector before they were removed in the first public release of survival

I don't have access to any of the survival early access files, this was put together from screenshots from "https://scrapmechanic.fandom.com/wiki/Encryptor" and old code and descriptions left in by the devs

### Current working versions
- 0.7.3 (Latest as of may 2025)
- 0.7+ (Assuming where 0.6.6 works)
- 0.6.6

This is my first project modding project & working with lua so there may be bugs (even with it being relatively small) please put any issues in the issues, I don't want to release a half baked project.

## Details
Functionality on decrypting and encrypting is handled through leftover code, I have reformatted it to fix bugs including permanently encrypting things.

The warehouse rooms encryptor have been restored to what they used to look like (Check Wiki Screenshots). Scrap mechanic doesn't allow you to edit the prefab files in any way otherwise it just crashed so to workaround this i have edited the file to change nothing apart from which blueprint it is pointing to (by keeping the name the same character length) (This was though a hex editor) and created almost blank blueprints that contain one piece of glass that is 40 blocks raised. To provide details on the podiums themselves I simply edited them with the added details.
> Due to this process there are singular glass blocks somewhere in the warehouse ceiling XD

The battery functionality is from the description of the part which mentions it. It currently drains one battery every 5 seconds (which may be adjusted in the future) and the encryptor itself can be controlled by a logic input and it has a logic output.

This mod is a file mod due to the fact that the blueprints and prefabs that make up the warehouses are only stored in your survival folder and the custom game doesn't have any independent way of adjusting them.

## Installation
In the release there are two folders, the one labelled [Dev] has g_survivalDev = true included. If you do not know which one to use, use the non dev one. For now ignore the Uninstall folder
1. Go to steam and click on Scrap Mechanic
2. On the right side of the screen hit the ⚙ icon then go to Manage > Browse Local Files
3. In another file explorer window Download and Extract the mod files
4. Drag and Merge the files. Make sure you copy the mod files into the game files
5. You will need to replace 7 files

## Uninstall
In the release there is uninstall folder download and extract that.
Merge the files from the uninstall folder with your game files. (Repeat the steps from the install guide)
Custom Files will remain however they will be inactive. If you do not want these:
1. Go to scrap mechanic on steam
2. On the right side of the screen hit the ⚙ icon then go to Properties, This will open up a new window
3. On the left go to Installed Files > Verify integrity of game files.
