local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local ReactComponents = script.Parent.Parent.ReactComponents;
local PartPositionModificationWindow = require(ReactComponents.PartPositionModificationWindow);
local PartMaterialModificationWindow = require(ReactComponents.PartMaterialModificationWindow);
local PartOrientationModificationWindow = require(ReactComponents.PartOrientationModificationWindow);
local PartCreationWindow = require(ReactComponents.PartCreationWindow);
local PartColorModificationWindow = require(ReactComponents.PartColorModificationWindow);
local PartAnchorModificationWindow = require(ReactComponents.PartAnchorModificationWindow);
local PartCollisionModificationWindow = require(ReactComponents.PartCollisionModificationWindow);
local PartDurabilityModificationWindow = require(ReactComponents.PartDurabilityModificationWindow);
local PartSurfaceModificationWindow = require(ReactComponents.PartSurfaceModificationWindow);
local BuildingToolsSelector = require(ReactComponents.BuildingToolsSelector);

local player = game:GetService("Players").LocalPlayer;

local handle = Instance.new("ScreenGui");
handle.Name = "BuildingTools";
handle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
handle.Parent = player.PlayerGui;
handle.Enabled = true;

local root = ReactRoblox.createRoot(handle);

export type BuildingToolsWindowProps = {onClose: () -> ()};

local function BuildingToolsContainer()

  local selectedParts, setSelectedParts = React.useState({});
  local highlights, setHighlights = React.useState({});
  React.useEffect(function()

    ReplicatedStorage.Shared.Events.SelectedPartsChanged.Event:Connect(function(selectedParts)

      local highlights = {};
      for _, part in ipairs(selectedParts) do

        table.insert(highlights, React.createElement("Highlight", {
          Name = part.Name;
          FillTransparency = 1; 
          Adornee = part;
        }));

      end

      setHighlights(highlights);
      setSelectedParts(selectedParts);

    end)
    
  end, {});

  local selectedWindow, setSelectedWindow = React.useState(React.createElement(React.Fragment));
  local globalProps = {
    parts = selectedParts; 
    onClose = function() setSelectedWindow(React.createElement(React.Fragment)) end;
    updateParts = function(newProperties) 
    
      local partIds = {};
      for _, part in ipairs(selectedParts) do
    
        table.insert(partIds, part.Name);
    
      end;

      ReplicatedStorage.Shared.Functions.UpdateParts:InvokeServer(partIds, newProperties);

    end;
  };
  
  local sections = {
    {
      name = "CreationTools";
      buttons = {{
        name = "CreateButton";
        iconImage = "rbxassetid://17546996412";
        onClick = function() setSelectedWindow(React.createElement(PartCreationWindow, globalProps)); end;
      }}
    }, {
      name = "ModificationTools";
      disabled = not selectedParts[1];
      buttons = {
        {
          name = "MoveButton";
          iconImage = "rbxassetid://17547020218";
          onClick = function() setSelectedWindow(React.createElement(PartPositionModificationWindow, globalProps)); end;
        }, {
          name = "ResizeButton";
          iconImage = "rbxassetid://17547037235";
          onClick = function() setSelectedWindow(React.createElement(PartOrientationModificationWindow, globalProps)); end;
        }, {
          name = "OrientationButton";
          iconImage = "rbxassetid://17547019914";
          onClick = function() setSelectedWindow(React.createElement(PartOrientationModificationWindow, globalProps)); end;
        }, {
          name = "ColorButton";
          iconImage = "rbxassetid://17550945994";
          onClick = function() setSelectedWindow(React.createElement(PartColorModificationWindow, globalProps)); end;
        }, {
          name = "MaterialButton";
          iconImage = "rbxassetid://17551063892";
          onClick = function() setSelectedWindow(React.createElement(PartMaterialModificationWindow, globalProps)); end;
        }, {
          name = "AnchorButton";
          iconImage = "rbxassetid://17550968289";
          onClick = function() setSelectedWindow(React.createElement(PartAnchorModificationWindow, globalProps)); end;
        }, {
          name = "CollisionButton";
          iconImage = "rbxassetid://17551046771";
          onClick = function() setSelectedWindow(React.createElement(PartCollisionModificationWindow, globalProps)); end;
        }, {
          name = "SurfaceButton";
          iconImage = "rbxassetid://17550959976";
          onClick = function() setSelectedWindow(React.createElement(PartSurfaceModificationWindow, globalProps)); end;
        }, {
          name = "DurabilityButton";
          iconImage = "rbxassetid://17551033481";
          onClick = function() setSelectedWindow(React.createElement(PartDurabilityModificationWindow, globalProps)); end;
        }
      }
    }
  };

  -- Set up the select tool.
  local target: BasePart?, setTarget = React.useState(nil);
  React.useEffect(function()

    game:GetService("RunService").Heartbeat:Connect(function()
    
      local target = player:GetMouse().Target;
      setTarget(if target and target.Parent == workspace.Stage then target else nil);

    end);

  end, {});

  React.useEffect(function()
  
    local mouse = player:GetMouse();
    local mouseButtonDownEvent = mouse.Button1Down:Connect(function()
    
      local target = mouse.Target;
      if target and target.Parent == workspace.Stage then

        local newSelectedParts = {mouse.Target};
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then

          newSelectedParts = selectedParts;
          local index = table.find(newSelectedParts, target);
          if index then

            table.remove(newSelectedParts, index);

          else

            table.insert(newSelectedParts, target);

          end;

        end;
        
        ReplicatedStorage.Shared.Events.SelectedPartsChanged:Fire(newSelectedParts);

      else

        ReplicatedStorage.Shared.Events.SelectedPartsChanged:Fire({});

      end;

    end);

    return function()

      mouseButtonDownEvent:Disconnect();

    end;

  end, {selectedParts});
  
  return React.createElement(React.StrictMode, {}, {
    React.createElement(BuildingToolsSelector, {sections = sections});
    selectedWindow;
    React.createElement("Folder", {
      Name = "Selections";
    }, {
      highlights, 
      React.createElement("Highlight", {
        Name = "Highlight";
        Adornee = target;
        FillTransparency = 1;
        OutlineTransparency = 0.6;
      });});
  });
  
end

root:render(React.createElement(BuildingToolsContainer));
