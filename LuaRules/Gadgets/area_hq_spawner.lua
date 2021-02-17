function gadget:GetInfo()
    return {
        name = "ArenaHQSpawner",
        desc = "Replaced Commander with Area HQ",
        author = "petturtle",
        date = "2020",
        layer = 0,
        enabled = true
    }
end

if not gadgetHandler:IsSyncedCode() then
    return false
end

local function replaceStartUnit(unitName)
    local replacements = {}
    local hqRadius = 64
    for teamID, spawn in pairs(GG.CommanderSpawnLocation) do
        local _teamID, leader, isDead, isAiTeam = Spring.GetTeamInfo(teamID)
        if _teamID and not isAiTeam then
            local x = math.max(hqRadius, math.min(Game.mapSizeX - hqRadius, spawn.x))
            local z = math.max(hqRadius, math.min(Game.mapSizeZ - hqRadius, spawn.z))
            local y = Spring.GetGroundHeight(x, z)
            local nearbyUnits = Spring.GetUnitsInCylinder(spawn.x, spawn.z, 50, teamID)
            local unitID = Spring.CreateUnit(unitName, x, y, z, spawn.facing, teamID)
            Spring.SetUnitRulesParam(unitID, "facplop", 1, {inlos = true})
            Spring.AddTeamResource(teamID, "metal", 300)
            table.insert(replacements, unitID)
            if nearbyUnits and #nearbyUnits then
                for _, unitID in pairs(nearbyUnits) do
                    Spring.DestroyUnit(unitID, false, true)
                end
            end
        end
    end
    return replacements
end

function gadget:GameStart()
    local HQs = replaceStartUnit("arena_hq")
    for _, HQID in pairs(HQs) do
        GG.ADDHQ(HQID)
    end
end