local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);

type BuildingToolsSelectorProps = {
  sections: {{
    disabled: boolean?;
    name: string;
    buttons: {{
      name: string;
      iconImage: string;
      onClick: () -> ();
    }}
  }};
}

local function BuildingToolsSelector(props: BuildingToolsSelectorProps)
  
  local sections = {};
  local width = 0;
  for sectionIndex, sectionItems in ipairs(props.sections) do
    
    local section = {};
    for itemIndex, sectionItem in ipairs(sectionItems.buttons) do
      
      table.insert(section, React.createElement("ImageButton", {
        Name = sectionItem.name;
        BackgroundTransparency = 1;
        Size = UDim2.new(0, 30, 0, 30);
        Image = sectionItem.iconImage;
        LayoutOrder = itemIndex;
        [React.Event.Activated] = if sectionItems.disabled then nil else sectionItem.onClick;
      }));
      
    end

    local UIListLayout = React.createElement("UIListLayout", {
      Name = "UIListLayout";
      Padding = UDim.new(0, 5);
      FillDirection = Enum.FillDirection.Horizontal;
      SortOrder = Enum.SortOrder.LayoutOrder;
      VerticalAlignment = Enum.VerticalAlignment.Center;
    });
    local UIPadding = React.createElement("UIPadding", {
      Name = "UIPadding";
      PaddingBottom = UDim.new(0, 5);
      PaddingLeft = UDim.new(0, 5);
      PaddingRight = UDim.new(0, 5);
      PaddingTop = UDim.new(0, 5);
    });

    local groupWidth = 30 * #section + (5 * #section - 5) + 10;
    width += groupWidth;
    table.insert(sections, React.createElement("CanvasGroup", {
      Name = sectionItems.name;
      BackgroundColor3 = Color3.fromRGB(5, 7, 18);
      GroupColor3 = if sectionItems.disabled then Color3.fromRGB(167, 167, 167) else Color3.new(1, 1, 1);
      BackgroundTransparency = 0.49;
      BorderSizePixel = 0;
      LayoutOrder = sectionIndex;
      Size = UDim2.new(0, groupWidth, 1, 0);
    }, {UIListLayout, UIPadding, section}));
    
  end;

  local UICorner = React.createElement("UICorner", {
    Name = "UICorner";
    CornerRadius = UDim.new(0, 5);
  });
  local UIListLayout = React.createElement("UIListLayout", {
    Name = "UIListLayout";
    Padding = UDim.new(0, 2);
    FillDirection = Enum.FillDirection.Horizontal;
    SortOrder = Enum.SortOrder.LayoutOrder;
    VerticalAlignment = Enum.VerticalAlignment.Center;
  });
  
  return React.createElement("CanvasGroup", {
    Name = "BuildingToolsSelector";
    Position = UDim2.new(0.5, 0, 1, -70);
    Size = UDim2.new(0, width + (#sections * 2 - 2), 0, 40);
    BackgroundTransparency = 1;
    AnchorPoint = Vector2.new(0.5, 0);
  }, {UICorner, UIListLayout, sections});
  
end

return BuildingToolsSelector;