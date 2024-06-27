local PLUGIN = PLUGIN

PLUGIN.name = "Blacklisted Words"
PLUGIN.description = "Prevents players from sending messages with blacklisted words."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2024 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

if ( CLIENT ) then
    return
end

PLUGIN.words = {}
PLUGIN.words["chink"] = true
PLUGIN.words["coon"] = true
PLUGIN.words["cracker"] = true
PLUGIN.words["cunt"] = true
PLUGIN.words["dyke"] = true
PLUGIN.words["fag"] = true
PLUGIN.words["faggot"] = true
PLUGIN.words["gook"] = true
PLUGIN.words["heeb"] = true
PLUGIN.words["jap"] = true
PLUGIN.words["kike"] = true
PLUGIN.words["negro"] = true
PLUGIN.words["nigg"] = true
PLUGIN.words["porchmonkey"] = true
PLUGIN.words["retard"] = true
PLUGIN.words["sandnigger"] = true
PLUGIN.words["shemale"] = true
PLUGIN.words["slut"] = true
PLUGIN.words["spic"] = true
PLUGIN.words["towelhead"] = true
PLUGIN.words["tranny"] = true
PLUGIN.words["wetback"] = true
PLUGIN.words["whore"] = true
PLUGIN.words["wop"] = true
PLUGIN.words["zipperhead"] = true

ix.log.AddType("blacklistedWord", function(ply, word, text)
    local format = "%s has attempted to send a message with the blacklisted word \"%s\" (%s)."
    format = format:format(ply:GetName(), word, text)

    return format
end)

function PLUGIN:PrePlayerMessageSend(ply, chatType, text)
    for k, v in pairs(self.words) do
        if ( ix.util.StringMatches(text, k) ) then
            ix.log.Add(ply, "blacklistedWord", v, text)
            return false
        end
    end
end