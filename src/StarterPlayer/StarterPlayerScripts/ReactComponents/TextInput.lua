local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);

type TextInputProps = {
  labelText: string;
  placeholderText: string?;
  value: string;
  onChange: (newValue: string) -> ();
  LayoutOrder: number;
};

local function TextInput(props: TextInputProps)

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    Size = UDim2.new();
    BackgroundTransparency = 1;
    LayoutOrder = props.LayoutOrder;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      Padding = UDim.new(0, 10);
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    TextLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = props.labelText;
      BackgroundTransparency = 1;
      TextColor3 = Color3.new(1, 1, 1);
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
      Size = UDim2.new();
      TextSize = 14;
      LayoutOrder = 1;
    });
    TextBox = React.createElement("TextBox", {
      BackgroundTransparency = 0.9;
      PlaceholderText = props.placeholderText;
      Size = UDim2.new(1, 0, 0, 30);
      TextSize = 14;
      TextXAlignment = Enum.TextXAlignment.Left;
      TextColor3 = Color3.new(1, 1, 1);
      BackgroundColor3 = Color3.new(1, 1, 1);
      FontFace = Font.fromId(11702779517);
      LayoutOrder = 2;
      Text = props.value;
      ClearTextOnFocus = false;
      [React.Change.Text] = function(self)

        props.onChange(self.Text);

      end;
    }, {
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 15);
        PaddingRight = UDim.new(0, 15);
      });
      UIStroke = React.createElement("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        Color = Color3.new(1, 1, 1);
        Transparency = 0.2;
      });
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 5);
      });
    });
  });

end

return TextInput;