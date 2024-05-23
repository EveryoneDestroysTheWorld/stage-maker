local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);

type NumberInputProps = {
  label: string?;
  value: number?;
  onChange: (newValue: number?) -> ();
}

local function NumberInput(props: NumberInputProps)
  
  local TextLabel = if props.label then (
    React.createElement("TextLabel", {
      Name = "TextLabel";
      BackgroundTransparency = 1;
      Size = UDim2.new(1, 0, 0, 14);
      TextColor3 = Color3.new(1, 1, 1);
      TextXAlignment = Enum.TextXAlignment.Left;
      Text = props.label;
      FontFace = Font.fromId(11702779517);
      TextSize = 14;
      BorderSizePixel = 0;
    })
  ) else nil;
  
  local TextBox = React.createElement("TextBox", {
    Name = "TextBox";
    BackgroundTransparency = 0.8;
    Size = UDim2.new(1, 0, 0, 30);
    BackgroundColor3 = Color3.new(1, 1, 1);
    TextColor3 = Color3.new(1, 1, 1);
    TextXAlignment = Enum.TextXAlignment.Left;
    Text = tostring(props.value);
    FontFace = Font.fromId(11702779517);
    TextSize = 14;
    BorderSizePixel = 0;
    [React.Event.FocusLost] = function(self)
      
      local canChangeToNumber = pcall(function() props.onChange(tonumber(self.Text)); end);
      if not canChangeToNumber then
        
        self.Text = props.value;
        
      end
      
    end,
  }, {React.createElement("UICorner", {CornerRadius = UDim.new(0, 5)})});
  
  return React.createElement("CanvasGroup", {
    Name = "NumberInput";
    BackgroundTransparency = 1;
    Size = UDim2.new(1, 0, 0, if TextLabel then 44 else 30);
  }, {
    React.createElement("UIListLayout", {Name = "UIListLayout"; SortOrder = Enum.SortOrder.LayoutOrder;}), 
    TextLabel,
    TextBox
  });
  
end

return NumberInput;