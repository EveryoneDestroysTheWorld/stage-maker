local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local player = game:GetService("Players").LocalPlayer;
local ReactComponents = script.Parent.Parent:WaitForChild("ReactComponents");
local StageUnpublishConfirmationPopup = require(ReactComponents.StageUnpublishConfirmationPopup);

local handle = Instance.new("ScreenGui");
handle.Name = "StageUnpublishConfirmationPopup";
handle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
handle.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets;
handle.ResetOnSpawn = false;
handle.DisplayOrder = 1;
handle.Enabled = true;

local root = ReactRoblox.createRoot(handle);

local function StageDeletionConfirmationPopupContainer()

  local stage, setStage = React.useState(nil);

  React.useEffect(function()
  
    ReplicatedStorage.Client.Functions.MarkStageForUnpublishing.OnInvoke = function(stage)

      setStage(stage);

    end;

  end, {});

  React.useEffect(function()
  
    handle.Parent = if stage then player.PlayerGui else ReplicatedStorage.Client.UI;

  end, {stage});

  return if stage then React.createElement(React.StrictMode, {}, {
    Popup = React.createElement(StageUnpublishConfirmationPopup, {
      stage = stage;
      onClose = function()

        setStage(nil);

      end;
    });
  }) else nil;
  
end;

-- Render the GUI.
root:render(React.createElement(StageDeletionConfirmationPopupContainer));