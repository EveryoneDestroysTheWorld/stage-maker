local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local PartMaterialModificationWindow = require(script.Parent.Parent.ReactComponents.PartMaterialModificationWindow);
local PartOrientationModificationWindow = require(script.Parent.Parent.ReactComponents.PartOrientationModificationWindow);
local PartCreationWindow = require(script.Parent.Parent.ReactComponents.PartCreationWindow);

local handleInfo = {
  {"PartMaterialModifier", PartMaterialModificationWindow};
  {"PartOrientationModifier", PartOrientationModificationWindow};
  {"PartCreator", PartCreationWindow};
}

for _, handleData in ipairs(handleInfo) do
  
  local handle = Instance.new("ScreenGui");
  handle.Name = handleData[1];
  handle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
  handle.Parent = game.Players.LocalPlayer.PlayerGui;
  handle.Enabled = false;

  local root = ReactRoblox.createRoot(handle);

  root:render(React.createElement(handleData[2], {handle = handle}));
  
end

