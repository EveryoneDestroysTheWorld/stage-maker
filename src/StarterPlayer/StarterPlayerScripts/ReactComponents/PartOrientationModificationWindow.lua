--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Parent.ReactComponents.Window);

type PartOrientationModificationWindowProps = {onClose: () -> (); parts: {BasePart}; updateParts: (newProperties: any) -> ();};

local function PartOrientationModificationWindow(props: PartOrientationModificationWindowProps)
  
  local textBoxes = {};
  for i = 1, 3 do
    
    local possiblePart = props.parts[#props.parts - 1];
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
      Text = if possiblePart then ({possiblePart.Orientation.X, possiblePart.Orientation.Y, possiblePart.Orientation.Z})[i] else "";
      [React.Event.InputEnded] = function(self)

        local requestedValue = tonumber(self.Text);
        if requestedValue then

          for _, part in ipairs(props.parts) do
            
            local orientationX = if i == 1 then requestedValue else part.Orientation.X;
            local orientationY = if i == 2 then requestedValue else part.Orientation.Y;
            local orientationZ = if i == 3 then requestedValue else part.Orientation.Z;
            
            part.Orientation = Vector3.new(orientationX, orientationY, orientationZ);

          end

        end

      end
    }));
    
  end
  
  local arcHandles: ArcHandles?, setArcHandles = React.useState(React.createElement(React.Fragment));
  
  React.useEffect(function()

    local lastPart = props.parts[#props.parts];
    print(props.parts);
    local originalCFrame = CFrame.identity;
    local arcHandles = React.createElement("ArcHandles", {
      Adornee = lastPart;
      Name = "ArcHandles";
      [React.Event.MouseDrag] = function(self, axis, relativeAngle)

        local part = props.parts[1];
        if part then
          
          props.updateParts({CFrame = originalCFrame * CFrame.fromAxisAngle(Vector3.FromAxis(axis), relativeAngle)});

        end

      end;
      [React.Event.MouseButton1Down] = function()

        local part = props.parts[1];
        if part then
          
          originalCFrame = part.CFrame;
          
        end

      end;
    })
    setArcHandles(arcHandles);
    
  end, {props.parts});
  
  return React.createElement(Window, {
    name = "Orientation"; 
    size = UDim2.new(0, 250, 0, 135); 
    onCloseButtonClick = props.onClose;
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
      textBoxes,
    }),
    arcHandles
  });

end

return PartOrientationModificationWindow;