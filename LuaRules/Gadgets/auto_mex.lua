function gadget:GetInfo()
    return {
        name = "auto_mex",
        desc = "capture and upgrade mex without constructors",
        author = "petturtle",
        date = "2020",
        layer = -10,
        enabled = true
    }
end

if not gadgetHandler:IsSyncedCode() then
    return false
end

local UPDATEFRAME = 5
local UPGRADETIME = 3500
local NEUTRALTEAM = Spring.GetGaiaTeamID()
local mexDefID = UnitDefNames["staticmex"].id
local mexFeatureDefID = FeatureDefNames["staticmex_dead"].id
local mexs = {}
local mexQueue = {}

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

local buildings = {
    {
        ud = UnitDefNames["energysolar"],
        probability = 60,
    },
    {
        ud = UnitDefNames["turretlaser"],
        probability = 30,
    },
    {
        ud = UnitDefNames["turretriot"],
        probability = 5,
    },
    {
        ud = UnitDefNames["turretheavylaser"],
        probability = 2,
    },
    {
        ud = UnitDefNames["staticradar"],
        probability = 3,
    },
}

local function createMex(x, y, z, teamID)
    local unitID = Spring.CreateUnit(mexDefID, x, y, z, "n", teamID, true)
    if unitID == nil then
        unitID = Spring.CreateUnit(mexDefID, x, y, z, "n", NEUTRALTEAM, true)
        if unitID == nil then
            return
        end
    end

    GG.BuildUnit(unitID, 5)
    mexs[unitID] = {
        hp = 1,
        aliveTime = 5,
        buildings = {},
    }
end

local function getUpgradeLocation(mexID, ud)
    local tx, ty, tz = Spring.GetUnitPosition(mexID)
	local size = ud.xsize
	local startCheck = math.floor(math.random(8))
    local direction = (math.random() < 0.5 and -1) or 1
    local distance = math.random(40, 100)
	for j = 0, 7 do
		local spot = (j*direction+startCheck)%8
		local sx, sz = offset[spot].x*(size*4+distance), offset[spot].z*(size*4+distance)
		local place, feature = Spring.TestBuildOrder(ud.id, tx + sx, 0, tz + sz, 1)

		if (place == 2 and feature == nil) then
			return tx + sx, ty, tz + sz
		end
	end
	return nil
end

local function getUpgradeUD()
    local ran = math.random(0, 100)
    for i = 1, #buildings do
        ran = ran - buildings[i].probability
        if ran <= 0 then
            return buildings[i].ud
        end
    end
    return buildings[1].ud
end

local function mexHPMulti(mexID, multiplier)
    mexs[mexID].hp = mexs[mexID].hp + multiplier
    GG.UnitScale(mexID, 1 + (mexs[mexID].hp * 0.1))
    local originalHealth = UnitDefs[mexDefID].health
    local currHP, currMaxHP = Spring.GetUnitHealth(mexID)
    local newMaxHP = (originalHealth * mexs[mexID].hp)
    local newHP = currHP * newMaxHP / currMaxHP
    Spring.SetUnitMaxHealth(mexID, newMaxHP)
    Spring.SetUnitHealth(mexID, newHP)
end

local function upgradeMex(mexID)
    local updateUD = getUpgradeUD()
    local x, y, z = getUpgradeLocation(mexID, updateUD)
    if x then
        local mexTeamID = Spring.GetUnitTeam(mexID)
        local updateID = Spring.CreateUnit(updateUD.id, x, y, z, "n", mexTeamID, true)
        if updateID then
            GG.BuildUnit(updateID, 5)
            mexs[mexID].buildings[updateID] = true
            mexHPMulti(mexID, 1)
        end
    end
end

function gadget:GameFrame(frame)
    if frame % UPDATEFRAME == 0 then
        for mexID, mexData in pairs(mexs) do
            mexData.aliveTime = mexData.aliveTime + UPDATEFRAME

            if mexData.aliveTime % UPGRADETIME == 0 then
                upgradeMex(mexID)
            end
        end
    end

    -- Delay replacement mexes until the next frame after they're destroyed.
    -- This lets cmd_mex_placement.lua's callbacks happen in the right order to mark the spot with the team-color who now owns it.
    for _,m in ipairs(mexQueue) do
        createMex(m.x, m.y, m.z, m.team)
    end
    mexQueue = {}
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if unitDefID == mexDefID and mexs[unitID] then
        for buildingID in pairs(mexs[unitID].buildings) do
            if not Spring.GetUnitIsDead(buildingID) then
                Spring.DestroyUnit(buildingID, true, true, attackerID or NEUTRALTEAM)
            end
        end

        mexs[unitID] = nil
        local x, y, z = Spring.GetUnitPosition(unitID)
        mexQueue[#mexQueue+1] = {x=x, y=y, z=z, team=(attackerTeam or NEUTRALTEAM)}
    end
end

function gadget:AllowFeatureCreation(featureDefID, teamID, x, y, z)
    return not (featureDefID == mexFeatureDefID)
end

function gadget:GameStart()
    local metalSpots = GG.metalSpots
    for i = 1, #metalSpots do
        local spot = metalSpots[i]
        spot.y = Spring.GetGroundHeight(spot.x, spot.z)
        createMex(spot.x, spot.y, spot.z, NEUTRALTEAM)
    end
end