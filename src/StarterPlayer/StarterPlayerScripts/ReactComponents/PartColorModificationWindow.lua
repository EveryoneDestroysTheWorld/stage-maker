local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Window);
local HexColorInput = require(script.Parent.HexColorInput);
local ColorPalette = require(script.Parent.ColorPalette);

type PartColorModificationWindowProps = {onClose: () -> (); parts: {BasePart}; updateParts: (newProperties: any) -> ()};

local function PartColorModificationWindow(props: PartColorModificationWindowProps)

  local currentColor3: Color3?, setCurrentColor3 = React.useState(nil);
  local colors: {Color3}, setColors = React.useState({});

  React.useEffect(function()

    local events = {};
    local firstPart = props.parts[1];
    if firstPart then
        
      table.insert(events, firstPart:GetPropertyChangedSignal("Color"):Connect(function()

        setCurrentColor3(firstPart.Color);

      end));

      setCurrentColor3(firstPart.Color);
      
    end;
    
    return function()
      
      for _, event in ipairs(events) do
        
        event:Disconnect();
        
      end
      
    end
    
  end, {props.parts});

  local HexColorInputWithProps = React.createElement(HexColorInput, {
    color3 = currentColor3;
    onChange = function(newColor: Color3) props.updateParts({Color = newColor}) end;
  });

  local ColorPaletteWithProps = React.createElement(ColorPalette, {
    currentColor = currentColor3; 
    colors = colors;
    onChange = function(newColors) setColors(newColors) end;
    onSelect = function(selectedColor: Color3) props.updateParts({Color = selectedColor}) end;
  });

  return React.createElement(Window, {
    name = "Color";
    size = UDim2.new(0, 250, 0, 135);
    onCloseButtonClick = props.onClose;
  }, {HexColorInputWithProps, ColorPaletteWithProps});

end

return PartColorModificationWindow;