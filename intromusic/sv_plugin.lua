local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, char, oldChar)
    local music = PLUGIN.introMusic[ix.option.Get(client, "introMusic", "hl1")].citizenMusic
    if ( char:IsCombine() ) then
        music = PLUGIN.introMusic[ix.option.Get(client, "introMusic", "hl1")].combineMusic
    end

    client:ConCommand("play " .. table.Random(music))
end
