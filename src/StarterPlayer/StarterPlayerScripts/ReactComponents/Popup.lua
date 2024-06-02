local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local ScreenUIListLayout = require(script.Parent.ScreenUIListLayout);
local ScreenUIPadding = require(script.Parent.ScreenUIPadding);
local Button = require(script.Parent.Button);
local Colors = require(ReplicatedStorage.Client.Colors);

type PopupProps = {
  headerText: string?;
  taglineText: string?;
  options: {typeof(Button)}; 
  children: any;
};

local function Popup(props: PopupProps)

  return React.createElement("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5);
    AutomaticSize = Enum.AutomaticSize.XY;
    Position = UDim2.new(0.5, 0, 0.5, 0);
    Size = UDim2.new(0, 0, 0, 0);
    BorderSizePixel = 0;
    BackgroundColor3 = Colors.PopupBackground;
    BackgroundTransparency = 0.6;
  }, {
    UIListLayout = React.createElement(ScreenUIListLayout);
    UIPadding = React.createElement(ScreenUIPadding);
    UISizeConstraint = React.createElement("UISizeConstraint", {
      MaxSize = Vector2.new(600, 300);
      MinSize = Vector2.new(300, 0);
    });
    UIStroke = React.createElement("UIStroke", {
      Color = Colors.PopupBorder;
      Transparency = 0.6;
    });
    Heading = React.createElement("Frame", {
      BackgroundTransparency = 1;
      AutomaticSize = Enum.AutomaticSize.XY;
      Size = UDim2.new(0, 0, 0, 0);
      LayoutOrder = 1;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        Padding = UDim.new(0, 5);
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      Header = if props.headerText then React.createElement("TextLabel", {
        LayoutOrder = 1;
        Text = props.headerText;
        BackgroundTransparency = 1;
        TextColor3 = Colors.DemoDemonsRed;
        AutomaticSize = Enum.AutomaticSize.XY;
        TextSize = 20;
        Size = UDim2.new(0, 0, 0, 0);
        FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
        TextXAlignment = Enum.TextXAlignment.Left;
      }) else nil;
      Tagline = if props.taglineText then React.createElement("TextLabel", {
        LayoutOrder = 2;
        Text = props.taglineText;
        TextSize = 16;
        FontFace = Font.fromId(11702779517, Enum.FontWeight.SemiBold);
        BackgroundTransparency = 1;
        TextColor3 = Colors.TaglineText;
        Size = UDim2.new(0, 0, 0, 0);
        AutomaticSize = Enum.AutomaticSize.XY;
        TextXAlignment = Enum.TextXAlignment.Left;
      }) else nil;
    });
    Content = React.createElement("Frame", {
      BackgroundTransparency = 1;
      AutomaticSize = Enum.AutomaticSize.XY;
      Size = UDim2.new(0, 0, 0, 0);
      LayoutOrder = 2;
    }, {
      React.createElement(ScreenUIListLayout);
      props.children;
    });
    Options = React.createElement("Frame", {
      BackgroundTransparency = 1;
      AutomaticSize = Enum.AutomaticSize.XY;
      Size = UDim2.new(0, 0, 0, 0);
      LayoutOrder = 3;
    }, {
      React.createElement("UIListLayout", {
        Name = "UIListLayout";
        FillDirection = Enum.FillDirection.Horizontal;
        Padding = UDim.new(0, 15);
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      props.options;
    });
  });

end

return Popup;