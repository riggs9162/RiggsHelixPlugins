PLUGIN.name = "Player Scanners Util"
PLUGIN.author = "Chessnut, Riggs"
PLUGIN.description = "Adds functions that allow players to control scanners."

if (CLIENT) then
	PLUGIN.PICTURE_WIDTH = 580
	PLUGIN.PICTURE_HEIGHT = 420
end

ix.util.Include("sv_photos.lua")
ix.util.Include("cl_photos.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")