local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local WindowHeader = require(script.Parent.WindowHeader);

type HexColorInputProps = {
  color3: Color3?;
  onChange: (newColor3: Color3) -> ();
}

local function HexColorInput(props: HexColorInputProps)
  
  local UICorner = React.createElement("UICorner", {CornerRadius = UDim.new(0, 8)}, {});
  
  local color = props.color3;
  return React.createElement("TextBox", {
    Name = "HexColorInput";
    BackgroundColor3 = Color3.new(1, 1, 1);
    PlaceholderColor3 = Color3.fromRGB(222, 222, 222);
    Size = UDim2.new(1, 0, 0, 30);
    FontFace = Font.fromId(11702779517);
    BackgroundTransparency = 0.8;
    TextSize = 14;
    PlaceholderText = if color then `#{color:ToHex()}` else "";
    Text = "";
    TextColor3 = Color3.new(1, 1, 1);
    [React.Event.FocusLost] = function(self)
      
      props.onChange(Color3.fromHex(self.Text));
      self.Text = "";
      
    end,
  }, {UICorner});
  
end

return HexColorInput;
