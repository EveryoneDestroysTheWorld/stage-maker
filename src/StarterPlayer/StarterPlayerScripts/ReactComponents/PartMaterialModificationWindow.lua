local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Dropdown = require(script.Parent.Parent.ReactComponents.Dropdown);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);
local NumberInput = require(script.Parent.Parent.ReactComponents.NumberInput);

type PartMaterialModificationWindowProps = {onClose: () -> (); parts: {BasePart?}};

local function PartMaterialModificationWindow(props: PartMaterialModificationWindowProps)
  
  local selectedOptionIndex, setSelectedOptionIndex = React.useState(nil);
  
  local dropdownOptions = {};
  for index, material in ipairs(Enum.Material:GetEnumItems()) do
    
    table.insert(dropdownOptions, {
      text = material.Name;
      onClick = function()
        
        setSelectedOptionIndex(index);
        for _, part in ipairs(props.parts) do
          
          part.Material = material;
          
        end
        
      end;
    });
    
  end;

  local isShadowEnabled: boolean, setIsShadowEnabled = React.useState(false);
  local transparency: number?, setTransparency = React.useState(nil);
  local reflectance: number?, setReflectance = React.useState(nil);
  React.useEffect(function()

    local firstPart = props.parts[1];
    if firstPart then

      setSelectedOptionIndex(table.find(Enum.Material:GetEnumItems(), firstPart.Material));
      setIsShadowEnabled(firstPart.CastShadow);
      setReflectance(firstPart.Reflectance);
      setTransparency(firstPart.Transparency);
      
    else
      
      setSelectedOptionIndex();
      setIsShadowEnabled(false);
      setReflectance();
      setTransparency();
      
    end
    
  end, {props.parts});
  
  return React.createElement(Window, {
    name = "Material"; 
    size = UDim2.new(0, 250, 0, 135); 
    onCloseButtonClick = props.onClose;
  }, {
    React.createElement(Dropdown, {selectedIndex = selectedOptionIndex; options = dropdownOptions});
    React.createElement(Checkbox, {
      text = "Cast shadow";
      isChecked = isShadowEnabled;
      onClick = function()
        
        local firstPart = props.parts[1];
        if firstPart then
          
          local castShadow = not firstPart.CastShadow;
          for _, part in ipairs(props.parts) do
            
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
        
        local firstPart = props.parts[1];
        if firstPart then
          
          newValue = if newValue > 0.8 then 0.8 else newValue;
          
          for _, part in ipairs(props.parts) do

            part.Transparency = newValue;

          end
          setTransparency(firstPart.Transparency);
          
        end
        
      end;
    });
    React.createElement(NumberInput, {
      label = "Reflectance";
      reflectance = reflectance;
      onChange = function(newValue)

        local firstPart = props.parts[1];
        if firstPart then

          for _, part in ipairs(props.parts) do

            part.Reflectance = newValue;

          end
          setReflectance(firstPart.Reflectance);

        end

      end;
    });
  })

end

return PartMaterialModificationWindow;