local tierSize = {
    [1] = 4,
    [2] = 4,
    [3] = 4,
    [4] = 4,
    [5] = 4,
}

--      "spiderantiheavy", -- widow

local tierUnits = {
    {
        "vehscout", -- dart
        "spiderscout", -- flea
        "amphraid", -- duck
        "hoverraid", -- dagger
        "vehraid", -- scorcher
        "shieldraid", -- bandit
        "cloakraid", -- glaive
        "amphriot", -- scallop
        "cloakskirm", -- ronin
        "shieldskirm", -- rogue
        "cloakaa", -- gremlin
        "shieldriot", -- outlaw
        "planelightscout", -- sparrow
        "planefighter", -- swift
        "jumpraid", -- pyro
        "spiderassault", -- hermit
        "vehriot", -- ripper
        "cloakriot", -- reaver
        "gunshipbomb", -- blastwing
        "shieldscout", -- dirtbag
        "bomberprec", -- raven
    },
    {
        'bomberriot', -- phoenix
        "amphimpulse", -- archer
        "jumpskirm", -- moderator
        "spiderriot", -- redback
        "spideremp", -- venom
        "shieldassault", -- thug
        "vehsupport", -- fencer
        "gunshipemp", -- gnat
        "tankraid", -- kodachi
        "gunshipraid", -- locust
        "shieldbomb", -- snitch
        "cloakbomb", -- imp
        "amphbomb", -- limpet
        "tankheavyraid", -- blitz
        "hoverheavyraid", -- bolas
        "cloakheavyraid", -- scythe
        "vehassault", -- ravager
        "amphfloater", -- buoy
        "hoverskirm", -- scalpel
        "amphaa", -- angler
        "hoveraa", -- flail
        "shieldaa", -- vandal
        "vehaa", -- crasher
        "cloakarty", -- sling
        "gunshipskirm", -- harpy
        "gunshiptrans", -- charon
        "planeheavyfighter", -- raptor
        "amphlaunch", -- lobster
        "hoverassault", -- halberd
        "tankriot", -- ogre
        "hoverriot", -- mace
    },
    {
        "veharty", -- badger
        "jumpblackhole", -- placeholder
        "cloakassault", -- knight
        "vehcapture", -- dominatrix
        "spiderskirm", -- recluse
        "jumpassault", -- jack
        "vehheavyarty", -- impaler
        "shieldarty", -- racketeer
        "shieldshield", -- aspis
        "spideraa", -- tarantula
        "tankaa", -- ettin
        "gunshipheavytrans", -- hercules
        "planescout", -- owl
        "tankarty", -- emissary
        "jumpbomb", -- skuttle
        "tankassault", -- minotaur
    },
    {
        "bomberdisarm", -- thunderbird
        "bomberheavy", -- likho
        "gunshipassault", -- revenant
        "jumpscout", -- puppy
        "striderdante", -- dante
        "jumpsumo", -- jugglenaut
        "shieldfelon", -- felon
        "cloakjammer", -- iris
        "amphtele", -- djinn
        "striderantiheavy", -- ultimatum
        "cloaksnipe", -- phantom
        "hoverarty", -- lance
        "jumparty", -- firewalker
        "tankheavyarty", -- tremor
        "jumpaa", -- toad
        "gunshipheavyskirm", -- nimbus
        "gunshipkrow", -- krow
        "amphassault", -- grizzly
        "tankheavyassault", -- cyclops
    },
    {
        "spidercrabe", -- crab
        "nebula", -- Nebula
        "striderscorpion", -- scorpion
        "striderbantha", -- paladin
        "striderdetriment", -- detriment
    },
}

local tierOdds = {
    [1] = {
        [1] = 100,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
    },
    [2] = {
        [1] = 70,
        [2] = 30,
        [3] = 0,
        [4] = 0,
        [5] = 0,
    },
    [3] = {
        [1] = 60,
        [2] = 40,
        [3] = 0,
        [4] = 0,
        [5] = 0,
    },
    [4] = {
        [1] = 40,
        [2] = 40,
        [3] = 20,
        [4] = 0,
        [5] = 0,
    },
    [5] = {
        [1] = 35,
        [2] = 40,
        [3] = 25,
        [4] = 0,
        [5] = 0,
    },
    [6] = {
        [1] = 30,
        [2] = 35,
        [3] = 30,
        [4] = 5,
        [5] = 0,
    },
    [7] = {
        [1] = 25,
        [2] = 30,
        [3] = 35,
        [4] = 10,
        [5] = 0,
    },
    [8] = {
        [1] = 22,
        [2] = 27,
        [3] = 35,
        [4] = 15,
        [5] = 1,
    },
    [9] = {
        [1] = 20,
        [2] = 25,
        [3] = 30,
        [4] = 20,
        [5] = 3,
    },
    [10] = {
        [1] = 15,
        [2] = 21,
        [3] = 28,
        [4] = 30,
        [5] = 6,
    },
    [11] = {
        [1] = 14,
        [2] = 20,
        [3] = 26,
        [4] = 30,
        [5] = 10,
    },
}

local levelData = {
    [1] = {
        rerollCost = 75,
        upgradeCost = 200,
    },
    [2] = {
        rerollCost = 75,
        upgradeCost = 300,
    },
    [3] = {
        rerollCost = 75,
        upgradeCost = 350,
    },
    [4] = {
        rerollCost = 75,
        upgradeCost = 400,
    },
    [5] = {
        rerollCost = 75,
        upgradeCost = 450,
    },
    [6] = {
        rerollCost = 75,
        upgradeCost = 500,
    },
    [7] = {
        rerollCost = 75,
        upgradeCost = 500,
    },
    [8] = {
        rerollCost = 75,
        upgradeCost = 550,
    },
    [9] = {
        rerollCost = 75,
        upgradeCost = 600,
    },
    [10] = {
        rerollCost = 75,
        upgradeCost = 700,
    },
    [11] = {
        rerollCost = 75,
        upgradeCost = 800,
    },
    [12] = {
        rerollCost = 75,
        upgradeCost = 900,
    },
    [13] = {
        rerollCost = 75,
        upgradeCost = 1000,
    },
    [14] = {
        rerollCost = 75,
        upgradeCost = 1200,
    },
    [15] = {
        rerollCost = 75,
        upgradeCost = 1500,
    },
}

return tierSize, tierUnits, tierOdds, levelData