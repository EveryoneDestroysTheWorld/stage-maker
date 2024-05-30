local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local BottomButton = require(script.Parent.BottomButton);

type StageScreenProps = {options: {typeof(BottomButton)}; children: any};

local function Screen(props: StageScreenProps)

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 1, 0);
    BackgroundColor3 = Color3.fromRGB(18, 18, 18);
    BackgroundTransparency = 0.2;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    Header = React.createElement("Frame", {
      BackgroundTransparency = 1;
      LayoutOrder = 1;
      Size = UDim2.new(1, 0, 0, 58);
    }, {
      UIPadding = React.createElement("UIPadding", {
        PaddingTop = UDim.new(0, 10);
      });
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
      });
    });
    Content = React.createElement("Frame", {
      BackgroundTransparency = 1;
      LayoutOrder = 2;
      Size = UDim2.new(1, 0, 1, -118);
    }, {props.children});
    Options = React.createElement("Frame", {
      BackgroundTransparency = 1;
      LayoutOrder = 3;
      Size = UDim2.new(1, 0, 0, 60);
    }, {
      React.createElement("UIListLayout", {
        Name = "UIListLayout";
        HorizontalAlignment = Enum.HorizontalAlignment.Left;
        Padding = UDim.new(0, 15);
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        VerticalAlignment = Enum.VerticalAlignment.Center;
      });
      React.createElement("UIPadding", {
        Name = "UIPadding";
        PaddingLeft = UDim.new(0, 30);
        PaddingRight = UDim.new(0, 30);
      });
      props.options;
    });
  });

end

return Screen;