local PLUGIN = PLUGIN

PLUGIN.name = "Immersive Firstperson"
PLUGIN.description = "Adds a Plugin which lets you view your full body and on your head."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ix.option.Add("FirstPersonEnable", ix.type.bool, false, {
    category = "First Person",
    phrase = "First Person Enable"
})

ix.option.Add("FullBody", ix.type.bool, false, {
    category = "First Person",
    phrase = "Full Body"
})

function PLUGIN:CalcView(ply, origin, angles, fov)
    local view = {
        origin = origin,
        angles = angles,
        fov = 90,
        drawviewer = true
    }
    local head = ply:LookupAttachment("eyes")
    head = ply:GetAttachment(head)
    if not head or not head.Pos then return end
    if IsValid(ix.gui.menu) or IsValid(ix.gui.characterMenu) then return end
    if not ix.option.Get("FirstPersonEnable", false) then return end
    if (ply:GetMoveType() == MOVETYPE_NOCLIP) then return end

    if not ply.BonesRattled then
        ply.BonesRattled = true

        ply:InvalidateBoneCache()
        ply:SetupBones()

        local matrix

        for bone = 0, (ply:GetBoneCount() or 1) do
            if ply:GetBoneName(bone):lower():find("head") then
                matrix = ply:GetBoneMatrix(bone)
                break
            end
        end

        if IsValid(matrix) then
            matrix:SetScale(Vector(0, 0, 0))
        end
    end

    view.origin = head.Pos + head.Ang:Up()
    if ix.option.Get("FullBody", false) then
        view.angles = head.Ang
    else
        view.angles = Angle(head.Ang.p, head.Ang.y, angles.r)
    end

    return view
end
