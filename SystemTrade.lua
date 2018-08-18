--init a plugin
--Author Lorain.Li
g_Plugin=nil;
function Initialize(a_Plugin)
	a_Plugin:SetName("SystemTrade")
	a_Plugin:SetVersion(3)
	g_Plugin = a_Plugin
	cPluginManager.BindCommand("/SysTrade", "SystemTrade.Trade", OnPlayerOpenTradeWindow, " - open system trade screen")
	LOG("SystemTrade v".. g_Plugin:GetVersion() .." is loaded")
	return true
end

function OnDisable()
	LOG("SystemTrade v" .. g_Plugin:GetVersion() .. " is disabling")
end


function OnPlayerOpenTradeWindow( args,a_Player )
	local winTrade = cLuaWindows(cWindow.wtInventory,9,4,"Shop Windows")
	winTrade:Setslot(a_Player, 0, cItem(E_ITEM_DIAMOND, 64))
	winTrade:SetOnClicked(OnPlayerClickItem)
	a_Player:OpenWindow(winTrade)
end

local OnPlayerClickItem = function(Window, ClickingPlayer, SlotNum, ClickAction, ClickedItem)
	if ClickAction == caShiftLeftClick then
		return true
	end
end