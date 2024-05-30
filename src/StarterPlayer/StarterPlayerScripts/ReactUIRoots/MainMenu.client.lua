local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local ReactComponents = script.Parent.Parent.ReactComponents;
local StagesScreen = require(ReactComponents.StagesScreen);
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local StarterGui = game:GetService("StarterGui");
local TextChatService = game:GetService("TextChatService");

local player = game:GetService("Players").LocalPlayer;

local handle = Instance.new("ScreenGui");
handle.Name = "MainMenu";
handle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
handle.Parent = player.PlayerGui;
handle.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets;
handle.ResetOnSpawn = false;
handle.DisplayOrder = 1;
handle.Enabled = true;

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);

local root = ReactRoblox.createRoot(handle);

local function MainMenuContainer()

  React.useEffect(function()
  
    TweenService:Create(Lighting.Blur, TweenInfo.new(), {Size = 8}):Play();

  end, {});
  
  return React.createElement(React.StrictMode, {}, {
    -- Screen = React.createElement(StagesScreen, {
    Screen = React.createElement(require(ReactComponents.PublishScreen), {
      onStageDownloaded = function()

        ReplicatedStorage.Shared.Functions.LoadCharacter:InvokeServer();
        TweenService:Create(Lighting.Blur, TweenInfo.new(), {Size = 0}):Play();
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true);
        handle.Enabled = false;

      end;
    });
  });
  
end;

-- Handle the commands.
TextChatService.Commands.StagesCommand.Triggered:Connect(function()

  handle.Enabled = true;
  StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);

end);

-- Render the GUI.
root:render(React.createElement(MainMenuContainer));