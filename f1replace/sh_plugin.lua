local PLUGIN = PLUGIN

PLUGIN.name = "F1 Menu Replace"
PLUGIN.description = "Replaces the TAB key for the Tab Menu to the F1 key."
PLUGIN.author = "Reece™"

function PLUGIN:ScoreboardShow()
    return false
end

ix.util.Include("cl_plugin.lua")