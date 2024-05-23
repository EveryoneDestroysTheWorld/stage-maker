local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);

type ColorPaletteProps = {
  color3: Color3?;
  onSave: () -> ();
  onLoad: () -> ();
  LayoutOrder: number;
}

local function ColorPaletteButton(props: ColorPaletteProps)
  
  local color3 = props.color3;
  return React.createElement("TextButton", {
    Name = props.LayoutOrder;
    BackgroundColor3 = color3 or Color3.new(1, 1, 1);
    Size = UDim2.new(0, 30, 0, 30);
    LayoutOrder = props.LayoutOrder;
    TextSize = 30;
    BorderSizePixel = 0;
    Text = if color3 then "" else "+"; 
    FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
    TextColor3 = Color3.fromRGB(139, 139, 139);
    [React.Event.Activated] = function()
      
      props[if props.color3 then "onLoad" else "onSave"]();
      
    end;
    [React.Event.MouseButton2Click] = function()
      
      props.onSave();
      
    end;
  });
  
end

return ColorPaletteButton;
