local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Dropdown = require(script.Parent.Parent.ReactComponents.Dropdown);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);

type PartOrientationModificationWindowProps = {handle: ScreenGui};

local function PartOrientationModificationWindow(props: PartOrientationModificationWindowProps)
  
  local parts: {BasePart?}, setParts = React.useState({});
  local selectedOptionIndex, setSelectedOptionIndex = React.useState(nil);
  local textBoxes = {};
  for i = 1, 3 do
    
    table.insert(textBoxes, React.createElement("TextBox", {
      LayoutOrder = i;
      Name = ({"OrientationX", "OrientationY", "OrientationZ"})[i];
      BackgroundColor3 = Color3.new(1, 1, 1);
      BackgroundTransparency = 0.8;
      BorderSizePixel = 0;
      Size = UDim2.new(1 / 3, -2, 1, 0);
      TextColor3 = Color3.new(1, 1, 1);
      FontFace = Font.fromId(11702779517);
      TextSize = 14;
      Text = "";
      [React.Event.InputEnded] = function(self)

        local requestedValue = tonumber(self.Text);
        if requestedValue then

          for _, part in ipairs(parts) do
            
            local orientationX = if i == 1 then requestedValue else part.Orientation.X;
            local orientationY = if i == 2 then requestedValue else part.Orientation.Y;
            local orientationZ = if i == 3 then requestedValue else part.Orientation.Z;
            
            part.Orientation = Vector3.new(orientationX, orientationY, orientationZ);

          end

        end

      end
    }));
    
  end
  
  React.useEffect(function()
    
    script.Parent = props.handle;
    
    game:GetService("ReplicatedStorage").Events.SelectedPartsChanged.Event:Connect(function(selectedParts)

      if selectedParts[1] then

        script.ArcHandles.Adornee = selectedParts[1];
        setParts(selectedParts);

      end

    end)
    
  end, {});
  
  return React.createElement(Window, {
    name = "Orientation"; 
    size = UDim2.new(0, 250, 0, 135); 
    onCloseButtonClick = function()
      
      script.ArcHandles.Visible = false;
      props.handle.Enabled = false;

    end
  }, {
    React.createElement("CanvasGroup", {
      BackgroundTransparency = 1;
      Name = "AxesContainer";
      Size = UDim2.new(1, 0, 0, 30);
    }, {
      React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        Padding = UDim.new(0, 2);
      }),
      React.createElement("UICorner", {CornerRadius = UDim.new(0, 8)}, {});
      textBoxes
    })
  });

end

return PartOrientationModificationWindow;