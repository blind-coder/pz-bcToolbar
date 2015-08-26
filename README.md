How to add buttons from other mods:

```` lua
ThisMod.SetupToolbar = function()
	ThisMod.toolbarButton = ISButton:new(0, 0, 64, 64, "FOO", nil, ThisMod.DoSomething);
	bcToolbar.moveButtonToToolbar(ThisMod.toolbarButton, "ThisMod");
end
if getActivatedMods():contains("bcToolbar") then
	require("bcToolbar");
	Events.bcToolbarAddButtons.Add(ThisMod.SetupToolbar);
end
````
