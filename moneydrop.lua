local PLUGIN = PLUGIN

PLUGIN.name = "Money Drop"
PLUGIN.description = "Drops all money on death."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

function PLUGIN:InitializedConfig()
    ix.config.Add("moneyDrop", true, "Whether or not to drop money on death.", nil, {
        category = "Money Drop"
    })

    ix.config.Add("moneyDropAmount", 100, "The amount of money to drop on death. If set to 0, it will drop all money.", nil, {
        data = {min = 0, max = 10000, decimals = 0},
        category = "Money Drop"
    })
end

if ( CLIENT ) then
    return
end

function PLUGIN:DoPlayerDeath(ply, inflicter, attacker)
    if not ( ix.config.Get("moneyDrop") ) then
        return
    end

    local char = ply:GetCharacter()
    if not ( char ) then
        return
    end

    local charMoney = char:GetMoney()
    if ( ix.config.Get("moneyDropAmount") > 0 ) then
        charMoney = math.Clamp(charMoney, 0, ix.config.Get("moneyDropAmount"))
    end

    if not ( charMoney == 0 ) then
        local model, pos, ang = ix.currency.model, ply:GetPos(), ply:GetAngles()
        local ent = ents.Create("ix_money")
        ent:SetModel(model)
        ent:SetPos(pos)
        ent:SetAngles(ang)
        ent:SetAmount(charMoney)
        ent:Spawn()

        char:SetMoney(0)                                 
    end
end