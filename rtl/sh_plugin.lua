local PLUGIN = PLUGIN

PLUGIN.name = "Real Time Lighting"
PLUGIN.description = "Implements a simple real time lighting system which supports Simple Weather and StormFox2." // this has only been tested with simple weather, simple weather is giga chad. Also only supports maps with env_sun entities.
PLUGIN.author = "Reece™"

// r_farz needs to be 100000 if there is black skies sometimes. command requires sv_cheats sadly.
RunConsoleCommand("r_flashlightdepthres", "8192")

ix.option.Add("realTimeLightingEnabled", ix.type.bool, true, {
    category = "Real Time Lighting",
    default = true,
})

ix.util.Include("cl_plugin.lua")