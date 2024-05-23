local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local HexColorInput = require(script.Parent.Parent.ReactComponents.HexColorInput);
local ColorPalette = require(script.Parent.Parent.ReactComponents.ColorPalette);

type PartColorModificationWindowProps = {onClose: () -> (); parts: {BasePart?}};

local function PartColorModificationWindow(props: PartColorModificationWindowProps)

  local currentColor3, setCurrentColor3 = React.useState(nil);
  local colors, setColors = React.useState({});

  React.useEffect(function()

    local firstPart = props.parts[1];
    if currentColor3 then

      for _, part in ipairs(props.parts) do

        part.Color = currentColor3;
  
      end

    elseif firstPart then

      setCurrentColor3(firstPart.Color);

    end;

  end, {currentColor3});

  local HexColorInputWithProps = React.createElement(HexColorInput, {
    color3 = currentColor3;
    onChange = function(newColor3)

      setCurrentColor3(newColor3);

    end;
  });

  local ColorPaletteWithProps = React.createElement(ColorPalette, {
    currentColor = currentColor3; 
    colors = colors;
    onChange = function(newColors) setColors(newColors) end;
    onSelect = function(selectedColor) setCurrentColor3(selectedColor) end;
  });

  return React.createElement(Window, {
    name = "Color";
    size = UDim2.new(0, 250, 0, 135);
    onCloseButtonClick = props.onClose;
  }, {HexColorInputWithProps, ColorPaletteWithProps});

end

return PartColorModificationWindow;