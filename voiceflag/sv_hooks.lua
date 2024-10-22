local PLUGIN = PLUGIN

function PLUGIN:OnCharacterCreated(ply, char)
    if ( ix.config.Get("giveOnCreate") ) then
        if ( !char:HasFlags("v") ) then
            char:GiveFlags("v")
        end
    end
end

function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    local ply_table = ply:GetTable()
    if ( char:HasFlags("v") ) then
        ply_table.ixAllowVoice = true
    else
        ply_table.ixAllowVoice = nil
    end
end

function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
    if ( !ix.config.Get("allowVoice") ) then return end

    local talker_table = talker:GetTable()
    if ( !talker_table.ixAllowVoice ) then
        return false
    end
end