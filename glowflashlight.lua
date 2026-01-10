local PLUGIN = PLUGIN

PLUGIN.name = "Glow Flashlight"
PLUGIN.description = "Replaces the default Gmod Flashlight with a glowy light."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2026 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

if ( CLIENT ) then
    function PLUGIN:PostDrawOpaqueRenderables()
        local client = LocalPlayer()
        if ( !client:GetNetVar("flashlight") ) then return end

        local flashlight = DynamicLight(client:EntIndex())
        if ( flashlight ) then
            flashlight.pos = client:GetShootPos()
            flashlight.r = 255
            flashlight.g = 255
            flashlight.b = 255
            flashlight.brightness = 2
            flashlight.Decay = 1000
            flashlight.Size = 256
            flashlight.DieTime = CurTime() + 1
        end
    end
end

if ( SERVER ) then
    function PLUGIN:Initialize(client)
        client:SetNetVar("flashlight", false)
    end

    function PLUGIN:PlayerSpawn(client)
        client:SetNetVar("flashlight", false)
    end

    function PLUGIN:CharacterLoaded(character)
        local client = character:GetPlayer()
        client:SetNetVar("flashlight", false)
    end

    function PLUGIN:PlayerSwitchFlashlight(client, enabled)
        client:SetNetVar("flashlight", !client:GetNetVar("flashlight", false))

        if ( client:GetNetVar("flashlight", true) ) then
            client:EmitSound("buttons/button24.wav", 60, 100)
        else
            client:EmitSound("buttons/button10.wav", 60, 70)
        end

        return false
    end
end
