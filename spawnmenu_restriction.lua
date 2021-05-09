PLUGIN.name = "Spawnmenu Restrictor"
PLUGIN.description = "Restricts people from using the spawnmenu for people who don't have the 'e' flag."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"

if (CLIENT) then
	function PLUGIN:OnSpawnMenuOpen()
		if not LocalPlayer():GetCharacter():HasFlags("e") then
			return false
		end
	end
end