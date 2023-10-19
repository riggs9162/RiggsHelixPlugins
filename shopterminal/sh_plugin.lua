local PLUGIN = PLUGIN

PLUGIN.name = "Shop Terminal"
PLUGIN.description = ""
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "HL2 RP"
PLUGIN.license = [[
Copyright 2023 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
PLUGIN.readme = [[
This plugin is a experimental plugin, it shall not be used by people who have zero knowledge of using Helix.
]]

PLUGIN.allowedFactions = {
    [FACTION_CITIZEN] = true,
}

PLUGIN.allowedClasses = {
    --[CLASS_CWU] = true,
}

ix.config.Add("shipmentDeliverMessage", "Your shipment has been successfully bought and has been sent to a nearby warehouse!", "", nil, {
    category = PLUGIN.name,
})

ix.config.Add("shipmentDeliverPositionXValue", "0", "The X Position of where the Shipment would spawn. Get the Y Position by using the /GetXPos command.", nil, {
    category = PLUGIN.name,
})

ix.config.Add("shipmentDeliverPositionYValue", "0", "The Y Position of where the Shipment would spawn. Get the Y Position by using the /GetYPos command.", nil, {
    category = PLUGIN.name,
})

ix.config.Add("shipmentDeliverPositionZValue", "0", "The Z Position of where the Shipment would spawn. Get the Z Position by using the /GetZPos command.", nil, {
    category = PLUGIN.name,
})

ix.command.Add("SetShipmentDeliverPosition", {
    description = "Sets the "..PLUGIN.name.." Shipment Deliver Position.",
    adminOnly = true,
    OnRun = function(self, ply)
        ix.config.Set("shipmentDeliverPositionXValue", ply:GetPos().x)
        ix.config.Set("shipmentDeliverPositionYValue", ply:GetPos().y)
        ix.config.Set("shipmentDeliverPositionZValue", ply:GetPos().z)

        ply:Notify("Successfully Set!")
    end,
})

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")