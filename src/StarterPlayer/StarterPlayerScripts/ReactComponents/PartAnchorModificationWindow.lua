local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);

type PartAnchorModificationWindowProps = {onClose: () -> (); parts: {BasePart?};};

local function PartAnchorModificationWindow(props: PartAnchorModificationWindowProps)

  local isAnchored: boolean, setIsAnchored = React.useState(false);
  
  React.useEffect(function()
    
    local events = {};
    local firstPart = props.parts[1];
    if firstPart then
        
      table.insert(events, firstPart:GetPropertyChangedSignal("Anchored"):Connect(function()

        setIsAnchored(firstPart.Anchored);

      end));

      setIsAnchored(firstPart.Anchored);
      
    end;
    
    return function()
      
      for _, event in ipairs(events) do
        
        event:Disconnect();
        
      end
      
    end
    
  end, {props.parts});
  
  return React.createElement(Window, {
    name = "Anchor"; 
    size = UDim2.new(0, 250, 0, 135); 
    onCloseButtonClick = props.onClose;
  }, {
    React.createElement(Checkbox, {
      text = "Anchored";
      isChecked = isAnchored;
      onClick = function()
        
        local possiblePart = props.parts[1];
        if possiblePart then
          
          -- Get the part names because we can't transfer instances with RemoteFunctions.
          local partIds = {};
          for _, part in ipairs(props.parts) do

            table.insert(partIds, part.Name);

          end;

          ReplicatedStorage.Shared.Functions.UpdateParts:InvokeServer(partIds, {Anchored = not possiblePart.Anchored});
          
        end
        
      end;
    });
  })

end

return PartAnchorModificationWindow;