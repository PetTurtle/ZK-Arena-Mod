local tierSize = {
    [1] = 4,
    [2] = 4,
    [3] = 4,
    [4] = 4,
    [5] = 4,
}


local tierUnits = {
    {
        "shieldscout", -- dirtbag
        "vehscout", -- dart
        "jumpscout", -- puppy
        "spiderscout", -- flea
        "amphraid", -- duck
        "hoverraid", -- dagger
        "vehraid", -- scorcher
        "shieldraid", -- bandit
        "cloakraid", -- glaive
        "tankraid", -- kodachi
        "gunshipraid", -- locust
        "amphriot", -- scallop
        "spideremp", -- venom
        "cloakskirm", -- ronin
        "vehsupport", -- fencer
        "shieldskirm", -- rogue
        "spiderassault", -- hermit
        "shieldassault", -- thug
        "cloakaa", -- gremlin
        "gunshipemp", -- gnat
        "planefighter", -- swift
    },
    {
        "shieldbomb", -- snitch
        "cloakbomb", -- imp
        "amphbomb", -- limpet
        "gunshipbomb", -- blastwing
        "jumpraid", -- pyro
        "tankheavyraid", -- blitz
        "hoverheavyraid", -- bolas
        "cloakheavyraid", -- scythe
        "shieldriot", -- outlaw
        "spiderriot", -- redback
        "cloakriot", -- reaver
        "vehriot", -- ripper
        "amphimpulse", -- archer
        "vehassault", -- ravager
        "amphfloater", -- buoy
        "hoverskirm", -- scalpel
        "jumpskirm", -- moderator
        "amphaa", -- angler
        "hoveraa", -- flail
        "shieldaa", -- vandal
        "vehaa", -- crasher
        "cloakarty", -- sling
        "gunshipskirm", -- harpy
        "gunshiptrans", -- charon
        "planeheavyfighter", -- raptor
        "planelightscout", -- sparrow
    },
    {
        "hoverriot", -- mace
        "jumpblackhole", -- placeholder
        "tankriot", -- ogre
        "cloakassault", -- knight
        "vehcapture", -- dominatrix
        "spiderskirm", -- recluse
        "hoverassault", -- halberd
        "jumpassault", -- jack
        "veharty", -- badger
        "vehheavyarty", -- impaler
        "shieldarty", -- racketeer
        "shieldshield", -- aspis
        "amphlaunch", -- lobster
        "spideraa", -- tarantula
        "tankaa", -- ettin
        "gunshipheavytrans", -- hercules
        "planescout", -- owl
    },
    {
        "jumpbomb", -- skuttle
        "striderdante", -- dante
        "tankassault", -- minotaur
        "jumpsumo", -- jugglenaut
        "shieldfelon", -- felon
        "cloakjammer", -- iris
        "amphtele", -- djinn
        "spiderantiheavy", -- widow
        "striderantiheavy", -- ultimatum
        "cloaksnipe", -- phantom
        "tankarty", -- emissary
        "hoverarty", -- lance
        "jumparty", -- firewalker
        "tankheavyarty", -- tremor
        "jumpaa", -- toad
        "gunshipheavyskirm", -- nimbus
        "gunshipassault", -- revenant
    },
    {
        "spidercrabe", -- crab
        "amphassault", -- grizzly
        "tankheavyassault", -- cyclops
        "gunshipkrow", -- krow
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
        [1] = 65,
        [2] = 35,
        [3] = 0,
        [4] = 0,
        [5] = 0,
    },
    [4] = {
        [1] = 50,
        [2] = 35,
        [3] = 15,
        [4] = 0,
        [5] = 0,
    },
    [5] = {
        [1] = 40,
        [2] = 35,
        [3] = 25,
        [4] = 0,
        [5] = 0,
    },
    [6] = {
        [1] = 35,
        [2] = 30,
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
        [1] = 15,
        [2] = 21,
        [3] = 28,
        [4] = 30,
        [5] = 10,
    },
}

local levelData = {
    [1] = {
        rerollCost = 75,
        upgradeCost = 100,
    },
    [2] = {
        rerollCost = 75,
        upgradeCost = 200,
    },
    [3] = {
        rerollCost = 75,
        upgradeCost = 250,
    },
    [4] = {
        rerollCost = 75,
        upgradeCost = 300,
    },
    [5] = {
        rerollCost = 75,
        upgradeCost = 350,
    },
    [6] = {
        rerollCost = 75,
        upgradeCost = 400,
    },
    [7] = {
        rerollCost = 75,
        upgradeCost = 450,
    },
    [8] = {
        rerollCost = 75,
        upgradeCost = 500,
    },
    [9] = {
        rerollCost = 75,
        upgradeCost = 550,
    },
    [10] = {
        rerollCost = 75,
        upgradeCost = 600,
    },
    [11] = {
        rerollCost = 75,
        upgradeCost = 650,
    },
    [12] = {
        rerollCost = 75,
        upgradeCost = 750,
    },
    [13] = {
        rerollCost = 75,
        upgradeCost = 700,
    },
    [14] = {
        rerollCost = 75,
        upgradeCost = 800,
    },
    [15] = {
        rerollCost = 75,
        upgradeCost = 850,
    },
}

return tierSize, tierUnits, tierOdds, levelData