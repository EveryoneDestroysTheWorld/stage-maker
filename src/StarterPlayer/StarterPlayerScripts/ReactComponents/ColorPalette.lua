local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ColorPaletteButton = require(script.Parent.ColorPaletteButton);

type ColorPaletteProps = {
  colors: {Color3};
  currentColor: Color3?;
  onChange: (newColors: {Color3}) -> ();
  onSelect: (selectedColor: Color3) -> ();
}

local function ColorPalette(props: ColorPaletteProps)

  local UICorner = React.createElement("UICorner", {CornerRadius = UDim.new(0, 8)}, {});
  local UIListLayout = React.createElement("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal;
    SortOrder = Enum.SortOrder.LayoutOrder;
    Wraps = true;
  });

  local buttons = {};
  for i = 1, 16 do

    local color3 = props.colors[i];
    buttons[i] = React.createElement(ColorPaletteButton, {
      LayoutOrder = i;
      color3 = color3;
      onSave = function()
        
        local newColors = table.clone(props.colors);
        newColors[i] = props.currentColor;
        props.onChange(newColors);
        
      end;
      onLoad = function()
        
        props.onSelect(color3);

      end;
    });

  end

  return React.createElement("CanvasGroup", {
    Name = "ColorPalette";
    BackgroundTransparency = 1;
    Size = UDim2.new(1, 0, 0, 60);
  }, {UICorner, UIListLayout, buttons});

end

return ColorPalette;
