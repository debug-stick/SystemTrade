--init a plugin
--Author Lorain.Li
g_Plugin = nil
function Initialize(a_Plugin)
	a_Plugin:SetName("SystemTrade")
	a_Plugin:SetVersion(3)
	g_Plugin = a_Plugin
	cPluginManager.BindCommand("/systrade", "SystemTrade.Trade", OnPlayerOpenTradeWindow, " <buy|sale> - open system trade window")
	LOG("SystemTrade v".. g_Plugin:GetVersion() .. " is loaded")
	if(cPluginManager:CallPlugin("Coin","Balance","BANK") == nil) then
		LOG("please load Coin plugin first before SystemTrade")
	end
	return true
end

function OnDisable()
	LOG("SystemTrade v" .. g_Plugin:GetVersion() .. " is disabling")
end

function OnPlayerOpenTradeWindow(args, a_Player)
	if(#args == 1) then
		a_Player:SendMessage("with param <buy|sale> to open special window")
		return false
	end
	local window = nil
	if(args[2] == "buy") then 
		window = cLuaWindow(cWindow.wtChest,9,(#SaleList + 8) / 9,"Trade Windows:Sale")
		for i=1,#SaleList do
			window:SetSlot(a_Player,i - 1, cItem(SaleList[i][1]))
		end
	end
	if(args[2] == "sale") then
		window = cLuaWindow(cWindow.wtChest,9,(#BuyList + 8) / 9,"Trade Windows:Bought")
		for i=1,#BuyList do
			window:SetSlot(a_Player,i - 1, cItem(BuyList[i][1]))
		end
	end
	window:SetOnClicked(MyOnWindowClicked)
	a_Player:OpenWindow(window)
	return false
end

function MyOnWindowClicked(a_Window, a_Player, a_SlotNum, a_ClickAction, a_ClickedItem)
	if (string.find(a_Window:GetWindowTitle(), "Trade Windows") == nil) then
		return false
	end
	if(a_ClickedItem == nil) then 
		return true
	end
	--trade block with system
	if(a_ClickAction == caLeftClick) then
		--buy
		if(string.find(a_Window:GetWindowTitle(), "Sale") ~= nil) then 
			if(BuyItemFormSystem(a_Player,a_ClickedItem) == false) then
				a_Player:SendMessage("this item can not trade!")
			end
		end
		--sale
		if(string.find(a_Window:GetWindowTitle(), "Bought") ~= nil) then
			if(SaleItemToSystem(a_Player,a_ClickedItem) == false) then
				a_Player:SendMessage("this item can not trade!")
			end
		end
	end
	--sale block to system
	if(a_ClickAction == caRightClick) then
		ShowGoodsDetail(a_Player,a_ClickedItem)
	end
	return true
end


function BuyItemFormSystem(a_Player, a_Item)
	local money = tonumber(string.match(cPluginManager:CallPlugin("Coin","Balance",a_Player:GetUUID()),"%d+"))
	for i=1,#SaleList do
		if(SaleList[i][1] == a_Item.m_ItemType) then
			if(money >= SaleList[i][2]) then
				local a_Inventory = a_Player:GetInventory()
				local n_Item = cItem(a_Item.m_ItemType,1)
				if(a_Inventory:AddItem(n_Item) == 1) then
					cPluginManager:CallPlugin("Coin","Debit", a_Player:GetUUID(), SaleList[i][2])
					a_Player:SendMessage(string.format("you have cost:%d$\nyour balance is:%d$",SaleList[i][2],money - SaleList[i][2]))
				else
					a_Player:SendMessage("your inventory is full")
				end
			else
				a_Player:SendMessage(string.format("you don't have enough money!\nthis will cost:%d$\nyour balance is:%d$",price,money))
			end
			return true
		end
	end
	return false
end

function SaleItemToSystem(a_Player, a_Item)
	local money = tonumber(string.match(cPluginManager:CallPlugin("Coin","Balance",a_Player:GetUUID()),"%d+"))
	local a_Inventory = a_Player:GetInventory()
	for i=1,#BuyList do
		if(BuyList[i][1] == a_Item.m_ItemType) then
			local count = a_Inventory:RemoveItem(cItem(a_Item.m_ItemType,BuyList[i][3]))
			if(count > 1) then
				local pay = BuyList[i][2] * count / BuyList[i][3]
				cPluginManager:CallPlugin("Coin", "Credit", a_Player:GetUUID(), pay)
				a_Player:SendMessage(string.format("you have sold %d items\nyou have get:%d$\nyour balance is:%d$",count,pay,money + pay))
			else
				a_Player:SendMessage("you don't have such item!")
			end
			return true
		end
	end
	return false
end

function ShowGoodsDetail(a_Player, a_Item)
	InSale = false
	for i=1,#SaleList do
		if(SaleList[i][1] == a_Item.m_ItemType) then 
			a_Player:SendMessage(string.format("This item is sale with price:%d$",SaleList[i][2]))
			InSale = true
			break
		end
	end
	if(InSale == false) then 
		a_Player:SendMessage("This item is not on sale")
	end
	InBuy = false
	for i=1,#BuyList do
		if(BuyList[i][1] == a_Item.m_ItemType) then
			a_Player:SendMessage(string.format("This item being bought with price:%d$/%d",BuyList[i][2],BuyList[i][3]))
			InBuy = true
			break
		end
	end
	if(InBuy == false) then
		a_Player:SendMessage("This item can not be bought")
	end
end
