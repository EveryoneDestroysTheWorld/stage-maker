local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Dropdown = require(script.Parent.Parent.ReactComponents.Dropdown);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);
local NumberInput = require(script.Parent.Parent.ReactComponents.NumberInput);

type PartMaterialModificationWindowProps = {handle: ScreenGui};

local function PartMaterialModificationWindow(props: PartMaterialModificationWindowProps)
  
  local parts, setParts = React.useState({});
  local selectedOptionIndex, setSelectedOptionIndex = React.useState(nil);
  
  local dropdownOptions = {};
  for index, material in ipairs(Enum.Material:GetEnumItems()) do
    
    table.insert(dropdownOptions, {
      text = material.Name;
      onClick = function()
        
        setSelectedOptionIndex(index);
        for _, part in ipairs(parts) do
          
          part.Material = material;
          
        end
        
      end;
    });
    
  end;

  local isShadowEnabled, setIsShadowEnabled = React.useState(false);
  local transparency, setTransparency = React.useState(nil);
  local reflectance, setReflectance = React.useState(nil);
  React.useEffect(function()
    
    game:GetService("ReplicatedStorage").Events.SelectedPartsChanged.Event:Connect(function(selectedParts)
      
      setParts(selectedParts);
      if selectedParts[1] then

        setSelectedOptionIndex(table.find(Enum.Material:GetEnumItems(), selectedParts[1].Material));
        setIsShadowEnabled(selectedParts[1].CastShadow);
        setReflectance(selectedParts[1].Reflectance);
        setTransparency(selectedParts[1].Transparency);
        
      else
        
        setSelectedOptionIndex();
        setIsShadowEnabled(false);
        setReflectance();
        setTransparency();
        
      end
      
    end)
    
  end, {});
  
  
  return React.createElement(Window, {
    name = "Material"; 
    size = UDim2.new(0, 250, 0, 135); 
    onCloseButtonClick = function()

      props.handle.Enabled = false;

    end
  }, {
    React.createElement(Dropdown, {selectedIndex = selectedOptionIndex; options = dropdownOptions});
    React.createElement(Checkbox, {
      text = "Cast shadow";
      isChecked = isShadowEnabled;
      onClick = function()
        
        if parts[1] then
          
          local castShadow = not parts[1].CastShadow;
          for _, part in ipairs(parts) do
            
            part.CastShadow = castShadow;
            
          end
          setIsShadowEnabled(castShadow);
          
        end
        
      end;
    });
    React.createElement(NumberInput, {
      label = "Transparency";
      value = transparency;
      onChange = function(newValue)
        
        if parts[1] then
          
          newValue = if newValue > 0.8 then 0.8 else newValue;
          
          for _, part in ipairs(parts) do

            part.Transparency = newValue;

          end
          setTransparency(parts[1].Transparency);
          
        end
        
      end;
    });
    React.createElement(NumberInput, {
      label = "Reflectance";
      reflectance = reflectance;
      onChange = function(newValue)

        if parts[1] then

          for _, part in ipairs(parts) do

            part.Reflectance = newValue;

          end
          setReflectance(parts[1].Reflectance);

        end

      end;
    });
  })

end

return PartMaterialModificationWindow;