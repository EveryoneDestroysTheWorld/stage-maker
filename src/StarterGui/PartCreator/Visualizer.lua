--!strict
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
  
  if script.Parent.Enabled and mouse.Target then 
    
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
script.Parent:GetPropertyChangedSignal("Enabled"):Connect(function()
  
  if mouseButton1DownEvent then
    
    mouseButton1DownEvent:Disconnect();
    
  end
  
  if script.Parent.Enabled then
    
    mouseButton1DownEvent = mouse.Button1Down:Connect(function()
      
      local originalCFrame = previewPart.CFrame;
      local partID = ReplicatedStorage.Functions.CreatePart:InvokeServer(originalCFrame);
      local selectedPartsChanged = ReplicatedStorage.Events.SelectedPartsChanged;
      selectedPartsChanged:Fire({workspace.Stage:FindFirstChild(partID)});
      game:GetService("Players").LocalPlayer.PlayerGui.History.HistoryHandler.AddToHistoryStore:Invoke({
        label = "Created <b>Part</b>";
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
