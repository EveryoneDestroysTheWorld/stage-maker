--!strict
-- PartCreationWindow.lua
-- Written by Christian "Sudobeast" Toney
-- This script helps the player visualize a part before they place it.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Dropdown = require(script.Parent.Parent.ReactComponents.Dropdown);

type PartCreationWindowProps = {onClose: () -> ()};

local function PartCreationWindow(props: PartCreationWindowProps)
  
  local previewPart = React.useState(Instance.new("Part"));

  local selectedOptionIndex, setSelectedOptionIndex = React.useState(table.find(Enum.PartType:GetEnumItems(), previewPart.Shape));
  React.useEffect(function()

    local mouse = game:GetService("Players").LocalPlayer:GetMouse();
    mouse.TargetFilter = previewPart;
    previewPart.CanCollide = false;
    previewPart.Transparency = 0.4;
    previewPart.CanQuery = false;
    previewPart.Anchored = true;
    local shapeChangeEvent = previewPart:GetPropertyChangedSignal("Shape"):Connect(function()
      
      setSelectedOptionIndex(table.find(Enum.PartType:GetEnumItems(), previewPart.Shape));
      
    end)
    
    local heartbeatEvent = game:GetService("RunService").Heartbeat:Connect(function()

      if mouse.Target then 

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

    end);
    
    -- Create a part when the player presses the down button.
    local mouseButton1DownEvent = mouse.Button1Down:Connect(function()

      local originalPartData = {
        CFrame = previewPart.CFrame;
        Shape = previewPart.Shape;
      };
      local partID = ReplicatedStorage.Shared.Functions.CreatePart:InvokeServer(originalPartData);
      local selectedPartsChanged = ReplicatedStorage.Shared.Events.SelectedPartsChanged;
      selectedPartsChanged:Fire({workspace.Stage:FindFirstChild(partID)});
      ReplicatedStorage.Client.Functions.AddToHistoryStore:Invoke({
        description = "Created <b>Part</b>";
        undo = function()

          ReplicatedStorage.Shared.Functions.DestroyPart:InvokeServer(partID);
          selectedPartsChanged:Fire({});

        end,
        redo = function()

          partID = ReplicatedStorage.Shared.Functions.CreatePart:InvokeServer(originalPartData);
          selectedPartsChanged:Fire({workspace.Stage:FindFirstChild(partID)});

        end
      })

    end);

    return function()

      previewPart:Destroy();
      shapeChangeEvent:Disconnect();
      heartbeatEvent:Disconnect();
      mouseButton1DownEvent:Disconnect();

    end;
    
  end, {});

  local dropdownOptions = {};
  for index, partType in ipairs(Enum.PartType:GetEnumItems()) do

    table.insert(dropdownOptions, {
      text = partType.Name;
      onClick = function()

        previewPart.Shape = partType;

      end;
    });

  end;
  
  return React.createElement(Window, {
    name = "Create part"; 
    size = UDim2.new(0, 250, 0, 165); 
    onCloseButtonClick = props.onClose;
  }, {
    React.createElement(Dropdown, {selectedIndex = selectedOptionIndex; options = dropdownOptions}) 
  });

end

return PartCreationWindow;