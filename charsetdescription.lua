local PLUGIN = PLUGIN

PLUGIN.name = "Set Description Command"
PLUGIN.description = "Allows admins to forcefully set a description for a character."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ix.lang.AddTable("english", {
    cmdCharSetDescription = "Changes someone's description to the specified description.",
    cChangeDescription = "%s changed %s's description to %s.",
    chgDescription = "Change Description",
    chgDescriptionDesc = "Enter the character's new description below.",
})

ix.command.Add("CharSetDescription", {
    description = "@cmdCharSetDescription",
    adminOnly = true,
    arguments = {
        ix.type.character,
        bit.bor(ix.type.text, ix.type.optional)
    },
    OnRun = function(self, ply, target, newDescription)
        // display string request panel if no description was specified
        if ( newDescription:len() == 0 ) then
            return ply:RequestString("@chgDescription", "@chgDescriptionDesc", function(text)
                ix.command.Run(ply, "CharSetDescription", {target:GetName(), text})
            end, target:GetName())
        end

        for _, v in player.Iterator() do
            if ( self:OnCheckAccess(v) or v == target:GetPlayer() ) then
                v:NotifyLocalized("cChangeDescription", ply:GetName(), target:GetName(), newDescription)
            end
        end

        target:SetDescription(newDescription:gsub("#", "#​"))
    end
})