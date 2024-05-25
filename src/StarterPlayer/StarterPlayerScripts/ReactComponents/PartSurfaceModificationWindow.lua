local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Window);
local Dropdown = require(script.Parent.Dropdown);

type PartSurfaceModificationWindowProps = {onClose: () -> (); parts: {BasePart}; updateParts: (newProperties: any) -> ()};

local function PartSurfaceModificationWindow(props: PartSurfaceModificationWindowProps)
  
  local selectedSurface, setSelectedSurface = React.useState("All");
  local selectedSurfaceType: Enum.SurfaceType?, setSelectedSurfaceType = React.useState(nil);
  local surfaces = {"Back", "Bottom", "Front", "Left", "Right", "Top"};
  React.useEffect(function()
    
    local events = {};
    local firstPart = props.parts[1];
    if firstPart then

      if selectedSurface == "All" then

        local function doSurfacesMatch()

          for _, surface in ipairs(surfaces) do

            if firstPart[`{surface}Surface`] ~= firstPart.BackSurface then

              return false;

            end;

          end;

          return true;

        end;
      
        for _, surface in ipairs(surfaces) do

          local propertyName = `{surface}Surface`;
          table.insert(events, firstPart:GetPropertyChangedSignal(propertyName):Connect(function()
        
            setSelectedSurfaceType(if doSurfacesMatch() then firstPart[propertyName] else nil);
  
          end));

        end;

        setSelectedSurfaceType(if doSurfacesMatch() then firstPart.BackSurface else nil);

      else

        table.insert(events, firstPart:GetPropertyChangedSignal(`{selectedSurface}Surface`):Connect(function()
        
          setSelectedSurfaceType(firstPart[`{selectedSurface}Surface`]);

        end));
        setSelectedSurfaceType(firstPart[`{selectedSurface}Surface`]);

      end;

    end;
    
    return function()
      
      for _, event in ipairs(events) do
        
        event:Disconnect();
        
      end
      
    end
    
  end, {props.parts, selectedSurface});

  local surfaceDropdownOptions = {{
    text = "All",
    onClick = function()

      setSelectedSurface("All");
    
    end;
  }};
  for _, surface in ipairs(surfaces) do

    table.insert(surfaceDropdownOptions, {
      text = surface;
      onClick = function()

        setSelectedSurface(surface);

      end;
    })

  end;

  local typeDropdownOptions = {};
  for _, surfaceType in ipairs(Enum.SurfaceType:GetEnumItems()) do

    table.insert(typeDropdownOptions, {
      text = surfaceType.Name;
      onClick = function()

        if selectedSurface == "All" then

          local newProperties = {};
          for _, surface in ipairs(surfaces) do

            newProperties[`{surface}Surface`] = surfaceType;

          end;
          props.updateParts(newProperties);

        else

          props.updateParts({[`{selectedSurface}Surface`] = surfaceType});

        end;

      end;
    });

  end;

  local surfacesWithAll = table.clone(surfaces);
  table.insert(surfacesWithAll, 1, "All");
  
  return React.createElement(Window, {
    name = "Surfaces"; 
    size = UDim2.new(0, 250, 0, 175); 
    onCloseButtonClick = props.onClose;
  }, {
    React.createElement(Dropdown, {
      label = "Side";
      selectedIndex = table.find(surfacesWithAll, selectedSurface);
      options = surfaceDropdownOptions;
    });
    React.createElement(Dropdown, {
      label = "Type";
      selectedIndex = table.find(Enum.SurfaceType:GetEnumItems(), selectedSurfaceType);
      options = typeDropdownOptions;
    });
  })

end

return PartSurfaceModificationWindow;