local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local WindowHeader = require(script.Parent.WindowHeader);

type WindowProps = {
  name: string;
  onCloseButtonClick: () -> ();
  children: any;
  size: UDim2;
}

local function Window(props: WindowProps)
  
  -- Set up the content.
  local UIListLayout = React.createElement("UIListLayout", {
    Name = "UIListLayout";
    SortOrder = Enum.SortOrder.LayoutOrder;
    Padding = UDim.new(0, 0);
  });
  
  local UIPadding = React.createElement("UIPadding", {
    Name = "UIPadding";
    PaddingBottom = UDim.new(0, 5);
    PaddingLeft = UDim.new(0, 5);
    PaddingRight = UDim.new(0, 5);
    PaddingTop = UDim.new(0, 5);
  });
  
  local UIListLayout2 = React.createElement("UIListLayout", {
    Name = "UIListLayout";
    SortOrder = Enum.SortOrder.LayoutOrder;
    Padding = UDim.new(0, 5);
  });
    
  local WindowContent = React.createElement("ScrollingFrame", {
    Name = "Content",
    Size = UDim2.new(1, 0, 1, -30);
    CanvasSize = UDim2.new(0, 0, 1, -30);
    BackgroundTransparency = 1;
    AutomaticCanvasSize = Enum.AutomaticSize.Y;
    VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    BorderSizePixel = 0;
    ScrollingDirection = Enum.ScrollingDirection.Y;
  }, {UIListLayout2, UIPadding, props.children});
  
  local UICorner = React.createElement("UICorner", {
    Name = "UICorner";
    CornerRadius = UDim.new(0, 5)
  }, {});
  
  local windowPosition, setWindowPosition = React.useState(UDim2.new(1, -290, 0, 135));
  
  local WindowHeader = React.createElement(WindowHeader, {
    windowName = props.name;
    windowPosition = windowPosition;
    setWindowPosition = setWindowPosition;
    onCloseButtonClick = props.onCloseButtonClick;
  });
  
  return React.createElement("CanvasGroup", {
    Name = "Window";
    BackgroundColor3 = Color3.fromRGB(5, 7, 18);
    Position = windowPosition;
    Size = props.size;
    BackgroundTransparency = 0.7;
  }, {WindowHeader, WindowContent, UICorner, UIListLayout});
  
end

return Window;