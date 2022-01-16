local PLUGIN = PLUGIN

PLUGIN.name = "Gnome Killer"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "Allows you to kill gnome props, and make a high pitched scream."

local gnomeClasses = {
    ["prop_physics"] = true,
    ["ix_item"] = true,
}
function PLUGIN:EntityTakeDamage(ent)
    if ( gnomeClasses[ent:GetClass()] ) then
        if ( ent:GetModel():find("gnome") ) then
            ent:EmitSound("vo/npc/male01/pain0"..math.random(1,9)..".wav", 75, 150)
            ent:Remove()
        end
    end
end
