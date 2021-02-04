local base = piece('base')
local drone = piece('drone')

local smokePiece = {drone}
local nanoPieces = {drone}

function script.Create()
	StartThread(GG.Script.SmokeUnit, unitID, smokePiece)
	Spring.SetUnitNanoPieces(unitID, nanoPieces)
end

function script.QueryNanoPiece()
	GG.LUPS.QueryNanoPiece(unitID,unitDefID,Spring.GetUnitTeam(unitID), drone)
	return drone
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth
	if severity < 0.5 then
		Explode(base, SFX.NONE)
		return 1
	else
		Explode(base, SFX.SHATTER)
		return 2
	end
end