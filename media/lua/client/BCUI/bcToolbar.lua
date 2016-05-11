require("ISUI/ISEquippedItem");
require("ISUI/PlayerData/ISPlayerData");

bcToolbar = {};
bcToolbar.x = 0;
bcToolbar.y = 0;
bcToolbar.config = {};
bcToolbar.config.main = {};
bcToolbar.config.main.width = 2;
bcToolbar.config.main.buttonSize = 48;
bcToolbar.config.buttons = {};
bcToolbar.config.position = {};
bcToolbar.config.position.x = 0;
bcToolbar.config.position.y = 105;

bcToolbar.moveButtonToToolbar = function(newButton, description)--{{{
	-- Make sure buttons are not added twice
	for _,btn in pairs(bcToolbar.buttons) do
		if btn == newButton then return end
	end

	table.insert(bcToolbar.buttons, newButton);
	newButton:setTooltip(description);

	if bcToolbar.config.buttons[description] ~= false then
		newButton:setVisible(true);
		bcToolbar.window:setWidth(bcToolbar.config.main.width * bcToolbar.config.main.buttonSize + 4);
		bcToolbar.window:setHeight((1+bcToolbar.y) * bcToolbar.config.main.buttonSize + 4 + 16);
		bcToolbar.window:addChild(newButton);

		newButton:setX(bcToolbar.x * bcToolbar.config.main.buttonSize + 2);
		newButton:setY(bcToolbar.y * bcToolbar.config.main.buttonSize + 2 + 16);
		newButton:setWidth(bcToolbar.config.main.buttonSize);
		newButton:setHeight(bcToolbar.config.main.buttonSize);
		newButton.forcedWidthImage = bcToolbar.config.main.buttonSize;
		newButton.forcedHeightImage = bcToolbar.config.main.buttonSize;

		bcToolbar.x = bcToolbar.x + 1;
		if bcToolbar.x >= bcToolbar.config.main.width then
			bcToolbar.x = 0;
			bcToolbar.y = bcToolbar.y + 1;
		end
	else
		newButton:setVisible(false);
	end
end
--}}}
bcToolbar.resizeToolbar = function(newWidth)--{{{
	bcToolbar.x = 0;
	bcToolbar.y = 0;
	bcToolbar.config.main.width = newWidth;
	local oldButtons = bcToolbar.buttons;
	bcToolbar.buttons = {};
	for _,btn in ipairs(oldButtons) do
		bcToolbar.moveButtonToToolbar(btn, btn.tooltip or "");
	end
	bcToolbar.save();
end
--}}}
bcToolbar.save = function()--{{{
	bcUtils.writeINI("bcToolbar.ini", bcToolbar.config);
end
--}}}
bcToolbar.reduceWidth = function()--{{{
	bcToolbar.resizeToolbar(math.max(1, bcToolbar.config.main.width - 1));
	bcToolbar.configWindow.widthLabel.name = tostring(bcToolbar.config.main.width);
end
--}}}
bcToolbar.increaseWidth = function()--{{{
	bcToolbar.resizeToolbar(math.min(8, bcToolbar.config.main.width + 1));
	bcToolbar.configWindow.widthLabel.name = tostring(bcToolbar.config.main.width);
end
--}}}
bcToolbar.reduceButtonSize = function()--{{{
	bcToolbar.config.main.buttonSize = math.max(16, bcToolbar.config.main.buttonSize - 8);
	bcToolbar.configWindow.buttonSizeLabel.name = tostring(bcToolbar.config.main.buttonSize);
	bcToolbar.resizeToolbar(bcToolbar.config.main.width);
end
--}}}
bcToolbar.increaseButtonSize = function()--{{{
	bcToolbar.config.main.buttonSize = math.min(128, bcToolbar.config.main.buttonSize + 8);
	bcToolbar.configWindow.buttonSizeLabel.name = tostring(bcToolbar.config.main.buttonSize);
	bcToolbar.resizeToolbar(bcToolbar.config.main.width);
end
--}}}

bcToolbar.showConfig = function()--{{{
	if bcToolbar.configWindow then
		bcToolbar.configWindow:setVisible(true);
		bcToolbar.configWindow:setWidth(getCore():getScreenWidth() - 200);
		bcToolbar.configWindow:setHeight(getCore():getScreenHeight() - 200);
		return;
	end
	local w = ISCollapsableWindow:new(100, 100, getCore():getScreenWidth() - 200, getCore():getScreenHeight() - 200);
	w:setTitle(getText("UI_ConfigureToolbar"));
	w:setResizable(false);
	w:addToUIManager();
	w.pinButton:setVisible(false);
	w.collapseButton:setVisible(false);
	bcToolbar.configWindow = w;

	w:addChild(ISLabel:new(4, 16, 32, getText("UI_ToolbarWidth"), 1, 1, 1, 1, nil, true));
	w.widthMinusButton = ISButton:new(150, 16, 32, 32, "-", nil, bcToolbar.reduceWidth);
	w:addChild(w.widthMinusButton);
	w.widthLabel = ISLabel:new(190, 16, 32, tostring(bcToolbar.config.main.width), 1, 1, 1, 1, nil, true);
	w:addChild(w.widthLabel);
	w.widthPlusButton = ISButton:new(214, 16, 32, 32, "+", nil, bcToolbar.increaseWidth);
	w:addChild(w.widthPlusButton);

	w:addChild(ISLabel:new(4, 56, 32, getText("UI_ToolbarButtonWidth"), 1, 1, 1, 1, nil, true));
	w.buttonSizeMinusButton = ISButton:new(150, 56, 32, 32, "-", nil, bcToolbar.reduceButtonSize);
	w:addChild(w.buttonSizeMinusButton);
	w.buttonSizeLabel = ISLabel:new(190, 56, 32, tostring(bcToolbar.config.main.buttonSize), 1, 1, 1, 1, nil, true);
	w:addChild(w.buttonSizeLabel);
	w.buttonSizePlusButton = ISButton:new(214, 56, 32, 32, "+", nil, bcToolbar.increaseButtonSize);
	w:addChild(w.buttonSizePlusButton);

	w:addChild(ISLabel:new(4, 96, 32, getText("UI_ShowButtons"), 1, 1, 1, 1, nil, true));
	w.buttonTickBox = ISTickBox:new(4, 128, w:getWidth() - 8, w:getHeight() - (16+128), "", nil, bcToolbar.showHideButton);
	w.buttonTickBox:initialise();
	w:addChild(w.buttonTickBox);

	local i = 1;
	for _,btn in ipairs(bcToolbar.buttons) do
		w.buttonTickBox:addOption(btn.tooltip, nil);
		w.buttonTickBox:setSelected(i, btn:getIsVisible());
		i = i + 1;
	end
end
--}}}
bcToolbar.showHideButton = function(_, key, value)--{{{
	bcToolbar.config.buttons[bcToolbar.configWindow.buttonTickBox.options[key]] = value;
	bcToolbar.resizeToolbar(bcToolbar.config.main.width);
end
--}}}
bcToolbar.bringToTop = function(self)--{{{
	ISCollapsableWindow.bringToTop(self);
	if self.moving then
		bcToolbar.config.position.x = self:getX();
		bcToolbar.config.position.y = self:getY();
		bcToolbar.save();
	end
end
--}}}
bcToolbar.initialise = function()--{{{
	bcToolbar.buttons = {};
	local newConfig = bcUtils.readINI("bcToolbar.ini");
	if newConfig.main then
		bcToolbar.config.main.width = tonumber(newConfig.main.width or "1");
		bcToolbar.config.main.buttonSize = tonumber(newConfig.main.buttonSize or "48");
	end
	if newConfig.buttons then
		for k,v in pairs(newConfig.buttons) do
			bcToolbar.config.buttons[k] = v ~= "false";
		end
	end
	if newConfig.position then
		bcToolbar.config.position.x = tonumber(newConfig.position.x or "0");
		bcToolbar.config.position.y = tonumber(newConfig.position.y or "105");
	end

	bcToolbar.window = ISCollapsableWindow:new(bcToolbar.config.position.x, bcToolbar.config.position.y, bcToolbar.config.main.width * bcToolbar.config.main.buttonSize + 4, bcToolbar.config.main.buttonSize + 4 + 16);
	bcToolbar.window.onRightMouseUp = bcToolbar.showConfig;
	bcToolbar.window:setResizable(false);
	bcToolbar.window:addToUIManager();
	bcToolbar.window.closeButton:setVisible(false);
	bcToolbar.window.backgroundColor = {r=0, g=0, b=0, a=0.5};
	bcToolbar.window.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
	bcToolbar.window.bringToTop = bcToolbar.bringToTop;

	bcToolbar.moveButtonToToolbar(ISEquippedItem.instance.invBtn, getText("UI_ToolbarInventory"));
	bcToolbar.moveButtonToToolbar(ISEquippedItem.instance.healthBtn, getText("UI_ToolbarHealth"));
	bcToolbar.moveButtonToToolbar(ISEquippedItem.instance.craftingBtn, getText("UI_ToolbarCrafting"));
	bcToolbar.moveButtonToToolbar(ISEquippedItem.instance.movableBtn, getText("UI_ToolbarMovable"));

	triggerEvent("bcToolbarAddButtons");
end
--}}}
Events.OnCreatePlayer.Add(bcToolbar.initialise);
LuaEventManager.AddEvent("bcToolbarAddButtons");

ISMoveablesIconPopup.prerender = function(self)
	self:setX(10 + ISEquippedItem.instance.movableBtn:getAbsoluteX());
	self:setY(10 + ISEquippedItem.instance.movableBtn:getAbsoluteY());
	self:setWidth(ISEquippedItem.instance.movableIconPickup:getWidth()*4);
	self:setHeight(ISEquippedItem.instance.movableIconPickup:getHeight());
	self:setAlwaysOnTop(true);
end
