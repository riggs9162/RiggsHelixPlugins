local PLUGIN = PLUGIN

net.Receive("ixSetAnimClasses", function(len)
    PLUGIN.stored = net.ReadTable()

    for k, v in ipairs(PLUGIN.stored) do
        local modelTable = ix.anim.GetModelClass(k)
        if not ( modelTable ) then
            ix.anim.SetModelClass(k, v)
        end
    end
end)