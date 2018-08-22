--init a plugin
--Author Lorain.Li
g_Plugin = nil
function Initialize(a_Plugin)
	a_Plugin:SetName("SystemTrade")
	a_Plugin:SetVersion(3)
	g_Plugin = a_Plugin
	cPluginManager.BindCommand("/SysTrade", "SystemTrade.Trade", OnPlayerOpenTradeWindow, " - open system trade window")

	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_LEFT_CLICK, MyOnPlayerLeftClick)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, MyOnPlayerRightClick)
	LOG("SystemTrade v".. g_Plugin:GetVersion() .. " is loaded")
	return true
end

function OnDisable()
	LOG("SystemTrade v" .. g_Plugin:GetVersion() .. " is disabling")
end

function OnPlayerOpenTradeWindow( args,a_Player )
	local window = cLuaWindows(cWindow.wtChest,9,6,"Trade Windows")
	window:Setslot(a_Player, 0, cItem(E_ITEM_DIAMOND, 1))
	a_Player:OpenWindow(window)
end

function MyOnPlayerLeftClick(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_Action)
	local  opendwin = a_Player:GetWindow()
	if (not (opendwin:GetWindowType() == cWindow.wtChest and opendwin:GetWindowTitle() == "Trade Windows")) then
		return false
	end
	LOG("player clicked " .. a_BlockX .. "," .. a_BlockY .. "," .. a_BlockZ)
	return true
end

function MyOnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	local  opendwin = a_Player:GetWindow()
	if (not (opendwin:GetWindowType() == cWindow.wtChest and opendwin:GetWindowTitle() == "Trade Windows")) then
		return false
	end
	LOG("player clicked " .. a_BlockX .. "," .. a_BlockY .. "," .. a_BlockZ)
	return true
end
