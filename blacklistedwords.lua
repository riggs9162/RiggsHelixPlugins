local PLUGIN = PLUGIN

PLUGIN.name = "Blacklisted Words"
PLUGIN.description = ""
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2022 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

PLUGIN.config = {
    "fag",
    "nigg",
}

if ( CLIENT ) then
    return
end

ix.log.AddType("blacklistedWord", function(ply, word, text)
    return "Blacklisted word found from user '"..ply:SteamName().." / "..ply:Nick().."', with the word '"..tostring(word).."' with the message being '"..tostring(text).."'. Prevented from sending!"
end, FLAG_WARNING)

function PLUGIN:PrePlayerMessageSend(ply, chatType, text)
    for k, v in pairs(self.config) do
        if ( string.find(string.upper(text), string.upper(v)) ) then
            ix.log.Add(ply, "blacklistedWord", v, text)
            
            return false
        end
    end
end