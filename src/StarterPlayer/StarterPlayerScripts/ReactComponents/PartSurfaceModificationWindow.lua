local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);

type PartSurfaceModificationWindowProps = {onClose: () -> (); parts: {BasePart}; updateParts: (newProperties: any) -> ()};

local function PartSurfaceModificationWindow(props: PartSurfaceModificationWindowProps)

  local isAnchored, setIsAnchored = React.useState(false);
  
  React.useEffect(function()
    
    local events = {};
    for i, part in ipairs(props.parts) do
      
      if i == 1 then
        
        table.insert(events, part:GetPropertyChangedSignal("Anchored"):Connect(function()

          setIsAnchored(part.Anchored);

        end))
        
      end
      
    end;
    
    return function()
      
      for _, event in ipairs(events) do
        
        event:Disconnect();
        
      end
      
    end
    
  end, {props.parts});
  
  return React.createElement(Window, {
    name = "Surfaces"; 
    size = UDim2.new(0, 250, 0, 135); 
    onCloseButtonClick = props.onClose;
  }, {
    React.createElement(Checkbox, {
      text = "Anchored";
      isChecked = isAnchored;
      onClick = function()
        
        local possiblePart = props.parts[1];
        if possiblePart then
          
          local isAnchored = not possiblePart.Anchored;
          for _, part in ipairs(props.parts) do
            
            part.Anchored = isAnchored;
            
          end
          
        end
        
      end;
    });
  })

end

return PartSurfaceModificationWindow;