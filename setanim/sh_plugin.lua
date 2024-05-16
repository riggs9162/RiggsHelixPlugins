local PLUGIN = PLUGIN

PLUGIN.name = "Animation Setclass Command"
PLUGIN.description = "Adds a command to set a model's animation class."
PLUGIN.author = "Riggs"
PLUGIN.schema = "Any"

PLUGIN.stored = PLUGIN.stored or {}

ix.command.Add("SetAnimClass", {
    description = "Set a model's animation class.",
    adminOnly = true,
    arguments = {
        ix.type.string,
        bit.bor(ix.type.text, ix.type.optional)
    },
    OnRun = function(self, ply, animClass, model)
        animClass = string.lower(animClass)

        if not ( model ) then
            local traceEnt = ply:GetEyeTrace().Entity
            if not ( IsValid(traceEnt) ) then
                return "You must be looking at a valid entity."
            end

            model = string.lower(traceEnt:GetModel())
        end

        local modelTable = ix.anim.GetModelClass(model)
        if ( modelTable ) then
            ply:Notify("This model already has a custom animation class, overwriting it...")
        end

        if not ( ix.anim[animClass] ) then
            ply:SendLua([[gui.OpenURL("https://docs.gethelix.co/libraries/ix.anim/")]])
            return "This is not a valid animation class."
        end

        ix.anim.SetModelClass(model, animClass)
        PLUGIN.stored[model] = animClass

        // comment: Iterate through all players and set the model to itself to refresh the animation class if it's the same model.
        for k, v in player.Iterator() do
            if ( string.lower(v:GetModel()) != model ) then
                continue
            end

            v:SetModel(v:GetModel())
        end
    end
})

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_hooks.lua")