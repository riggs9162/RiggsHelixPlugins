local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character, oldCharacter) -- does currentChar represent the previous character? :troll:
    if ( character ) then
        character:SetFaction(FACTION_UNASSIGNED)
    end

    if ( oldCharacter ) then
        oldCharacter:SetFaction(FACTION_UNASSIGNED)
    end
end
