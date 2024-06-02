local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);

type BottomButtonProps = {
  description: string;
  onActivate: () -> ();
  keyName: string;
  LayoutOrder: number;
};

local function BottomButton(props: BottomButtonProps)

  local descriptionLabelRef: {current: TextLabel?} = React.useRef(nil);

  return React.createElement("TextButton", {
    BackgroundTransparency = 1;
    LayoutOrder = props.LayoutOrder;
    AutomaticSize = Enum.AutomaticSize.X;
    Size = UDim2.new(0, 0, 0, 30);
    [React.Event.Activated] = function() props.onActivate() end;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      Padding = UDim.new(0, 10);
      FillDirection = Enum.FillDirection.Horizontal;
      SortOrder = Enum.SortOrder.LayoutOrder;
      VerticalAlignment = Enum.VerticalAlignment.Center;
    });
    KeyLabel = React.createElement("TextLabel", {
      LayoutOrder = 1;
      BackgroundTransparency = 0.65;
      Text = props.keyName:upper();
      TextColor3 = Color3.new(1, 1, 1);
      AutomaticSize = Enum.AutomaticSize.X;
      TextSize = 10;
      Size = UDim2.new(0, 0, 0, 25);
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
      TextXAlignment = Enum.TextXAlignment.Center;
    }, {
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 10);
        PaddingRight = UDim.new(0, 10);
      });
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 5);
      });
    });
    DescriptionLabel = React.createElement("TextLabel", {
      LayoutOrder = 2;
      BackgroundTransparency = 1;
      Text = props.description:upper();
      TextColor3 = Color3.new(1, 1, 1);
      AutomaticSize = Enum.AutomaticSize.X;
      TextSize = 14;
      Size = UDim2.new(0, 0, 1, 0);
      FontFace = Font.fromId(11702779517);
      TextXAlignment = Enum.TextXAlignment.Left;
      ref = descriptionLabelRef;
    });
  })

end;

return BottomButton;