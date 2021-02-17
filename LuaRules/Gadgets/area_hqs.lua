function gadget:GetInfo()
    return {
        name = "ArenaHQs",
        desc = "Area HQ Logic",
        author = "petturtle",
        date = "2020",
        layer = 0,
        enabled = true
    }
end

if not gadgetHandler:IsSyncedCode() then
    return false
end

local tierSize, tierUnits, tierOdds, levelData = VFS.Include("luaRules/configs/unit_shop_data.lua")
local unitPools = {}

local CMD_HQ_UPGRADE = 49734
local CMD_HQ_REROLL = 49735
local CMD_HQ_BUY = 49736
local CMD_HQ_SELL = 49737
local CMD_HQ_SPAWN = 49738

local LOS_ACCESS = {inlos = true}

local offset = {
	[0] = {x = 1, z = 0},
	[1] = {x = 1, z = 1},
	[2] = {x = 0, z = 1},
	[3] = {x = -1, z = 1},
	[4] = {x = 0, z = -1},
	[5] = {x = -1, z = -1},
	[6] = {x = 1, z = -1},
	[7] = {x = -1, z = 0},
}

local function getRandomUnitForTier(tier)
    local currentPoolSize = 0
    for i = 1, #unitPools[tier] do
        currentPoolSize = currentPoolSize + unitPools[tier][i]
    end

    if currentPoolSize > 0 then
        local ran = math.random(1, currentPoolSize)
        for i = 1, #unitPools[tier] do
            ran = ran - unitPools[tier][i]
            if ran <= 0 then
                unitPools[tier][i] = unitPools[tier][i] - 1
                return tierUnits[tier][i], tier, i
            end
        end
    end

    if tier > 1 then
        return getRandomUnitForTier(tier - 1)
    end
    return -1
end

local function getHQUnitTier(HQLevel)
    local ran = math.random(1, 100)
    local odds = tierOdds[HQLevel]
    ran = ran - odds[1]
    if (ran <= 0) then return 1 end

    ran = ran - odds[2]
    if (ran <= 0) then return 2 end

    ran = ran - odds[3]
    if (ran <= 0) then return 3 end

    ran = ran - odds[4]
    if (ran <= 0) then return 4 end

    ran = ran - odds[5]
    if (ran <= 0) then return 5 end

    return 1
end

local function rerollHQ(unitID)
    local HQLevel = Spring.GetUnitRulesParam(unitID, "HQLevel")
    for i = 1, 5 do
        local oldUD = Spring.GetUnitRulesParam(unitID, "HQBuyUnit" .. i)
        if not (oldUD == -1) then
            local udTier = Spring.GetUnitRulesParam(unitID, "HQBuyUnitTier" .. i)
            local udPoolID = Spring.GetUnitRulesParam(unitID, "HQBuyUnitPoolID" .. i)
            unitPools[udTier][udPoolID] = unitPools[udTier][udPoolID] + 1
        end

        local unitName, tier, poolID = getRandomUnitForTier(getHQUnitTier(HQLevel))
        if not (unitName == -1) then
            local ud = UnitDefNames[unitName].id
            Spring.SetUnitRulesParam(unitID, "HQBuyUnit" .. i, ud, LOS_ACCESS)
            Spring.SetUnitRulesParam(unitID, "HQBuyUnitTier" .. i, tier, LOS_ACCESS)
            Spring.SetUnitRulesParam(unitID, "HQBuyUnitPoolID" .. i, poolID, LOS_ACCESS)
        end
    end
end

local function getHQSpawnPointFor(HQID, ud)
    local tx, ty, tz = Spring.GetUnitPosition(HQID)
	local size = ud.xsize
	local startCheck = math.floor(math.random(8))
	local direction = (math.random() < 0.5 and -1) or 1
	for j = 0, 7 do
		local spot = (j*direction+startCheck)%8
        local sx, sz = tx + offset[spot].x*(size*4+100), tz + offset[spot].z*(size*4+100)
        if ud.canFly then
			return sx, ty, sz
		end

		local place, feature = Spring.TestBuildOrder(ud.id, sx, 0 , sz, 1)

		-- also test move order to prevent getting stuck on terrains with 0 speed mult
		if (place == 2 and feature == nil) and Spring.TestMoveOrder(ud.id, sx, 0, sz, 0, 0, 0, true, true, true) then
			return sx, ty, sz
		end
	end
	return tx, ty, tz 
end

local function spendMetal(metalAmount, teamID)
    local teamMetal = Spring.GetTeamResources(teamID, "metal")
    if teamMetal < metalAmount then
        return false
    end
    Spring.SetTeamResource(teamID, "m", teamMetal - metalAmount)
    return true
end

local function addHQ(unitID)
    Spring.SetUnitRulesParam(unitID, "isHQ", 1, LOS_ACCESS)
    Spring.SetUnitRulesParam(unitID, "HQLevel", 1, LOS_ACCESS)

    for i = 1, 5 do
        Spring.SetUnitRulesParam(unitID, "HQBuyUnit" .. i, -1, LOS_ACCESS)
    end

    for i = 1, 8 do
        Spring.SetUnitRulesParam(unitID, "HQSpawnUnit" .. i, -1, LOS_ACCESS)
        Spring.SetUnitRulesParam(unitID, "HQSpawnUnitCost" .. i, 1, LOS_ACCESS)
        Spring.SetUnitRulesParam(unitID, "HQSpawnUnitCount" .. i, 1, LOS_ACCESS)
    end

    Spring.SetUnitRulesParam(unitID, "HQLevelCost", levelData[1].upgradeCost, LOS_ACCESS)
    Spring.SetUnitRulesParam(unitID, "HQRerollCost", levelData[1].rerollCost, LOS_ACCESS)

    Spring.SetUnitBlocking(unitID, true, false)
    rerollHQ(unitID)
end

local function OnHQUpgrade(HQID, HQTeamID)
    local HQLevel = Spring.GetUnitRulesParam(HQID, "HQLevel")
    if HQLevel < 11 then
        local levelCost = Spring.GetUnitRulesParam(HQID, "HQLevelCost")
        if not spendMetal(levelCost, HQTeamID) then
            return
        end

        Spring.SetUnitRulesParam(HQID, "HQLevel", HQLevel + 1, LOS_ACCESS)
        Spring.SetUnitRulesParam(HQID, "HQLevelCost", levelData[HQLevel + 1].upgradeCost, LOS_ACCESS)
        Spring.SetUnitRulesParam(HQID, "HQRerollCost", levelData[HQLevel + 1].rerollCost, LOS_ACCESS)

        rerollHQ(HQID)
    end
end

local function OnHQReroll(HQID, HQTeamID)
    local rerollCost = Spring.GetUnitRulesParam(HQID, "HQRerollCost")
    if not spendMetal(rerollCost, HQTeamID) then
        return
    end

    rerollHQ(HQID)
end

local function OnHQBuy(HQID, HQTeamID, buyUnitID)
    local ud = Spring.GetUnitRulesParam(HQID, "HQBuyUnit" .. buyUnitID)
    if ud == -1 then
        return
    end

    local unitCost = math.floor(UnitDefs[ud].metalCost)
    if Spring.GetTeamResources(HQTeamID, "metal") < unitCost then
        return
    end

    for i = 1, 8 do
        local udAtI = Spring.GetUnitRulesParam(HQID, "HQSpawnUnit" .. i)
        if udAtI == ud then
            Spring.SetUnitRulesParam(HQID, "HQBuyUnit" .. buyUnitID, -1, LOS_ACCESS)

            local count = Spring.GetUnitRulesParam(HQID, "HQSpawnUnitCount" .. i)
            local metalCost = UnitDefs[ud].metalCost
            Spring.SetUnitRulesParam(HQID, "HQSpawnUnitCount" .. i, count + 1, LOS_ACCESS)
            Spring.SetUnitRulesParam(HQID, "HQSpawnUnitCost" .. i, math.floor((metalCost - (metalCost * 0.15 * count)) * (count + 1)), LOS_ACCESS)
            spendMetal(unitCost, HQTeamID)
            return
        end
    end

    for i = 1, 8 do
        local udAtI = Spring.GetUnitRulesParam(HQID, "HQSpawnUnit" .. i)
        local udTier = Spring.GetUnitRulesParam(HQID, "HQBuyUnitTier" .. buyUnitID)
        local udPoolID = Spring.GetUnitRulesParam(HQID, "HQBuyUnitPoolID" .. buyUnitID)
        if udAtI == -1 then
            Spring.SetUnitRulesParam(HQID, "HQBuyUnit" .. buyUnitID, -1, LOS_ACCESS)

            Spring.SetUnitRulesParam(HQID, "HQSpawnUnit" .. i, ud, LOS_ACCESS)
            Spring.SetUnitRulesParam(HQID, "HQSpawnUnitCount" .. i, 1, LOS_ACCESS)
            Spring.SetUnitRulesParam(HQID, "HQSpawnUnitCost" .. i, math.floor(UnitDefs[ud].metalCost), LOS_ACCESS)
            Spring.SetUnitRulesParam(HQID, "HQSpawnUnitTier" .. i, udTier, LOS_ACCESS)
            Spring.SetUnitRulesParam(HQID, "HQSpawnUnitPoolID" .. i, udPoolID, LOS_ACCESS)
            spendMetal(unitCost, HQTeamID)
            return
        end
    end
end

local function OnHQSell(HQID, HQTeamID, sellUnitID)
    local ud = Spring.GetUnitRulesParam(HQID, "HQSpawnUnit" .. sellUnitID)
    if not (ud == -1) then
        Spring.AddTeamResource(HQTeamID, "metal", Spring.GetUnitRulesParam(HQID, "HQSpawnUnitCost" .. sellUnitID))
        Spring.SetUnitRulesParam(HQID, "HQSpawnUnit" .. sellUnitID, -1, LOS_ACCESS)
        Spring.SetUnitRulesParam(HQID, "HQSpawnUnitCost" .. sellUnitID, 1, LOS_ACCESS)

        local udTier = Spring.GetUnitRulesParam(HQID, "HQSpawnUnitTier" .. sellUnitID)
        local udPoolID = Spring.GetUnitRulesParam(HQID, "HQSpawnUnitPoolID" .. sellUnitID)
        local count = Spring.GetUnitRulesParam(HQID, "HQSpawnUnitCount" .. sellUnitID)
        unitPools[udTier][udPoolID] = unitPools[udTier][udPoolID] + count
    end
end

local function OnHQSpawn(HQID, HQTeamID, spawnUnitID)
    local udID = Spring.GetUnitRulesParam(HQID, "HQSpawnUnit" .. spawnUnitID)
    if udID == -1 then
        return
    end

    local unitCost = Spring.GetUnitRulesParam(HQID, "HQSpawnUnitCost" .. spawnUnitID)
    if not spendMetal(unitCost, HQTeamID) then
        return
    end

    local unitCount = Spring.GetUnitRulesParam(HQID, "HQSpawnUnitCount" .. spawnUnitID)
    local cmdQueue = Spring.GetCommandQueue(HQID, -1)

    for i = 1, unitCount do
        local sX, sY, sZ = getHQSpawnPointFor(HQID, UnitDefs[udID])
        local cUnitID = GG.DropUnit(UnitDefs[udID].name, sX, sY, sZ, 0, HQTeamID, false, 60)

        if cmdQueue then
            for i = 1, #cmdQueue do
                local cmd = cmdQueue[i]
                local coded = cmd.options.coded + (cmd.options.shift and 0 or CMD.OPT_SHIFT)
                if cmd.id >= 0 then
                    Spring.GiveOrderToUnit(cUnitID, cmd.id, cmd.params, coded)
                end
            end
        end
    end
end

function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
    if Spring.GetUnitRulesParam(unitID, "isHQ") and cmdID < 0 then
        local allyID = Spring.GetUnitAllyTeam(unitID)
        local metalCost = UnitDefs[-cmdID].metalCost
        local x, y, z, facing = cmdParams[1], cmdParams[2], cmdParams[3], cmdParams[4]

        if (Spring.IsPosInLos(x, y, z, allyID) or Spring.IsPosInRadar(x, y, z, allyID)) and spendMetal(metalCost, unitTeam) then
            local newUnitID = Spring.CreateUnit(-cmdID, x, y, z, facing, unitTeam, true)
            GG.BuildUnit(newUnitID, 3)
        end
        return false
    end
    return true
end

function gadget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag)
    if Spring.GetUnitIsDead(unitID) then
        return
    end

    if Spring.GetUnitRulesParam(unitID, "isHQ") then

        if cmdID == 1 then -- Insert cmd
            cmdID = cmdParams[2]
            cmdParams = {cmdParams[4]}
        end

        if cmdID == CMD_HQ_UPGRADE then
            OnHQUpgrade(unitID, unitTeam)

        elseif cmdID == CMD_HQ_REROLL then
            OnHQReroll(unitID, unitTeam)

        elseif cmdID == CMD_HQ_BUY then
            OnHQBuy(unitID, unitTeam, cmdParams[1])

        elseif cmdID == CMD_HQ_SELL then
            OnHQSell(unitID, unitTeam, cmdParams[1])

        elseif cmdID == CMD_HQ_SPAWN then
            OnHQSpawn(unitID, unitTeam, cmdParams[1])

        end
    end
end

function gadget:Initialize()
    GG.ADDHQ = addHQ
    
    for tier = 1, 5 do
        unitPools[tier] = {}
        for i = 1, #tierUnits[tier] do
            unitPools[tier][i] = tierSize[tier]
        end
    end
end