function widget:GetInfo()
	return {
		name      = "Unit Shop",
		desc      = "Shows units you can buy",
		author    = "PetTurtle",
		date      = "2020",
		layer     = 0,
		enabled   = true,
	}
end

include "LuaRules/Configs/customcmds.h.lua"

local TIER_COLORS = {
    {0.1, 0.1, 0.1, 0.9},
    {0.1, 0.9, 0.1, 0.9},
    {0.1, 0.1, 0.9, 0.9},
    {0.9, 0.1, 0.9, 0.9},
    {1, 0.8, 0.1, 1}
}

local CMD_INSERT = CMD.INSERT
local CMD_OPT_SHIFT    = CMD.OPT_SHIFT

local CMD_HQ_UPGRADE = 49734
local CMD_HQ_REROLL = 49735
local CMD_HQ_BUY = 49736

local isVisible = true
local selectedHQID = nil

local Chili = nil
local window = nil

local upgradeButton = nil
local titleLabel = nil
local rerollButton = nil

local buttons = {}
local buttonImages = {}
local buttonCostLabels = {}
local buttonCountLabels = {}

local function giveUpgradeCommand(self)
	Spring.GiveOrderToUnit(selectedHQID, CMD_INSERT, {0, CMD_HQ_UPGRADE, CMD_OPT_SHIFT, 0}, {"alt"})
end

local function giveRerollCommand(self)
	Spring.GiveOrderToUnit(selectedHQID, CMD_INSERT, {0, CMD_HQ_REROLL, CMD_OPT_SHIFT, 0}, {"alt"})
end

local function giveBuyCommand(self, buyID)
	Spring.GiveOrderToUnit(selectedHQID, CMD_INSERT, {0, CMD_HQ_BUY, CMD_OPT_SHIFT, buyID}, {"alt"})
end


local function updateUI()
	local HQLevel = Spring.GetUnitRulesParam(selectedHQID, "HQLevel")
	local levelCost = Spring.GetUnitRulesParam(selectedHQID, "HQLevelCost")
	local rerollCost = Spring.GetUnitRulesParam(selectedHQID, "HQRerollCost")

	if HQLevel == 15 then
		titleLabel:SetCaption("Unit Shop\n Max Level")
		upgradeButton:SetCaption("Max Level")
	else
		titleLabel:SetCaption("Unit Shop\n Level " .. HQLevel)
		upgradeButton:SetCaption("Upgrade (" .. levelCost .. "m)")
	end

	rerollButton:SetCaption("Reroll (" .. rerollCost .. "m)")
	

	for i = 1, 5 do
		local ud = Spring.GetUnitRulesParam(selectedHQID, "HQBuyUnit" .. i)

		if ud == -1 then
			buttonImages[i].file = "LuaUI/Images/Neon/glass.png"
			buttonImages[i]:Invalidate()
			buttons[i].backgroundColor = TIER_COLORS[1]
            buttons[i]:Invalidate()
            buttonCostLabels[i]:SetCaption("----")
            buttonCountLabels[i]:SetCaption("")
		else
			local buyUnitTier = Spring.GetUnitRulesParam(selectedHQID, "HQBuyUnitTier" .. i)
            buttonImages[i].file = "unitpics/" .. UnitDefs[ud].buildpicname
			buttonImages[i]:Invalidate()
			buttons[i].backgroundColor = TIER_COLORS[buyUnitTier]
            buttons[i]:Invalidate()
            buttonCostLabels[i]:SetCaption(math.floor(UnitDefs[ud].cost))
		end
	end
end

local function setVisible(value)
	if value and not isVisible then
		Chili.Screen0:AddChild(window)
		isVisible = true
	elseif not value and isVisible then
		Chili.Screen0:RemoveChild(window)
		isVisible = false
	end
end

function widget:CommandsChanged()
	local units = Spring.GetSelectedUnits()
	if units then
		for i = 1, #units do
			if Spring.GetUnitRulesParam(units[i], "isHQ") then
				selectedHQID = units[i]
				updateUI()
				setVisible(true)
				return
			end
		end
	end
	setVisible(false)
	selectedHQID = nil
end

local function CreateUnitButton(buyID)
    buttons[#buttons + 1] = Chili.Button:New {
        width = 64,
        height = 90,
        margin = {5,5,5,5},
        padding = {5,5,5,5},
        caption = "",
        OnClick = {
			function (self)
				giveBuyCommand(self, buyID)
            end
        },
    }

    buttonImages[#buttonImages + 1] = Chili.Image:New {
        width = 50,
        height = 50,
        file = "LuaUI/Images/Neon/glass.png",
        keepAspect = true,
        parent = buttons[#buttons],
    }

    buttonCostLabels[#buttonCostLabels+1] = Chili.Label:New {
        width = 50,
        height = 115,
        valign ="center",
        align = "left",
        caption = "----",
        textColor = {0.9,0.9,0.9,1.0},
        parent = buttons[#buttons]
    }

    buttonCountLabels[#buttonCountLabels+1] = Chili.Label:New {
        width= 45;
        height= 45;
        valign ="top",
        align = "left",
        caption = "",
        fontSize = 16;
        fontShadow = true;
        textColor = {0.2,0.8,0.2,0.9},
        parent = buttonImages[#buttonImages]
    }

    return buttons[#buttons]
end

function widget:UnitCmdDone(unitID)
    if isVisible and selectedHQID == unitID then
        updateUI()
    end
end

function widget:Initialize()
	Chili = WG.Chili
	if not Chili then
		widgetHandler:RemoveWidget()
		return
	end

	window = Chili.Window:New {
		dockable = true,
        name = "Unit Shop",
		x = 0,
		y = 40,
		width = 385,
		height = 160,
		margin = {5,5,5,5},
		padding = {5,5,5,5},
        classname = "main_window",
        draggable = true,
        resizable = false,
        tweakDraggable = true,
        tweakResizable = false,
        minimizanle = false,
        parent = Chili.Screen0,
	}

	local topPanel = Chili.StackPanel:New{
		x = 5,
		y = 0,
        right = 5,
        height = 50,
        itemPadding = {0,0,0,0},
        itemMargin = {0,0,0,0},
        orientation = "horizontal",
		parent = window,
	}

	upgradeButton = Chili.Button:New {
		caption = "Upgrade",
		tooltip = "increase odds of better units",
		OnClick = {
			function (self)
				giveUpgradeCommand(self)
			end
		},
		parent = topPanel
	}

	titleLabel = Chili.Label:New {
		valign = "center",
		align = "center",
		caption = "Unit Shop\n Level 1",
		fontSize = 16;
		fontShadow = true;
		textColor = {0.1,0.9,0.1,1.0},
		parent = topPanel
	}

	rerollButton = Chili.Button:New {
		caption = "Reroll (250m)",
		tooltip = "get new cards",
		OnClick = {
			function (self)
				giveRerollCommand(self)
			end
		},
		parent = topPanel
	}
	
	local bottomPanel = Chili.StackPanel:New{
		x = 5,
		y = 50,
        right = 5,
        bottom = 5,
        itemPadding = {0,0,0,0},
        itemMargin = {0,0,0,0},
        orientation = "horizontal",
		parent = window,
		children = {
			CreateUnitButton(1),
			CreateUnitButton(2),
			CreateUnitButton(3),
			CreateUnitButton(4),
			CreateUnitButton(5)
		}
	}
	
	setVisible(false)
end