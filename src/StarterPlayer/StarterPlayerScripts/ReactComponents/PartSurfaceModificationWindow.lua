local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);

type PartAnchorModificationWindowProps = {handle: ScreenGui};

local function PartAnchorModificationWindow(props: PartAnchorModificationWindowProps)
  
  local parts: {BasePart?}, setParts = React.useState({});

  local isAnchored, setIsAnchored = React.useState(false);
  
  React.useEffect(function()
    
    local events = {};
    for i, part in ipairs(parts) do
      
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
    
  end, {parts});
  
  React.useEffect(function()
    
    game:GetService("ReplicatedStorage").Events.SelectedPartsChanged.Event:Connect(function(selectedParts)
      
      setParts(selectedParts);
      if selectedParts[1] then

        setIsAnchored(selectedParts[1].Anchored);
        
      else
        
        setIsAnchored(false)
        
      end
      
    end)
    
  end, {});
  
  
  return React.createElement(Window, {
    name = "Anchor"; 
    size = UDim2.new(0, 250, 0, 135); 
    onCloseButtonClick = function()

      props.handle.Enabled = false;

    end
  }, {
    React.createElement(Checkbox, {
      text = "Anchored";
      isChecked = isAnchored;
      onClick = function()
        
        local possiblePart = parts[1];
        if possiblePart then
          
          local isAnchored = not possiblePart.Anchored;
          for _, part in ipairs(parts) do
            
            part.Anchored = isAnchored;
            
          end
          
        end
        
      end;
    });
  })

end

return PartAnchorModificationWindow;