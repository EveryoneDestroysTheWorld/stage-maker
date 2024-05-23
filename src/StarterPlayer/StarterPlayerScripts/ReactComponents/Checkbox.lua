local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);

type CheckboxProps = {
  isChecked: boolean;
  text: string;
  onClick: () -> ();
}

local function Checkbox(props: CheckboxProps)
  
  return React.createElement("CanvasGroup", {
    BackgroundTransparency = 1;
    Size = UDim2.new(1, 0, 0, 30);
  }, {
    React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      VerticalAlignment = Enum.VerticalAlignment.Center;
      FillDirection = Enum.FillDirection.Horizontal;
      Padding = UDim.new(0, 5);
    }),
    React.createElement("TextButton", {
      BackgroundTransparency = 0.8;
      BackgroundColor3 = Color3.new(1, 1, 1);
      BorderSizePixel = 0;
      Size = UDim2.new(0, 30, 0, 30);
      LayoutOrder = 1;
      Text = "";
      [React.Event.Activated] = props.onClick,
    }, {
      React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 5);
      });
      React.createElement("ImageLabel", {
        Image = "rbxassetid://17571806169";
        Name = "CheckImage";
        BackgroundTransparency = 1;
        Visible = props.isChecked;
        ImageColor3 = Color3.new(1, 1, 1);
        Size = UDim2.new(1, -10, 1, -10);
        Position = UDim2.new(0.5, -10, 0.5, -10);
      })
    }),
    React.createElement("TextLabel", {
      BackgroundTransparency = 1;
      FontFace = Font.fromId(11702779517);
      TextXAlignment = Enum.TextXAlignment.Left;
      TextColor3 = Color3.new(1, 1, 1);
      LayoutOrder = 2;
      Size = UDim2.new(1, -30, 0, 30);
      TextSize = 14;
      Text = props.text;
    })  
  });
  
end

return Checkbox;
