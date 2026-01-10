local PLUGIN = PLUGIN

function PLUGIN:CalcMainActivity(client, vel)
    if ( IsValid(client) and not client:IsWepRaised() ) then
        if not ( client:IsOnGround() ) then
            return
        end

        if not ( IsValid(client:GetActiveWeapon()) ) then
            return
        end

        if not ( self.moodAffectedWeapons[client:GetActiveWeapon():GetClass()] ) then
            return
        end
        
        local char = client:GetCharacter()
        if not ( char ) then
            return
        end

        local class = ix.anim.GetModelClass(client:GetModel())
        local moodData = self.moods[class]
        if not ( moodData ) then
            return
        end

        moodData = moodData[char:GetMood()]
        if not ( moodData ) then
            return
        end

        moodData = moodData[client.CalcIdeal]
        if not ( moodData ) then
            return
        end

        local sequence = moodData
        if not ( client:LookupSequence(sequence) ) then
            return
        end

        client.CalcSeqOverride = client:LookupSequence(sequence) or client.CalcSeqOverride
    end
end
