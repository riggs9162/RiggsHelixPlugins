local PLUGIN = PLUGIN

PLUGIN.name = "Extended Items"
PLUGIN.description = "A Plugin which creates items through 1 lua file."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2023 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local extendeditems = {
    ["tv"] = {
        ["name"] = "Television Monitor",
        ["model"] = "models/props_c17/tv_monitor01.mdl",
        ["desc"] = "A Famous metal box, used to watch shows",
        ["width"] = 3,
        ["height"] = 2,
        ["illegal"] = false
    },
}

local ammoitems = {
    ["pistolammo"] = {
        ["name"] = "Pistol Ammo",
        ["model"] = "models/Items/BoxSRounds.mdl",
        ["desc"] = "A Box containing %s of Pistol Ammo.",
        ["width"] = 1,
        ["height"] = 1,
        ["ammo"] = "pistol",
        ["ammoAmount"] = 30
    },
    ["smg1ammo"] = {
        ["name"] = "Submachine Ammo",
        ["model"] = "models/Items/BoxMRounds.mdl",
        ["desc"] = "A Box containing %s of Submachine Ammo.",
        ["width"] = 1,
        ["height"] = 1,
        ["ammo"] = "smg1",
        ["ammoAmount"] = 45
    },
    ["rifleammo"] = {
        ["name"] = "Rifle Ammo",
        ["model"] = "models/Items/BoxMRounds.mdl",
        ["desc"] = "A Box containing %s of Rifle Ammo.",
        ["width"] = 1,
        ["height"] = 1,
        ["ammo"] = "ar2",
        ["ammoAmount"] = 30
    },
    ["shotgunammo"] = {
        ["name"] = "Shotgun Shells",
        ["model"] = "models/Items/BoxBuckshot.mdl",
        ["desc"] = "A Box containing %s Shotgun Shells.",
        ["width"] = 1,
        ["height"] = 1,
        ["ammo"] = "buckshot",
        ["ammoAmount"] = 15
    },
    ["357ammo"] = {
        ["name"] = "Revolver Ammo",
        ["model"] = "models/items/357ammo.mdl",
        ["desc"] = "A Box containing %s of 357. Ammo.",
        ["width"] = 1,
        ["height"] = 1,
        ["ammo"] = "357",
        ["ammoAmount"] = 12
    },
    ["sniperammo"] = {
        ["name"] = "Sniper Rounds",
        ["model"] = "models/items/357ammo.mdl",
        ["desc"] = "A Box containing %s of Sniper Rounds.",
        ["width"] = 1,
        ["height"] = 1,
        ["ammo"] = "SniperRound",
        ["ammoAmount"] = 8
    },
}

local weaponitems = {
    ["usp"] = {
        ["name"] = "USP Match",
        ["model"] = "models/weapons/w_pistol.mdl",
        ["desc"] = "A 9mm USP Match Pistol commonly used by Civil Protection and other Refugee Humans.",
        ["width"] = 2,
        ["height"] = 1,
        ["isGrenade"] = false,
        ["weaponCategory"] = "pistol",
        ["class"] = "weapon_pistol"
    },
}

for k, v in pairs(extendeditems) do
    local ITEM = ix.item.Register(k, nil, false, nil, true)
    ITEM.name = v.name or "An Undefined Name, please configue items.lua in the plugins folder."
    ITEM.description = v.desc or "An Undefined Description, please configue items.lua in the plugins folder."
    ITEM.model = v.model or "models/hunter/plates/plate025x025.mdl"
    ITEM.width = v.width or 1
    ITEM.height = v.height or 1
    ITEM.price = v.price or 10
    ITEM.category = "Extended Items"
    ITEM.noBusiness = true
    ITEM.bDropOnDeath = true
    
    function ITEM:GetDescription()
        return self.description
    end
    
    function ITEM:PopulateTooltip(tooltip)
        if v.illegal then
            local warning = tooltip:AddRow("warning")
            warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
            warning:SetText("This item is illegal.")
            warning:SetFont("BudgetLabel")
            warning:SetExpensiveShadow(0.5)
            warning:SizeToContents()
        end
    end
end

for k, v in pairs(ammoitems) do
    local ITEM = ix.item.Register(k, "base_ammo", false, nil, true)
    ITEM.name = v.name or "An Undefined Name, please configue items.lua in the plugins folder."
    ITEM.description = v.desc or "An Undefined Description, please configue items.lua in the plugins folder."
    ITEM.model = v.model or "models/hunter/plates/plate025x025.mdl"
    ITEM.width = v.width or 1
    ITEM.height = v.height or 1
    ITEM.price = v.price or 10
    ITEM.category = "Ammo Items"
    ITEM.noBusiness = true
    ITEM.bDropOnDeath = true
    
    ITEM.base = "base_ammo"
    ITEM.useSound = v.useSound or "items/ammo_pickup.wav"
    ITEM.ammo = v.ammo or "pistol"
    ITEM.ammoAmount = v.ammoAmount or 30

    function ITEM:GetDescription()
        return self.description
    end
    
    function ITEM:PopulateTooltip(tooltip)
        local warning = tooltip:AddRow("warning")
        warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
        warning:SetText("This item is illegal.")
        warning:SetFont("BudgetLabel")
        warning:SetExpensiveShadow(0.5)
        warning:SizeToContents()
    end
end

for k, v in pairs(weaponitems) do
    local ITEM = ix.item.Register(k, "base_weapons", false, nil, true)
    ITEM.name = v.name or "An Undefined Name, please configue items.lua in the plugins folder."
    ITEM.description = v.desc or "An Undefined Description, please configue items.lua in the plugins folder."
    ITEM.model = v.model or "models/hunter/plates/plate025x025.mdl"
    ITEM.width = v.width or 1
    ITEM.height = v.height or 1
    ITEM.price = v.price or 10
    ITEM.category = "Weapon Items"
    ITEM.noBusiness = true
    ITEM.bDropOnDeath = true
    
    ITEM.base = "base_weapons"
    ITEM.isWeapon = true
    ITEM.isGrenade = v.isGrenade or false
    ITEM.weaponCategory = v.weaponCategory or "sidearm"
    ITEM.useSound = v.useSound or "items/ammo_pickup.wav"
    ITEM.class = v.class or "weapon_pistol"

    function ITEM:GetDescription()
        return self.description
    end
    
    function ITEM:PopulateTooltip(tooltip)
        local warning = tooltip:AddRow("warning")
        warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
        warning:SetText("This weapon is illegal.")
        warning:SetFont("BudgetLabel")
        warning:SetExpensiveShadow(0.5)
        warning:SizeToContents()
    end
end