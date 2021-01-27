for _, ud in pairs (UnitDefs) do
    if ud.cloakcost then
        ud.cloakcost = 0
        ud.canCloak = true
    end
    if ud.cloakcostmoving then
        ud.cloakcostmoving = 0
        ud.canCloak = true
    end
    if ud.energyCost then
        ud.energyCost = 0
    end

    if ud.weapondefs then
        for _, wd in pairs(ud.weapondefs) do
            if wd.energyCost then
                wd.energyCost = 0
            end
            if wd.shieldEnergyUse then
                wd.shieldEnergyUse = 0
            end

            if wd.shieldPowerRegenEnergy then
                wd.shieldPowerRegenEnergy = 0
            end
        end
    end
end
