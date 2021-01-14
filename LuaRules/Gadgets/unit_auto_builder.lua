function gadget:GetInfo()
    return {
        name = "Unit Auto Builder",
        desc = "simulates the building of a unit without using builders",
        author = "petturtle",
        date = "2020",
        layer = -10,
        enabled = true
    }
end

if not gadgetHandler:IsSyncedCode() then
    return false
end

local unitsBuilding = {}
local unitCount = 0

local function buildUnit(unitID, metalSpeed)
    if not Spring.ValidUnitID(unitID) or Spring.GetUnitIsDead(unitID) then
        return
    end

    local udID = Spring.GetUnitDefID(unitID)
    local metalCost = UnitDefs[udID].metalCost
    local buildSpeed = metalSpeed / metalCost
    local maxHP = select(2, Spring.GetUnitHealth(unitID))
    Spring.SetUnitHealth(unitID, {health = maxHP * 0.5})

    for i = 1, unitCount do
        if unitsBuilding[i] == nil then
            unitsBuilding[i] = {unitID, buildSpeed, buildSpeed, maxHP}
            return
        end
    end

    unitsBuilding[unitCount + 1] = {unitID, buildSpeed, buildSpeed, maxHP}
    unitCount = unitCount + 1
end

function gadget:GameFrame(frame)
    if frame % 30 == 0 then
        for i = 1, unitCount do
            if not (unitsBuilding[i] == nil) then
                if Spring.GetUnitIsDead(unitsBuilding[i][1]) then
                    unitsBuilding[i] = nil

                elseif not (unitsBuilding[i] == nil) then

                    unitsBuilding[i][3] = unitsBuilding[i][3] + unitsBuilding[i][2]
                    if unitsBuilding[i][3] >= 1 then
                        Spring.SetUnitHealth(unitsBuilding[i][1], {build = 1})
                        unitsBuilding[i] = nil

                    else
                        local unitHealth = Spring.GetUnitHealth(unitsBuilding[i][1])

                        if unitHealth then
                            local healthIncrease = unitsBuilding[i][4] * unitsBuilding[i][2]
                            local newHealth = math.min(unitHealth + healthIncrease, unitsBuilding[i][4])
                            Spring.SetUnitHealth(unitsBuilding[i][1], {health = newHealth, build = unitsBuilding[i][3]})
                        else
                            unitsBuilding[i] = nil
                        end
                    end
                end
            end

        end
    end
end

function gadget:Initialize()
    GG.BuildUnit = buildUnit
end