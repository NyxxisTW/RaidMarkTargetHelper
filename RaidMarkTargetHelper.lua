if (not RMTH_visible) then
	RMTH_visible = false
end

if (not RMTH_raid_mark) then
	RMTH_raid_mark = 1
end

SLASH_RMTH1 = "/rmth";
SlashCmdList["RMTH"] = function(msg)
	if (RMTH_MainFrame:IsShown()) then
		RMTH_MainFrame:Hide()
		RMTH_visible = false
	else
		RMTH_MainFrame:Show()
		RMTH_visible = true
	end
end

function RMTH_TranslateRaidMarkIndex(raid_mark)
	if (raid_mark == 1) then return "Star"
	elseif (raid_mark == 2) then return "Nipple"
	elseif (raid_mark == 3) then return "Diamond"
	elseif (raid_mark == 4) then return "Triangle"
	elseif (raid_mark == 5) then return "Moon"
	elseif (raid_mark == 6) then return "Square"
	elseif (raid_mark == 7) then return "X"
	elseif (raid_mark == 8) then return "Skull"
	else return ""
	end
end

function RMTH_MainFrame_OnLoad()
	RMTH_MainFrame:RegisterEvent("VARIABLES_LOADED")
	RMTH_MainFrame:SetScript("OnEvent", function()
		if (event == "VARIABLES_LOADED") then
			if (RMTH_visible) then
				RMTH_MainFrame:Show()
			end
			RMTH_CurrentMark:SetText("CM: "..tostring(RMTH_TranslateRaidMarkIndex(RMTH_raid_mark)))
		end
	end)
end

function RMTH_Button_OnClick(btn)
	RMTH_raid_mark = tonumber(string.sub(btn:GetName(), -1))
	if (IsControlKeyDown()) then
		RMTH_CurrentMark:SetText("CM: "..tostring(RMTH_TranslateRaidMarkIndex(RMTH_raid_mark)))
	elseif (IsShiftKeyDown()) then
		if (GetRaidTargetIndex("target") == RMTH_raid_mark) then
			SetRaidTarget("target", 0)
		else
			SetRaidTarget("target", RMTH_raid_mark)
		end
	end
end

function RMTH_SearchTarget()
	if (not RMTH_raid_mark) then
		RMTH_raid_mark = 1
	end
	if (GetRaidTargetIndex("target") == RMTH_raid_mark) then
		return
	end
	for i = 1, GetNumRaidMembers() do
		local unit = "raid"..i
		if (GetRaidTargetIndex(unit) == RMTH_raid_mark) then
			TargetUnit(unit)
			return
		end
		local target = unit.."target"
		if (GetRaidTargetIndex(target) == RMTH_raid_mark) then
			TargetUnit(target)
			return
		end
	end
	for i = 1, GetNumPartyMembers() do
		local unit = "party"..i
		if (GetRaidTargetIndex(unit) == RMTH_raid_mark) then
			TargetUnit(unit)
			return
		end
		local target = unit.."target"
		if (GetRaidTargetIndex(target) == RMTH_raid_mark) then
			TargetUnit(target)
			return
		end
	end
	for i = 0, 32 do
		TargetNearestEnemy()
		if (GetRaidTargetIndex("target") == RMTH_raid_mark) then
			break
		end
	end
end