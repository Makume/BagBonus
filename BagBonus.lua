if not BagBonus then 
	BagBonus = {} 
end

local BagBonus = BagBonus
local pairs, Tooltips, towstring, string, tostring, DoesWindowExist, WindowSetShowing, DestroyWindow, CreateWindow, LabelSetText, DynamicImageSetTexture, GetIconData, ButtonSetPressedFlag, ButtonSetStayDownFlag, ButtonSetText = 
	pairs, Tooltips, towstring, string, tostring, DoesWindowExist, WindowSetShowing, DestroyWindow, CreateWindow, LabelSetText, DynamicImageSetTexture, GetIconData, ButtonSetPressedFlag, ButtonSetStayDownFlag, ButtonSetText
local wn = "BagBonusCharacterWindow"
local BagBonusOpen = false
local OpenTab = false
local ChatUpdateTimer = 0
local BagBonusSent = false
local RefreshTimer = 1

BagBonus.Settings = {}

-- local functions
local function CreateTab()
	WindowSetShowing("CharacterWindowContents", false)
	if not DoesWindowExist(wn.."BagBonus") then
		CreateWindow(wn.."BagBonus", false)
	end
	WindowSetShowing(wn.."BagBonus", true)
	LabelSetText(wn.."BagBonusHeader", L"This window shows the status of the RVR bag roll bonus.")
	local texture, x, y = GetIconData(552)
    DynamicImageSetTexture(wn.."BagBonusSlotGoldIcon", texture, x, y)  
	LabelSetText(wn.."BagBonusSlotGoldLabel", BagBonus.Settings[L"GOLD"])
	texture, x, y = GetIconData(554)
    DynamicImageSetTexture(wn.."BagBonusSlotPurpleIcon", texture, x, y)  
	LabelSetText(wn.."BagBonusSlotPurpleLabel", BagBonus.Settings[L"PURPLE"]) 
	texture, x, y = GetIconData(551)
    DynamicImageSetTexture(wn.."BagBonusSlotBlueIcon", texture, x, y)  
	LabelSetText(wn.."BagBonusSlotBlueLabel", BagBonus.Settings[L"BLUE"])
	texture, x, y = GetIconData(553)
    DynamicImageSetTexture(wn.."BagBonusSlotGreenIcon", texture, x, y)  
	LabelSetText(wn.."BagBonusSlotGreenLabel", BagBonus.Settings[L"GREEN"])
	texture, x, y = GetIconData(555)
    DynamicImageSetTexture(wn.."BagBonusSlotWhiteIcon", texture, x, y)  
	LabelSetText(wn.."BagBonusSlotWhiteLabel", BagBonus.Settings[L"WHITE"])
	WindowSetShowing("CharacterWindowBrags", false)
	WindowSetShowing("CharacterWindowTimeouts",false)
	WindowSetShowing("CharacterWindowTabs", true)	
	ButtonSetPressedFlag("CharacterWindowTabsCharTab", false)
	ButtonSetStayDownFlag("CharacterWindowTabsCharTab", false)
	ButtonSetPressedFlag("CharacterWindowTabsBragsTab", false)
	ButtonSetStayDownFlag("CharacterWindowTabsBragsTab", false)
	ButtonSetPressedFlag("CharacterWindowTabsTimeoutTab", false)
	ButtonSetStayDownFlag("CharacterWindowTabsTimeoutTab", false)
	ButtonSetPressedFlag(wn.."TabsBagBonusTab", true)
	ButtonSetStayDownFlag(wn.."TabsBagBonusTab", true)
	BagBonusOpen = true
end

local function Match(str)
	local bag, rollbonus = str:match(L"Your next roll for (%a+) bag will be increased by (%d+)")
	if (bag == L"") or (bag == nil) then
		bag = str:match(L"You have won a (%a+) loot bag!")
		rollbonus = L"0"
	end
	return bag, rollbonus
end

local function GetTableLng(tbl)
	local getN = 0
	for n in pairs(tbl) do 
		getN = getN + 1 
	end
	return getN
end

local function HideBagBonus()
	local WindowName = "BagBonusCharacterWindowBagBonus"
	if (DoesWindowExist(WindowName)) then
		WindowSetShowing(WindowName, false) 
		local WindowName2 = "BagBonusCharacterWindowTabsBagBonusTab"
		ButtonSetPressedFlag(WindowName2, false)
 		ButtonSetStayDownFlag(WindowName2, false)
	end
end

-- global functions
function BagBonus.Initialize()
	RegisterEventHandler(TextLogGetUpdateEventId("Chat"), "BagBonus.ParseChat")
	RegisterEventHandler(SystemData.Events.ENTER_WORLD, "BagBonus.EnterWorld")
	local windowname = "BagBonusCharacterWindowTabsBagBonusTab"
	if not DoesWindowExist(windowname) then
		CreateWindowFromTemplate(windowname, "BagBonusCharacterWindowTabsTemplate", "CharacterWindowTabs")
	end
	ButtonSetText(windowname, L"Bagbonus")
	BagBonus.OldUpdateMode = CharacterWindow.UpdateMode
	CharacterWindow.UpdateMode = BagBonus.UpdateMode
	BagBonus.OldOnHidden = CharacterWindow.OnHidden
	CharacterWindow.OnHidden = BagBonus.OnHidden
end

function BagBonus.Shutdown()
	UnRegisterEventHandler(TextLogGetUpdateEventId("Chat"), "BagBonus.ParseChat") 
	UnRegisterEventHandler(TextLogGetUpdateEventId("Chat"), "BagBonus.EnterWorld")
	local windowname = "BagBonusCharacterWindowTabsBagBonusTab"
	CharacterWindow.UpdateMode = BagBonus.OldUpdateMode
	CharacterWindow.OnHidden = BagBonus.OldOnHidden
	if (DoesWindowExist(windowname)) then
		DestroyWindow(windowname)
	end
end

function BagBonus.OnTabSelectBagBonus()
	if (GetTableLng(BagBonus.Settings) == 0 or BagBonus.Settings[L"GOLD"] == nil or BagBonus.Settings[L"PURPLE"] == nil or BagBonus.Settings[L"BLUE"] == nil or BagBonus.Settings[L"GREEN"] == nil or BagBonus.Settings[L"WHITE"] == nil) then
		SendChatText(L"]bagbonus", L"")
		BagBonusSent = true
		OpenTab = true
		return		
	end
	CreateTab()
end

function BagBonus.UpdateMode(mode)
	BagBonus.OldUpdateMode(mode)
	if (mode) then
		if (mode == CharacterWindow.MODE_NORMAL) or (mode == CharacterWindow.MODE_BRAGS) or (mode == CharacterWindow.MODE_TIMEOUTS) then
			HideBagBonus()
		end
	end
end

function BagBonus.OnHidden()
	BagBonus.OldOnHidden()
	HideBagBonus()
	if (BagBonusOpen) then
		CharacterWindow.UpdateMode(CharacterWindow.MODE_NORMAL)
		BagBonusOpen = false
	end
end

function BagBonus.ParseChat(updateType, filterType)
	if (updateType ~= SystemData.TextLogUpdate.ADDED) then
		return
	end
	if (filterType ~= 3) then
		return
	end
	local _, filterId, msg = TextLogGetEntry("Chat", TextLogGetNumEntries("Chat") - 1)
	if (filterId ~= 3) then
		return
	end
	local bag, rollbonus = Match(msg)
	if (bag ~= L"") and (bag ~= nil) then
		BagBonus.Settings[towstring(string.upper(tostring(bag)))] = rollbonus
		if (OpenTab) and (bag == L"WHITE") then
			OpenTab = false
			BagBonus.CreateTab()
		end
	end
end

function BagBonus.EnterWorld()
	if (GetTableLng(BagBonus.Settings) == 0) then
		RefreshTimer = 5
		BagBonusSent = false
	end
end

function BagBonus.OnUpdate(elapsedTime)
	if (BagBonusSent) then
		return
	end
	local NewChatUpdateTimer = GetComputerTime()
	if (ChatUpdateTimer == 0) then
        ChatUpdateTimer = GetComputerTime()
	end
	if ((NewChatUpdateTimer - ChatUpdateTimer) > RefreshTimer) then
		SendChatText(L"]bagbonus", L"")
		BagBonusSent = true
    end
end

function BagBonus.OnMouseOver()
	local windowName = SystemData.ActiveWindow.name
    Tooltips.CreateTextOnlyTooltip(windowName, nil)
    Tooltips.SetTooltipText(1, 1, towstring(string.gsub(windowName, "BagBonusCharacterWindowBagBonusSlot", ""))..L"bag") 
    Tooltips.Finalize()    
    local anchor = { Point="bottom", RelativeTo=windowName, RelativePoint="topleft", XOffset=-20, YOffset=0 }
    Tooltips.AnchorTooltip(anchor)
end