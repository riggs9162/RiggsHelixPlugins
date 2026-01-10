local PLUGIN = PLUGIN

-- messy but idc.
function PLUGIN:SearchLootContainer(ent, client)
    if not ( ( client.IsCombine and client:IsCombine() ) or ( client.IsDispatch and client:IsDispatch() ) ) then
        if not ent.containerAlreadyUsed or ent.containerAlreadyUsed <= CurTime() then
            if not ( client.isEatingConsumeable == true ) then -- support for my plugin
                local randomChance = math.random(1,20)
                local randomAmountChance = math.random(1,3)
                local lootAmount = 1

                local randomLootItem = table.Random(PLUGIN.randomLoot.common)
                if ( randomAmountChance == 3 ) then
                    lootAmount = math.random(1,3)
                else
                    lootAmount = 1
                end

                client:Freeze(true)
                client:SetAction("Searching...", 5, function()
                    client:Freeze(false)
                    for i = 1, lootAmount do
                        if (randomChance == math.random(1,20)) then
                            randomLootItem = table.Random(PLUGIN.randomLoot.rare)
                            client:ChatNotify("You have gained " .. ix.item.Get(randomLootItem):GetName() .. ".")
                            client:GetCharacter():GetInventory():Add(randomLootItem)
                        else
                            randomLootItem = table.Random(PLUGIN.randomLoot.common)
                            client:ChatNotify("You have gained " .. ix.item.Get(randomLootItem):GetName() .. ".")
                            client:GetCharacter():GetInventory():Add(randomLootItem)
                        end
                    end
                end)
                ent.containerAlreadyUsed = CurTime() + 180
            else
                if not ent.ixContainerNotAllowedEat or ent.ixContainerNotAllowedEat <= CurTime() then
                    client:Notify("You cannot loot anything while you are eating!")
                    ent.ixContainerNotAllowedEat = CurTime() + 1
                end
            end
        else
            if not ent.ixContainerNothingInItCooldown or ent.ixContainerNothingInItCooldown <= CurTime() then
                client:ChatNotify("There is nothing in the container!")
                ent.ixContainerNothingInItCooldown = CurTime() + 1
            end
        end
    else
        if not ent.ixContainerNotAllowed or ent.ixContainerNotAllowed <= CurTime() then
            client:ChatNotify("Your Faction is not allowed to loot containers.")
            ent.ixContainerNotAllowed = CurTime() + 1
        end
    end
end

function Schema:SpawnRandomLoot(position, rareItem)
    local randomLootItem = table.Random(PLUGIN.randomLoot.common)

    if (rareItem == true) then
        randomLootItem = table.Random(PLUGIN.randomLoot.rare)
    end

    ix.item.Spawn(randomLootItem, position)
end
