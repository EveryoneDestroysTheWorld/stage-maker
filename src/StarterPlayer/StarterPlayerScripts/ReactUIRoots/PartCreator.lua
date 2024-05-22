--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local Window = require(script.Parent.Parent.ReactComponents.Window);

local handle = Instance.new("ScreenGui");
handle.Name = "PartCreator";
handle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
handle.Parent = game.Players.LocalPlayer.PlayerGui;
handle.Enabled = false;

local root = ReactRoblox.createRoot(handle);
root:render(React.createElement(Window, {
  name = "Create part"; 
  size = UDim2.new(0, 250, 0, 105); 
  onCloseButtonClick = function()
  
    handle.Enabled = false;
    
  end}
));

---

-- Visualizer.lua
-- Written by Christian "Sudobeast" Toney
-- This script helps the player visualize a part before they place it.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

-- Create a preview part.
local previewPart = Instance.new("Part");
previewPart.CanCollide = false;
previewPart.Transparency = 0.4;
previewPart.CanQuery = false;
previewPart.Anchored = true;

local mouse = game:GetService("Players").LocalPlayer:GetMouse();
mouse.TargetFilter = previewPart;

game:GetService("RunService").Heartbeat:Connect(function()

  if handle.Enabled and mouse.Target then 

    -- Find the direction
    previewPart.Position = mouse.Hit.Position + Vector3.new(
      (if mouse.TargetSurface == Enum.NormalId.Right then previewPart.Size.X elseif mouse.TargetSurface == Enum.NormalId.Left then -previewPart.Size.X else 0) / 2,
      (if mouse.TargetSurface == Enum.NormalId.Top then previewPart.Size.Y elseif mouse.TargetSurface == Enum.NormalId.Bottom then -previewPart.Size.Y else 0) / 2,
      (if mouse.TargetSurface == Enum.NormalId.Back then previewPart.Size.Z elseif mouse.TargetSurface == Enum.NormalId.Front then -previewPart.Size.Z else 0) / 2
    );
    previewPart.Parent = workspace;

  else

    previewPart.Parent = nil;

  end

end)

-- Create a part when the player presses the down button.
local mouseButton1DownEvent;
handle:GetPropertyChangedSignal("Enabled"):Connect(function()

  if mouseButton1DownEvent then

    mouseButton1DownEvent:Disconnect();

  end

  if handle.Enabled then

    mouseButton1DownEvent = mouse.Button1Down:Connect(function()

      local originalCFrame = previewPart.CFrame;
      local partID = ReplicatedStorage.Functions.CreatePart:InvokeServer(originalCFrame);
      local selectedPartsChanged = ReplicatedStorage.Events.SelectedPartsChanged;
      selectedPartsChanged:Fire({workspace.Stage:FindFirstChild(partID)});
      ReplicatedStorage.Client.Functions.AddToHistoryStore:Invoke({
        description = "Created <b>Part</b>";
        undo = function()

          ReplicatedStorage.Functions.DestroyPart:InvokeServer(partID);
          selectedPartsChanged:Fire({});

        end,
        redo = function()

          partID = ReplicatedStorage.Functions.CreatePart:InvokeServer(originalCFrame);
          selectedPartsChanged:Fire({workspace.Stage:FindFirstChild(partID)});

        end
      })

    end);

  end

end)