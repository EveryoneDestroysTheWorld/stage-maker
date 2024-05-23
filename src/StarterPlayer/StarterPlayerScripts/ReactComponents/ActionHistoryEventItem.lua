--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local TweenService = game:GetService("TweenService");

type ActionHistoryEventItemProps = {
  onClick: () -> ();
  iconImage: string;
  description: string;
  LayoutOrder: number;
  currentPointerOffset: number;
}

local function ActionHistoryEventItem(props: ActionHistoryEventItemProps)
  
  local button = React.createElement("TextButton", {
    Text = "";
    BackgroundTransparency = 1;
    Size = UDim2.new(1, 0, 1, 0);
    [React.Event.Activated] = props.onClick;
  }, {
    React.createElement("UIListLayout", {
      FillDirection = Enum.FillDirection.Horizontal;
      Padding = UDim.new(0, 5);
      VerticalAlignment = Enum.VerticalAlignment.Center;
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 5);
      PaddingRight = UDim.new(0, 5);
    });
    React.createElement("ImageLabel", {
      Name = "Icon";
      Size = UDim2.new(0, 25, 0, 25);
      Image = props.iconImage;
      BackgroundTransparency = 1;
      LayoutOrder = 1;
    }, {
      React.createElement("UICorner", {
        CornerRadius = UDim.new(1, 0);
      });
    });
    React.createElement("TextLabel", {
      Name = "Description";
      BackgroundTransparency = 1;
      Size = UDim2.new(1, -35, 1, 0);
      Text = props.description;
      FontFace = Font.fromId(11702779517);
      TextColor3 = Color3.new(1, 1, 1);
      TextXAlignment = Enum.TextXAlignment.Left;
      TextSize = 14;
      RichText = true;
      LayoutOrder = 2;
    });
  });
  
  local canvasGroupRef = React.createRef();
  
  React.useEffect(function(): ()
    
    if props.currentPointerOffset > props.LayoutOrder then
      
      local tween1 = TweenService:Create(canvasGroupRef.current, TweenInfo.new(.75, Enum.EasingStyle.Sine), {GroupTransparency = 0.6});
      local tween2 = TweenService:Create(canvasGroupRef.current, TweenInfo.new(1, Enum.EasingStyle.Sine), {GroupTransparency = 0.3});

      local tween1Event = tween1.Completed:Connect(function()

        tween2:Play();

      end)

      local tween2Event = tween2.Completed:Connect(function()

        tween1:Play();

      end)

      tween2:Play();
      
      return function()
        
        tween1:Cancel();
        tween2:Cancel();
        tween1Event:Disconnect();
        tween2Event:Disconnect();
        
      end
      
    else
      
      canvasGroupRef.current.GroupTransparency = 0;
      
    end;
    
  end, {props.currentPointerOffset});
  
  return React.createElement("CanvasGroup", {
    Name = props.LayoutOrder;
    BackgroundTransparency = 0.8;
    GroupTransparency = 0;
    BackgroundColor3 = if props.currentPointerOffset > props.LayoutOrder then Color3.fromRGB(81, 81, 81) else Color3.fromRGB(221, 221, 221);
    Size = UDim2.new(1, 0, 0, 32);
    ref = canvasGroupRef;
    BorderSizePixel = 0;
    LayoutOrder = props.LayoutOrder;
  }, {
    React.createElement("UIListLayout", {
      Padding = UDim.new(0, 5);
      HorizontalAlignment = Enum.HorizontalAlignment.Center;
    }),
    React.createElement("UIPadding", {
      PaddingBottom = UDim.new(0, 5);
      PaddingLeft = UDim.new(0, 5);
      PaddingRight = UDim.new(0, 5);
      PaddingTop = UDim.new(0, 5);
    }),
    React.createElement("UICorner", {CornerRadius = UDim.new(0, 5)}),
    button
  });
  
end

return ActionHistoryEventItem;
