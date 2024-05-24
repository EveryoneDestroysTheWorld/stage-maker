local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local NumberInput = require(script.Parent.Parent.ReactComponents.NumberInput);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);

type PartDurabilityModificationWindowProps = {onClose: () -> (); parts: {BasePart}; updateParts: (newProperties: any) -> ()};

local function PartDurabilityModificationWindow(props: PartDurabilityModificationWindowProps)

  local baseDurability: number?, setBaseDurability = React.useState(nil);
  React.useEffect(function()

    local firstPart = props.parts[1];
    if firstPart then

      local event = firstPart:GetAttributeChangedSignal("BaseDurability"):Connect(function()
      
        setBaseDurability(firstPart:GetAttribute("BaseDurability"));

      end)
      setBaseDurability(firstPart:GetAttribute("BaseDurability"));

      return function()

        event:Disconnect();

      end;
      
    else
      
      setBaseDurability(nil);
      return;
      
    end
    
  end, {props.parts});
  
  local isPartIndestructable = baseDurability == math.huge;
  return React.createElement(Window, {
    name = "Durability"; 
    size = UDim2.new(0, 250, 0, 135); 
    onCloseButtonClick = props.onClose;
  }, {
    React.createElement(NumberInput, {
      label = "Base durability";
      value = baseDurability;
      onChange = function(newValue)
        
        local possiblePart = props.parts[1];
        if possiblePart then
          
          -- Get the part names because we can't transfer instances with RemoteFunctions.
          local partIds = {};
          for _, part in ipairs(props.parts) do

            table.insert(partIds, part.Name);

          end;

          ReplicatedStorage.Shared.Functions.UpdateParts:InvokeServer(partIds, {BaseDurability = baseDurability});
          
        end
        
      end;
    });
    React.createElement(Checkbox, {
      text = "Indestructable";
      isChecked = isPartIndestructable;
      onClick = function()
        
        props.updateParts({BaseDurability = if isPartIndestructable then 100 else math.huge});
        
      end;
    });
  })

end

return PartDurabilityModificationWindow;