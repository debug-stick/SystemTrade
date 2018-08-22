--init a plugin
--Author Lorain.Li
g_Plugin = nil
function Initialize(a_Plugin)
	a_Plugin:SetName("SystemTrade")
	a_Plugin:SetVersion(3)
	g_Plugin = a_Plugin
	cPluginManager.BindCommand("/systrade", "SystemTrade.Trade", OnPlayerOpenTradeWindow, " - open system trade window")
	LOG("SystemTrade v".. g_Plugin:GetVersion() .. " is loaded")
	return true
end

function OnDisable()
	LOG("SystemTrade v" .. g_Plugin:GetVersion() .. " is disabling")
end

function OnPlayerOpenTradeWindow( args,a_Player )
	local window = cLuaWindow(cWindow.wtChest,9,6,"Trade Windows")
	window:SetSlot(a_Player, 0, cItem(E_ITEM_DIAMOND, 1))
	window:SetOnClicked(MyOnWindowClicked)
	a_Player:OpenWindow(window)
end

function MyOnWindowClicked(a_Window, a_Player, a_SlotNum, a_ClickAction, a_ClickedItem)
	if (not (a_Window:GetWindowType() == cWindow.wtChest and a_Window:GetWindowTitle() == "Trade Windows")) then
		return false
	end
	LOG("player clicked slot " .. a_SlotNum)
	return true
end
