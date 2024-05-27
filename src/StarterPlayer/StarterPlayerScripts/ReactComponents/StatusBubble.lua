local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);

type StatusBubbleProps = {
  status: "Complete" | "Warning" | "Default";
  iconImage: string;
  LayoutOrder: number;
}

local function StatusBubble(props: StatusBubbleProps)

  return React.createElement("Frame", {
    BackgroundTransparency = 1;
    Size = UDim2.new(0, 30, 0, 30);
    LayoutOrder = props.LayoutOrder;
  }, {
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(1, 0);
    });
    UIStroke = React.createElement("UIStroke", {
      Color = ({Complete = Color3.fromRGB(54, 221, 96); Warning = Color3.fromRGB(255, 126, 14); Default = Color3.new(1, 1, 1);})[props.status];
      LineJoinMode = Enum.LineJoinMode.Round;
      Transparency = if props.status == "Default" then 0.5 else 0;
      Thickness = 2;
    });
    ImageLabel = React.createElement("ImageLabel", {
      AnchorPoint = Vector2.new(0.5, 0.5);
      BackgroundTransparency = 1;
      Position = UDim2.new(0.5, 0, 0.5, 0);
      Size = UDim2.new(1, -10, 1, -10);
      Image = props.iconImage;
      ImageTransparency = if props.status == "Default" then 0.5 else 0;
    });
  });
  
end

return StatusBubble;