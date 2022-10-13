local PLUGIN = PLUGIN

PLUGIN.name = "F1 Menu Replace"
PLUGIN.description = ""
PLUGIN.author = "Reece™"

function PLUGIN:ScoreboardShow()
    return false
end

ix.util.Include("cl_plugin.lua")