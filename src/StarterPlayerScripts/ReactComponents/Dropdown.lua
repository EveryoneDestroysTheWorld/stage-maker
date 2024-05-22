local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);

type DropdownProps = {
  selectedIndex: number?;
  maxHeight: number?;
  options: {{
    text: string;
    onClick: () -> ();
  }}
}

local function Dropdown(props: DropdownProps)
  
  local isDropdownOpen, setIsDropdownOpen = React.useState(false);
  
  local selectedOption = if props.selectedIndex then props.options[props.selectedIndex] else nil;
  local SelectButton = React.createElement("TextButton", {
    Name = "SelectButton";
    BackgroundColor3 = Color3.new(1, 1, 1);
    BackgroundTransparency = 0.8;
    BorderSizePixel = 0;
    Text = "";
    Size = UDim2.new(1, 0, 0, 30);
    [React.Event.Activated] = function()
      
      setIsDropdownOpen(not isDropdownOpen);
      
    end;
  }, {
    React.createElement("UICorner", {
      Name = "UICorner"; 
      CornerRadius = UDim.new(0, if isDropdownOpen then 0 else 8)
    }),
    React.createElement("ImageLabel", {
      Name = "DirectionIndictator";
      BackgroundTransparency = 1;
      Position = UDim2.new(1, -25, 0.5, -10);
      Size = UDim2.new(0, 20, 0, 20);
      Image = "rbxassetid://17536960578";
      Rotation = if isDropdownOpen then 180 else 0;
    }),
    React.createElement("TextLabel", {
      Name = "SelectedOption";
      BackgroundTransparency = 1;
      Size = UDim2.new(1, -30, 1, 0);
      Position = UDim2.new(0, 5, 0, 0);
      TextColor3 = Color3.new(1, 1, 1);
      TextXAlignment = Enum.TextXAlignment.Left;
      Text = if selectedOption then selectedOption.text else "Select an option...";
      FontFace = Font.fromId(11702779517);
      TextSize = 14;
      BorderSizePixel = 0;
    }),
  });
  
  local options = {};
  for optionIndex, optionData in ipairs(props.options) do
    
    table.insert(options, React.createElement("TextButton", {
      Name = optionIndex;
      [React.Event.Activated] = function()
        
        optionData.onClick();
        setIsDropdownOpen(false);

      end;
      Size = UDim2.new(1, 0, 0, 30);
      LayoutOrder = optionIndex;
      BackgroundTransparency = 0.8;
      BorderSizePixel = 0;
      BackgroundColor3 = Color3.fromRGB(163, 163, 163);
      Text = "";
    }, {
      React.createElement("TextLabel", {
        Text = optionData.text;
        BackgroundTransparency = 1;
        TextXAlignment = Enum.TextXAlignment.Left;
        Size = UDim2.new(1, -10, 1, 0);
        Position = UDim2.new(0, 5, 0, 0);
        FontFace = Font.fromId(11702779517);
        TextColor3 = Color3.new(1, 1, 1);
        TextSize = 14;
      })
    }));
    
  end
  local UIListLayout = React.createElement("UIListLayout", {Name = "UIListLayout"; SortOrder = Enum.SortOrder.LayoutOrder});
  local OptionsList = React.createElement("ScrollingFrame", {
    Name = "OptionsList";
    BackgroundTransparency = 1;
    LayoutOrder = 2;
    AutomaticCanvasSize = Enum.AutomaticSize.Y;
    VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    BorderSizePixel = 0;
    ScrollingDirection = Enum.ScrollingDirection.Y;
    Visible = isDropdownOpen;
    Size = UDim2.new(1, 0, 1, -30);
  }, {UIListLayout, options});
  
  return React.createElement("CanvasGroup", {
    Name = "Dropdown";
    BackgroundTransparency = 1;
    Size = UDim2.new(1, 0, 0, if isDropdownOpen then props.maxHeight or 90 else 30);
  }, {
    React.createElement("UICorner", {CornerRadius = UDim.new(0, if isDropdownOpen then 8 else 0)});
    UIListLayout, SelectButton, OptionsList
  });
  
end

return Dropdown;
