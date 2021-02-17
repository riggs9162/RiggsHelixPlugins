local PLUGIN = PLUGIN

PLUGIN.name = "Gnome Killer"
PLUGIN.author = "ZIKE"
PLUGIN.description = "Allows you to kill gnome props, and make a high pitched scream. :)"

function PLUGIN:EntityTakeDamage(ent, dmg)
    if isentity(ent) then
    	if ent:GetModel() == "models/props_junk/gnome.mdl" then
    		ent:EmitSound("vo/npc/male01/pain0"..math.random(1,9)..".wav", 75, 150)
    		ent:Remove()
    	end
	end
end