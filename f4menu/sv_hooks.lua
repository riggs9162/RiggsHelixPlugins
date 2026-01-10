local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, oldChar, char)
    if ( oldChar ) then
        oldChar:SetFaction(FACTION_UNASSIGNED)
    end

    if ( char ) then
        char:SetFaction(FACTION_UNASSIGNED)
    end
end
