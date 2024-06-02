local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Colors = require(ReplicatedStorage.Client.Colors);

type ParagraphTextLabelProps = {
  text: string;
  LayoutOrder: number?;
  children: any;
};

local function ParagraphTextLabel(props: ParagraphTextLabelProps)

  return React.createElement("TextLabel", {
    LayoutOrder = props.LayoutOrder or 0;
    Text = props.text;
    BackgroundTransparency = 1;
    TextColor3 = Colors.ParagraphText;
    AutomaticSize = Enum.AutomaticSize.XY;
    TextSize = 14;
    Size = UDim2.new(0, 0, 0, 0);
    FontFace = Font.fromId(11702779517);
    LineHeight = 1.35;
    TextXAlignment = Enum.TextXAlignment.Left;
  }, {props.children});

end

return ParagraphTextLabel;