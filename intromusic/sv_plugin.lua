local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    local music = self.introMusic[ix.option.Get(ply, "introMusic", "hl1")].citizenMusic

    if ( char:IsCombine() ) then
        music = self.introMusic[ix.option.Get(ply, "introMusic", "hl1")].combineMusic
    end

    ply:ConCommand("play " .. music[math.random(1, #music)])
end