require("ISEquippedItem");
require("PlayerData/ISPlayerData");
-- ISEquippedItem.instance

bcToolbar = {};
bcToolbar.x = 0;
bcToolbar.width = 2;
bcToolbar.btnSize = 40;

bcToolbar.moveButtonToToolbar = function(newButton, description)
	-- Make sure buttons are not added twice
	for _,btn in pairs(bcToolbar.buttons) do
		if btn == newButton then return end
	end

	table.insert(bcToolbar.buttons, newButton);
	bcToolbar.window:setWidth(bcToolbar.width * bcToolbar.btnSize + 4);
	bcToolbar.window:setHeight(math.ceil(#bcToolbar.buttons / bcToolbar.width) * bcToolbar.btnSize + 4 + 16);
	bcToolbar.window:addChild(newButton);

	newButton:setX(bcToolbar.x * bcToolbar.btnSize + 2);
	newButton:setY(math.floor((#bcToolbar.buttons - 1) / bcToolbar.width) * bcToolbar.btnSize + 2 + 16);
	newButton:setWidth(bcToolbar.btnSize);
	newButton:setHeight(bcToolbar.btnSize);

	newButton:setTooltip(getText(description));

	bcToolbar.x = bcToolbar.x + 1;
	if bcToolbar.x >= bcToolbar.width then
		bcToolbar.x = 0;
	end
end

bcToolbar.resizeToolbar = function(newWidth)
	bcToolbar.x = 0;
	bcToolbar.width = newWidth;
	local oldButtons = bcToolbar.buttons;
	bcToolbar.buttons = {};
	for _,btn in ipairs(oldButtons) do
		bcToolbar.moveButtonToToolbar(btn);
	end
end

function blubb(self, x, y)
	print("blubb");
	bcToolbar.resizeToolbar(bcToolbar.width + 1);
end

bcToolbar.initialise = function()
	bcToolbar.buttons = {};

	bcToolbar.window = ISCollapsableWindow:new(0, 105, bcToolbar.width * bcToolbar.btnSize + 4, bcToolbar.btnSize + 4 + 16);
	bcToolbar.window.onRightMouseUp = blubb;
	bcToolbar.window:setResizable(false);
	bcToolbar.window:addToUIManager();
	bcToolbar.window.closeButton:setVisible(false);
	bcToolbar.window.backgroundColor = {r=0, g=0, b=0, a=0.5};
	bcToolbar.window.borderColor = {r=0.4, g=0.4, b=0.4, a=1};

	bcToolbar.moveButtonToToolbar(ISEquippedItem.instance.invBtn, "Inventory");
	bcToolbar.moveButtonToToolbar(ISEquippedItem.instance.healthBtn, "Health");
	bcToolbar.moveButtonToToolbar(ISEquippedItem.instance.craftingBtn, "Crafting");
end

Events.OnCreatePlayer.Add(bcToolbar.initialise);
