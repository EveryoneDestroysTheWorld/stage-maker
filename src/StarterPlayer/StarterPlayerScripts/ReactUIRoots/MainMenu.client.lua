local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local ReactComponents = script.Parent.Parent.ReactComponents;
local StagesScreen = require(ReactComponents.StagesScreen);
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local StarterGui = game:GetService("StarterGui");

local player = game:GetService("Players").LocalPlayer;

local handle = Instance.new("ScreenGui");
handle.Name = "MainMenu";
handle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
handle.Parent = player.PlayerGui;
handle.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets;
handle.DisplayOrder = 1;
handle.Enabled = true;

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);

local root = ReactRoblox.createRoot(handle);

local function MainMenuContainer()
  
  return React.createElement(React.StrictMode, {}, {
    Screen = React.createElement(StagesScreen, {
      onStageDownloaded = function()

        handle.Enabled = false;
        ReplicatedStorage.Shared.Functions.LoadCharacter:InvokeServer();
        TweenService:Create(Lighting.Blur, TweenInfo.new(), {Size = 0}):Play();
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true);

      end;
    });
  });
  
end

root:render(React.createElement(MainMenuContainer));
