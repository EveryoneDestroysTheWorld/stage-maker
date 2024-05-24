local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);

type PartCollisionModificationWindowProps = {onClose: () -> (); parts: {BasePart}; updateParts: (newProperties: any) -> ()};

local function PartCollisionModificationWindow(props: PartCollisionModificationWindowProps)

  local canCollide: boolean, setCanCollide = React.useState(false);
  
  React.useEffect(function()
    
    local events = {};
    local firstPart = props.parts[1];
    if firstPart then
        
      table.insert(events, firstPart:GetPropertyChangedSignal("CanCollide"):Connect(function()

        setCanCollide(firstPart.CanCollide);

      end));

      setCanCollide(firstPart.CanCollide);
      
    end;
    
    return function()
      
      for _, event in ipairs(events) do
        
        event:Disconnect();
        
      end
      
    end
    
  end, {props.parts});
  
  return React.createElement(Window, {
    name = "Collisions"; 
    size = UDim2.new(0, 250, 0, 135); 
    onCloseButtonClick = props.onClose;
  }, {
    React.createElement(Checkbox, {
      text = "Enable collisions";
      isChecked = canCollide;
      onClick = function()
        
        props.updateParts({CanCollide = not canCollide});
        
      end;
    });
  })

end

return PartCollisionModificationWindow;