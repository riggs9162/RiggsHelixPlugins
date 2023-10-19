local PLUGIN = PLUGIN

PLUGIN.name = "Drop All Money On Death"
PLUGIN.description = ""
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2023 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

if ( CLIENT ) then
    return
end

function PLUGIN:DoPlayerDeath(ply, inflicter, attacker)
    local char = ply:GetCharacter()

    if not ( char ) then
        return
    end

    if not ( char:GetMoney() == 0 ) then
        local droppedTokens = ents.Create("ix_money")
        droppedTokens:SetModel(ix.currency.model)
        droppedTokens:SetPos(ply:GetPos())
        droppedTokens:SetAngles(ply:GetAngles())
        droppedTokens:SetAmount(char:GetMoney())
        droppedTokens:Spawn()

        char:SetMoney(0)                                 
    end
end