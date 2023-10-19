local PLUGIN = PLUGIN

PLUGIN.name = "Hint System"
PLUGIN.description = "Adds hints which might help you every now and then."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2023 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ix.lang.AddTable("english", {
    optHints = "Toggle hints",
    optHintsSound = "Toggle hints Sound",
    optHintsDelay = "Hints delay",
    optdHints = "Wether or not hints should be shown.",
    optdHintsSound = "Wether or not hints should play a sound.",
    optdHintsDelay = "The delay between hints.",
})

ix.option.Add("hints", ix.type.bool, true, {
    category = "Hint System",
    default = true,
})

ix.option.Add("hintsSound", ix.type.bool, true, {
    category = "Hint System",
    default = true,
})

ix.option.Add("hintsDelay", ix.type.number, 300, {
    category = "Hint System",
    min = 30,
    max = 1800,
    decimals = 1,
    default = 300,
})

ix.hints = ix.hints or {}
ix.hints.stored = ix.hints.stored or {}

function ix.hints.Register(message)
    table.insert(ix.hints.stored, message)
end

ix.hints.Register("Don't drink the water; they put something in it, to make you forget.")
ix.hints.Register("Bored? Try striking up a conversation with someone or creating a plot!")
ix.hints.Register("The staff are here to help you. Show respect and cooperate with them and everyone will benefit from it.")
ix.hints.Register("Running, jumping, and other uncivil actions can result in re-education by Civil Protection.")
ix.hints.Register("The Combine don't like it when you talk, so whisper.")
ix.hints.Register("Life is bleak in the city without companions. Go make some friends.")
ix.hints.Register("Remember: This is a roleplay server. You are playing as a character- not as yourself.")
ix.hints.Register("The city is under constant surveillance. Be careful.")
ix.hints.Register("Don't mess with the Combine, they took over Earth in 7 hours.")
ix.hints.Register("Cause too much trouble and you may find yourself without a ration, or worse.")
ix.hints.Register("Your designated inspection position is your room. Don't forget!")
ix.hints.Register("If you're looking for a way to get to a certain location, it's not a bad idea to ask for help.")
ix.hints.Register("Report crimes to Civil Protection to gain loyalty points on your record.")
ix.hints.Register("Type .// before your message to talk out of character locally.")
ix.hints.Register("Obey the Combine, you'll be glad that you did.")
ix.hints.Register("Civil Protection is protecting civilized society, not you.")
ix.hints.Register("Why don't you try cooking something every now and then? All you need is a stove and the right ingredients.")
ix.hints.Register("Don't piss off Civil Protection, or you'll find yourself being re-educated, or worse..")

if ( CLIENT ) then
    surface.CreateFont("HintFont", {
        font = "Arial",
        size = 20,
        weight = 500,
        blursize = 0.5,
        shadow = true,
    })
    
    local nextHint = 0
    local hintEndRender = 0
    local bInHint = false
    local hint = nil
    local hintShow = false
    local hintAlpha = 0
    function PLUGIN:HUDPaint()
        if not ( ix.option.Get("hints", true) ) then return end

        if ( nextHint < CurTime() ) then
            hint = ix.hints.stored[math.random(#ix.hints.stored)]
            nextHint = CurTime() + ( ix.option.Get("hintsDelay") or math.random(60,360) )
            hintShow = true
            hintEndRender = CurTime() + 15

            if ( ix.option.Get("hintsSound", true) ) then
                LocalPlayer():EmitSound("ui/hint.wav", 40, 100, 0.1)
            end
        end
    
        if not ( hint ) then return end
    
        if ( hintEndRender < CurTime() ) then
            hintShow = false
        end
    
        if ( hintShow == true ) then
            hintAlpha = Lerp(0.01, hintAlpha, 255)
        else
            hintAlpha = Lerp(0.01, hintAlpha, 0)
        end
        
        draw.DrawText(hint, "HintFont", ScrW() / 2, 0, ColorAlpha(color_white, hintAlpha), TEXT_ALIGN_CENTER)
    end
end