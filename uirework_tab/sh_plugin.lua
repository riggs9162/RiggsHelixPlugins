local PLUGIN = PLUGIN

PLUGIN.name = "User Interface Rework (Tab Menu)"
PLUGIN.description = ""
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"

ix.config.Add("tabMenuTitle", false, "Wether or not there should be titles on tabs within the tab menu. (NOTE: THIS CAN BE BUGGY ON PLUGINS THAT ADD CUSTOM TABS)", function()
    if ( CLIENT ) then
        ix.util.Notify("Reopen the tab menu!")
    end
end, {
    category = "Appearance (User Interface)",
})