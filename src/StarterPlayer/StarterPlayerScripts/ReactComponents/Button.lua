local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Colors = require(ReplicatedStorage.Client.Colors);

type ButtonProps = {text: string; onClick: () -> (); isDisabled: boolean?; LayoutOrder: number;};

local function Button(props: ButtonProps)

  return React.createElement("TextButton", {
    Text = props.text;
    BackgroundColor3 = if props.isDisabled then Color3.fromRGB(57, 57, 57) else Colors.DemoDemonsOrange;
    TextColor3 = Color3.new(1, 1, 1);
    AutoButtonColor = not props.isDisabled;
    LayoutOrder = props.LayoutOrder;
    Active = not props.isDisabled;
    AutomaticSize = Enum.AutomaticSize.XY;
    FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
    BackgroundTransparency = 0.2;
    TextSize = 14;
    [React.Event.Activated] = if props.isDisabled then nil else function()

      props.onClick();

    end;
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 30);
      PaddingRight = UDim.new(0, 30);
      PaddingTop = UDim.new(0, 10);
      PaddingBottom = UDim.new(0, 10);
    });
    UICorner = React.createElement("UICorner", {CornerRadius = UDim.new(1, 0)}),
  });

end

return Button;