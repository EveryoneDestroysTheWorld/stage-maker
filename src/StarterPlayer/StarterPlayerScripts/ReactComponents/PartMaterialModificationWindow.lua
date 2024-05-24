local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Dropdown = require(script.Parent.Parent.ReactComponents.Dropdown);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);
local NumberInput = require(script.Parent.Parent.ReactComponents.NumberInput);

type PartMaterialModificationWindowProps = {onClose: () -> (); parts: {BasePart}; updateParts: (newProperties: any) -> ()};

local function PartMaterialModificationWindow(props: PartMaterialModificationWindowProps)
  
  local selectedOptionIndex, setSelectedOptionIndex = React.useState(nil);
  
  local dropdownOptions = {};
  for index, material in ipairs(Enum.Material:GetEnumItems()) do
    
    table.insert(dropdownOptions, {
      text = material.Name;
      onClick = function()
        
        props.updateParts({Material = material});
        
      end;
    });
    
  end;

  local isShadowEnabled: boolean, setIsShadowEnabled = React.useState(false);
  local transparency: number?, setTransparency = React.useState(nil);
  local reflectance: number?, setReflectance = React.useState(nil);
  React.useEffect(function()

    local firstPart = props.parts[1];
    if firstPart then

      local function updateVariables()

        setSelectedOptionIndex(table.find(Enum.Material:GetEnumItems(), firstPart.Material));
        setIsShadowEnabled(firstPart.CastShadow);
        setReflectance(firstPart.Reflectance);
        setTransparency(firstPart.Transparency);

      end;

      local event = firstPart:GetPropertyChangedSignal("Material"):Connect(updateVariables);
      updateVariables();

      return function()

        event:Disconnect();

      end;
      
      
    else
      
      setSelectedOptionIndex();
      setIsShadowEnabled(false);
      setReflectance();
      setTransparency();
      
    end

    return;
    
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
      onClick = function(newValue)

        props.updateParts({CastShadow = not isShadowEnabled});

      end;
    });
    React.createElement(NumberInput, {
      label = "Transparency";
      value = transparency;
      onChange = function(newValue)

        props.updateParts({Transparency = if newValue > 0.8 then 0.8 else newValue});

      end;
    });
    React.createElement(NumberInput, {
      label = "Reflectance";
      reflectance = reflectance;
      onChange = function(newValue)

        props.updateParts({Reflectance = newValue});

      end;
    });
  })

end

return PartMaterialModificationWindow;