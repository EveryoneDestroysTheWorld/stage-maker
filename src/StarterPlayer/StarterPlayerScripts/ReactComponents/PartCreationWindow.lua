--!strict
-- PartCreationWindow.lua
-- Written by Christian "Sudobeast" Toney
-- This script helps the player visualize a part before they place it.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local Window = require(script.Parent.Window);
local Dropdown = require(script.Parent.Dropdown);

type PartCreationWindowProps = {onClose: () -> ()};

local function PartCreationWindow(props: PartCreationWindowProps)
  
  local previewPartRef = React.useRef(nil);
  local previewPartShape, setPreviewPartShape = React.useState(Enum.PartType.Block);
  local previewPartPosition, setPreviewPartPosition = React.useState(nil);
  local previewPart, setPreviewPart = React.useState(nil);
  React.useEffect(function()

    local mouse = game:GetService("Players").LocalPlayer:GetMouse();
    mouse.TargetFilter = previewPartRef.current;
    
    local heartbeatEvent = game:GetService("RunService").Heartbeat:Connect(function()

      setPreviewPartPosition(function(previewPartPosition)

        local previewPart = previewPartRef.current;
        if previewPart and mouse.Target then 

          -- Find the direction
          return mouse.Hit.Position + Vector3.new(
            (if mouse.TargetSurface == Enum.NormalId.Right then previewPart.Size.X elseif mouse.TargetSurface == Enum.NormalId.Left then -previewPart.Size.X else 0) / 2,
            (if mouse.TargetSurface == Enum.NormalId.Top then previewPart.Size.Y elseif mouse.TargetSurface == Enum.NormalId.Bottom then -previewPart.Size.Y else 0) / 2,
            (if mouse.TargetSurface == Enum.NormalId.Back then previewPart.Size.Z elseif mouse.TargetSurface == Enum.NormalId.Front then -previewPart.Size.Z else 0) / 2
          );

        end;

        return;

      end);

    end);
    
    -- Create a part when the player presses the down button.
    local mouseButton1DownEvent = mouse.Button1Down:Connect(function()

      local previewPart = previewPartRef.current;
      if previewPart then

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

      end;

    end);

    return function()

      heartbeatEvent:Disconnect();
      mouseButton1DownEvent:Disconnect();

    end;
    
  end, {});

  React.useEffect(function()
  
    setPreviewPart(React.createElement("Part", {
      Name = "PreviewPart";
      CanCollide = false;
      Transparency = 0.4;
      CanQuery = false;
      Anchored = true;
      Position = previewPartPosition or Vector3.zero;
      Shape = previewPartShape;
      ref = previewPartRef;
    }));

  end, {previewPartPosition, previewPartShape :: any});

  local dropdownOptions = {};
  for index, partType in ipairs(Enum.PartType:GetEnumItems()) do

    table.insert(dropdownOptions, {
      text = partType.Name;
      onClick = function()

        setPreviewPartShape(partType);

      end;
    });

  end;
  
  return React.createElement(Window, {
    name = "Create part"; 
    size = UDim2.new(0, 250, 0, 165); 
    onCloseButtonClick = function() props.onClose() end;
  }, {
    React.createElement(Dropdown, {selectedIndex = table.find(Enum.PartType:GetEnumItems(), previewPartShape); options = dropdownOptions});
    if previewPartPosition then 
      ReactRoblox.createPortal({previewPart}, workspace) 
    else previewPart;
  });

end

return PartCreationWindow;