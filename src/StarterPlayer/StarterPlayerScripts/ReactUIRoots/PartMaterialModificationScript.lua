--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local PartMaterialModificationWindow = require(script.Parent.Parent.ReactComponents.PartMaterialModificationWindow);

local handle = Instance.new("ScreenGui");
handle.Name = "PartMaterialModifier";
handle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
handle.Parent = game.Players.LocalPlayer.PlayerGui;
handle.Enabled = false;

local root = ReactRoblox.createRoot(handle);

root:render(React.createElement(PartMaterialModificationWindow, {handle = handle}));