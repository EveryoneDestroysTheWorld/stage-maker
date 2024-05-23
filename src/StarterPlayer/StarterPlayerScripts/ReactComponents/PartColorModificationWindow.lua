local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);
local HexColorInput = require(script.Parent.Parent.ReactComponents.HexColorInput);
local ColorPalette = require(script.Parent.Parent.ReactComponents.ColorPalette);

local function PartColorModificationWindow(props: PartCollisionModificationWindowProps)

  local parts, setParts = React.useState({});
  local currentColor3, setCurrentColor3 = React.useState(Color3.new());
  local colors, setColors = React.useState({});

  React.useEffect(function()

    for _, part in ipairs(parts) do

      part.Color = currentColor3;

    end

  end, {currentColor3});

  React.useEffect(function()

    game:GetService("ReplicatedStorage").Events.SelectedPartsChanged.Event:Connect(function(selectedParts)

      setParts(selectedParts);
      if selectedParts[1] then

        setCurrentColor3(selectedParts[1].Color);

      end

    end)

  end, {});

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
    onCloseButtonClick = function()

      handle.Enabled = false;

    end
  }, {HexColorInputWithProps, ColorPaletteWithProps});

end

return PartColorModificationWindow;