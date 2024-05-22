local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Dropdown = require(script.Parent.Parent.ReactComponents.Dropdown);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);

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
  React.useEffect(function()
    
    game:GetService("ReplicatedStorage").Events.SelectedPartsChanged.Event:Connect(function(selectedParts)
      
      setParts(selectedParts);
      if selectedParts[1] then

        setSelectedOptionIndex(table.find(Enum.Material:GetEnumItems(), selectedParts[1].Material));
        setIsShadowEnabled(selectedParts[1].CastShadow);
        
      else
        
        setSelectedOptionIndex();
        setIsShadowEnabled(false);
        
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
    })
  })

end

return PartMaterialModificationWindow;
