local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    if ( char:HasFlags("v") ) then
        ply.ixAllowVoice = true
    else
        ply.ixAllowVoice = nil
    end
end

function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
    if ( !listener.ixAllowVoice ) then
        return false
    end
end