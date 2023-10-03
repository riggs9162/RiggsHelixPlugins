local PLUGIN = PLUGIN

function PLUGIN:CalcMainActivity(ply, vel)
    if ( IsValid(ply) and not ply:IsWepRaised() ) then
        if not ( ply:IsOnGround() ) then
            return
        end

        if not ( IsValid(ply:GetActiveWeapon()) ) then
            return
        end

        if not ( self.moodAffectedWeapons[ply:GetActiveWeapon():GetClass()] ) then
            return
        end
        
        local char = ply:GetCharacter()
        if not ( char ) then
            return
        end

        local class = ix.anim.GetModelClass(ply:GetModel())
        local moodData = self.moods[class]
        if not ( moodData ) then
            return
        end

        moodData = moodData[char:GetMood()]
        if not ( moodData ) then
            return
        end

        moodData = moodData[ply.CalcIdeal]
        if not ( moodData ) then
            return
        end

        local sequence = moodData
        if not ( ply:LookupSequence(sequence) ) then
            return
        end

        ply.CalcSeqOverride = ply:LookupSequence(sequence) or ply.CalcSeqOverride
    end
end