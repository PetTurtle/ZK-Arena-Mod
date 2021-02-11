local unitDef = {
  -- General
  unitname                      = [[arena_hq]],
  name                          = [[Arena HQ]],
  description                   = [[Area Field HQ (spawns units)]],
  buildPic                      = [[pw_hq.png]],
  objectName                    = [[pw_hq.s3o]],
  script                        = [[area_hq.lua]],
  maxDamage                     = 10000,
  autoHeal                      = 100,
  idleAutoHeal                  = 100,
  idleTime                      = 1800,
  buildCostMetal                = 1000,
  reclaimable                   = false,
  capturable                    = false,
  iconType                      = [[pw_assault]],
  corpse                        = [[DEAD]],
  explodeAs                     = [[ATOMIC_BLAST]],
  selfDestructAs                = [[ATOMIC_BLAST]],

  -- Resources
  metalStorage                  = 100000,
  energyStorage                 = 100000,
  energyUse                     = 0,
  energyMake                    = 1000,

  -- Sensors
  activateWhenBuilt             = true,
  sightDistance                 = 330,

  -- Cloaking
  minCloakDistance              = 150,

  -- Commands
  canMove                       = true,
  canAttack                     = true,
  canFight                      = true,
  canPatrol                     = true,
  canGuard                      = true,
  canSelfD                      = false,
  moveState                     = 1,

  -- Builder
  builder                       = true,
  buildDistance                 = 1,
  workerTime                    = 3,
  terraformSpeed                = 0,

  buildoptions        = {
    [[staticheavyradar]],
    [[staticcon]],
    [[staticshield]],
    [[staticrearm]],
    [[turretmissile]],
    [[turretriot]],
    [[turretheavylaser]],
    [[turrettorp]],
    [[turretimpulse]],
    [[turretemp]],
    [[turretaaflak]],
    [[turretaaclose]],
  },

  -- Movement & Placement
  footprintX                    = 8,
  footprintZ                    = 8,
  levelGround                   = true,
  maxWaterDepth                 = 0,
  waterline                     = 10,
  maxVelocity                   = 0,
  acceleration                  = 0,
  brakeRate                     = 0,
  turnRate                      = 0,

  -- Categories
  category                      = [[FLOAT UNARMED]],

  -- buildingGroundDecalSizeX
  useBuildingGroundDecal        = true,
  buildingGroundDecalType       = [[factorygunship_aoplane.dds]],
  buildingGroundDecalSizeX      = 10,
  buildingGroundDecalSizeY      = 10,
  buildingGroundDecalDecaySpeed = 30,

  -- Other
  customParams                  = {
    soundselect = "building_select1",
    isfakefactory = 1,
    notreallyafactory = 1,
  },

  featureDefs                   = {
    DEAD  = {
      blocking         = true,
      resurrectable    = 0,
      featureDead      = [[HEAP]],
      footprintX       = 8,
      footprintZ       = 8,
      object           = [[pw_hq_dead.s3o]],
    },
  
    HEAP  = {
      blocking         = false,
      footprintX       = 6,
      footprintZ       = 6,
      object           = [[debris4x4b.s3o]],
    },
  },
}

return {arena_hq = unitDef}