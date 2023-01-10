local PLUGIN = PLUGIN

function PLUGIN:CharacterLoaded()
    CRASHSCREEN_ALLOW = true
end

local lastServerData1
local lastServerData2
local nextCrashThink = 0
local nextCrashAnalysis
local crashAnalysisAttempts = 0

function PLUGIN:Think()
    if not SERVER_DOWN and nextCrashAnalysis and nextCrashAnalysis < CurTime() then
        nextCrashAnalysis = CurTime() + 0.05

        local a, b = engine.ServerFrameTime()

        if (crashAnalysisAttempts or 0) <= 15 then
            if a != (lastServerData1 or 0) or b != (lastServerData2 or 0) then
                nextCrashAnalysis = nil
                crashAnalysisAttempts = 0
                return
            end

            crashAnalysisAttempts = crashAnalysisAttempts + 1

            if crashAnalysisAttempts == 15 then
                nextCrashAnalysis = nil
                crashAnalysisAttempts = 0
                SERVER_DOWN = true
            end
        else
            nextCrashAnalysis = nil
            crashAnalysisAttempts = 0
        end

        lastServerData1 = a
        lastServerData2 = b
    end

    if ( nextCrashThink or 0 ) < CurTime() then
        nextCrashThink = CurTime() + 0.66

        local a, b = engine.ServerFrameTime()

        if a == (lastServerData1 or 0) and b == (lastServerData2 or 0) then
            nextCrashAnalysis = CurTime()
        else
            SERVER_DOWN = false
            nextCrashAnalysis = nil
        end

        lastServerData1 = a
        lastServerData2 = b
    end
end

function PLUGIN:HUDPaint()
    if ( SERVER_DOWN and CRASHSCREEN_ALLOW ) then
        if not ( IsValid(CRASH_SCREEN) ) then
            CRASH_SCREEN = vgui.Create("ixCrashScreen")
        end
    elseif ( IsValid(CRASH_SCREEN) ) and not ( CRASH_SCREEN.fadin ) then
        CRASH_SCREEN.fadin = true
        CRASH_SCREEN:AlphaTo(0, 1.2, nil, function()
            if ( IsValid(CRASH_SCREEN) ) then
                CRASH_SCREEN:Remove()
            end
        end)
    end
end