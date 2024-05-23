local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local WindowHeaderCloseButton = require(script.Parent.WindowHeaderCloseButton);

type WindowHeaderProps = {
  windowName: string;
  windowPosition: UDim2;
  setWindowPosition: (newWindowPosition: UDim2) -> ();
  onCloseButtonClick: () -> ();
}

local function WindowHeader(props: WindowHeaderProps)

  local WindowName = React.createElement("TextLabel", {
    Name = "WindowName";
    BackgroundTransparency = 1;
    Size = UDim2.new(1, -30, 0, 24);
    TextSize = 14;
    TextXAlignment = Enum.TextXAlignment.Left;
    TextColor3 = Color3.new(1, 1, 1);
    Text = props.windowName:upper();
    FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
    LayoutOrder = 1;
  });

  local UIListLayout = React.createElement("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal;
    HorizontalAlignment = Enum.HorizontalAlignment.Center;
    VerticalAlignment = Enum.VerticalAlignment.Center; 
    SortOrder = Enum.SortOrder.LayoutOrder;
  });

  local mouseEvent, setMouseEvent = React.useState(nil);
  
  local WindowHeaderCloseButton = React.createElement(WindowHeaderCloseButton, {
    onClick = props.onCloseButtonClick;
  })
  
  return React.createElement("CanvasGroup", {
    Name = "Header";
    Size = UDim2.new(1, 0, 0, 30);
    BackgroundColor3 = Color3.fromRGB(5, 7, 18);
    BackgroundTransparency = 0.7;
    [React.Event.InputBegan] = function(_, inputObject)

      if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then

        local mouse = game:GetService("Players").LocalPlayer:GetMouse();
        local originalCGXOffset = props.windowPosition.X.Offset;
        local originalCGYOffset = props.windowPosition.Y.Offset;
        local originalMouseXOffset = mouse.X;
        local originalMouseYOffset = mouse.Y;
        setMouseEvent(mouse.Move:Connect(function()

          props.setWindowPosition(UDim2.new(props.windowPosition.X.Scale, originalCGXOffset + (mouse.X - originalMouseXOffset), props.windowPosition.Y.Scale, originalCGYOffset + (mouse.Y - originalMouseYOffset)));

        end));

      end

    end,
    [React.Event.InputEnded] = function(_, inputObject)
      
      if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and mouseEvent then

        mouseEvent:Disconnect();
        setMouseEvent(mouseEvent);

      end

    end,
  }, {UIListLayout, WindowName, WindowHeaderCloseButton});

end

return WindowHeader;
