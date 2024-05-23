local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local PartMaterialModificationWindow = require(script.Parent.Parent.ReactComponents.PartMaterialModificationWindow);
local PartOrientationModificationWindow = require(script.Parent.Parent.ReactComponents.PartOrientationModificationWindow);
local PartCreationWindow = require(script.Parent.Parent.ReactComponents.PartCreationWindow);
local PartAnchorModificationWindow = require(script.Parent.Parent.ReactComponents.PartAnchorModificationWindow);
local PartCollisionModificationWindow = require(script.Parent.Parent.ReactComponents.PartCollisionModificationWindow);
local PartDurabilityModificationWindow = require(script.Parent.Parent.ReactComponents.PartDurabilityModificationWindow);
local PartSurfaceModificationWindow = require(script.Parent.Parent.ReactComponents.PartSurfaceModificationWindow);
local BuildingToolsSelector = require(script.Parent.Parent.ReactComponents.BuildingToolsSelector);

local handle = Instance.new("ScreenGui");
handle.Name = "BuildingTools";
handle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
handle.Parent = game.Players.LocalPlayer.PlayerGui;
handle.Enabled = false;

local root = ReactRoblox.createRoot(handle);

export type BuildingToolsWindowProps = {onClose: () -> ()};

local function BuildingToolsContainer()

  local selectedParts, setSelectedParts = React.useState({});
  React.useEffect(function()
    
    ReplicatedStorage.Events.SelectedPartsChanged.Event:Connect(function(newSelectedParts)

      setSelectedParts(selectedParts);

    end)
    
  end, {});
  
  local selectedWindow, setSelectedWindow = React.useState(nil);
  
  local sections = {
    {
      name = "CreationTools";
      buttons = {{
        name = "CreateButton";
        iconImage = "rbxassetid://17546996412";
        onClick = function() setSelectedWindow(PartCreationWindow) end;
      }}
    }, {
      name = "ModificationTools";
      buttons = {
        {
          name = "ColorButton";
          iconImage = "rbxassetid://17550945994";
          onClick = function() setSelectedWindow(PartColorModificationWindow) end;
        }, {
          name = "MaterialButton";
          iconImage = "rbxassetid://17551063892";
          onClick = function() setSelectedWindow(PartMaterialModificationWindow) end;
        }, {
          name = "OrientationButton";
          iconImage = "rbxassetid://17547019914";
          onClick = function() setSelectedWindow(PartOrientationModificationWindow) end;
        }, {
          name = "AnchorButton";
          iconImage = "rbxassetid://17551033481";
          onClick = function() setSelectedWindow(PartAnchorModificationWindow) end;
        }, {
          name = "CollisionButton";
          iconImage = "rbxassetid://17551046771";
          onClick = function() setSelectedWindow(PartCollisionModificationWindow) end;
        }, {
          name = "DurabilityButton";
          iconImage = "rbxassetid://17550968289";
          onClick = function() setSelectedWindow(PartDurabilityModificationWindow) end;
        }, {
          name = "SurfaceButton";
          iconImage = "rbxassetid://17550959976";
          onClick = function() setSelectedWindow(PartSurfaceModificationWindow) end;
        }, 
      }
    }
  };
  
  
  return React.createElement(React.Fragment, {}, {
    React.createElement(BuildingToolsSelector, {sections = sections});
    selectedWindow;
  });
  
end

root:render(React.createElement(BuildingToolsContainer));

