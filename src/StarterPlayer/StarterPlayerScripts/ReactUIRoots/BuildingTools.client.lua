local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
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
local PartSizeModificationWindow = require(ReactComponents.PartSizeModificationWindow);
local BuildingToolsSelector = require(ReactComponents.BuildingToolsSelector);

local player = game:GetService("Players").LocalPlayer;

local handle = Instance.new("ScreenGui");
handle.Name = "BuildingTools";
handle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
handle.Parent = player.PlayerGui;
handle.ResetOnSpawn = false;
handle.Enabled = false;

local root = ReactRoblox.createRoot(handle);

export type BuildingToolsWindowProps = {onClose: () -> ()};

Players.LocalPlayer.CharacterAdded:Connect(function()

  handle.Enabled = true;

end);

local function BuildingToolsContainer()

  local selectedParts: {Part | TrussPart}, setSelectedParts = React.useState({});
  local highlights: {Highlight}, setHighlights = React.useState({});
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

  local selectedWindow, setSelectedWindow = React.useState(React.Fragment);
  
  local sections = {
    {
      name = "CreationTools";
      buttons = {{
        name = "CreateButton";
        iconImage = "rbxassetid://17546996412";
        window = PartCreationWindow;
      }}
    }, {
      name = "ModificationTools";
      disabled = not selectedParts[1];
      buttons = {
        {
          name = "MoveButton";
          iconImage = "rbxassetid://17547020218";
          window = PartPositionModificationWindow;
        }, {
          name = "ResizeButton";
          iconImage = "rbxassetid://17547037235";
          window = PartSizeModificationWindow;
        }, {
          name = "OrientationButton";
          iconImage = "rbxassetid://17547019914";
          window = PartOrientationModificationWindow;
        }, {
          name = "ColorButton";
          iconImage = "rbxassetid://17550945994";
          window = PartColorModificationWindow;
        }, {
          name = "MaterialButton";
          iconImage = "rbxassetid://17551063892";
          window = PartMaterialModificationWindow;
        }, {
          name = "AnchorButton";
          iconImage = "rbxassetid://17550968289";
          window = PartAnchorModificationWindow;
        }, {
          name = "CollisionButton";
          iconImage = "rbxassetid://17551046771";
          window = PartCollisionModificationWindow;
        }, {
          name = "SurfaceButton";
          iconImage = "rbxassetid://17550959976";
          window = PartSurfaceModificationWindow;
        }, {
          name = "DurabilityButton";
          iconImage = "rbxassetid://17551033481";
          window = PartDurabilityModificationWindow;
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
      local newSelectedParts = {};
      if target and target.Parent == workspace.Stage then

        table.insert(newSelectedParts, target);
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then

          newSelectedParts = selectedParts;
          local index = table.find(newSelectedParts, target);
          if index then

            table.remove(newSelectedParts, index);

          else

            table.insert(newSelectedParts, target);

          end;

        end;

      end;

      ReplicatedStorage.Shared.Events.SelectedPartsChanged:Fire(newSelectedParts);

    end);

    return function()

      mouseButtonDownEvent:Disconnect();

    end;

  end, {selectedParts});

  return React.createElement(React.StrictMode, {}, {
    React.createElement(BuildingToolsSelector, {
      sections = sections;
      onWindowChange = function(window)

        setSelectedWindow(function() return window end);

      end;
    });
    React.createElement(selectedWindow, {
      parts = selectedParts; 
      onClose = function() setSelectedWindow(React.Fragment) end;
      updateParts = function(newProperties) 
      
        local partIds = {};
        for _, part in ipairs(selectedParts) do
      
          table.insert(partIds, part.Name);
      
        end;
  
        ReplicatedStorage.Shared.Functions.UpdateParts:InvokeServer(partIds, newProperties);
  
      end;
    });
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
  
end;

ReplicatedStorage.Shared.Events.BuildingToolsToggled.OnClientEvent:Connect(function(areBuildingToolsEnabled: boolean)

  handle.Enabled = areBuildingToolsEnabled;

end);

root:render(React.createElement(BuildingToolsContainer));
