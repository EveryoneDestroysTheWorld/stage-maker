--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Window);

type PartOrientationModificationWindowProps = {onClose: () -> (); parts: {BasePart}; updateParts: (newProperties: any) -> ();};

local function PartOrientationModificationWindow(props: PartOrientationModificationWindowProps)
  
  local textBoxes = {};
  local positionX: number?, setPositionX = React.useState(nil);
  local positionY: number?, setPositionY = React.useState(nil);
  local positionZ: number?, setPositionZ = React.useState(nil);
  for i = 1, 3 do

    local position = ({positionX, positionY, positionZ})[i];
    table.insert(textBoxes, React.createElement("TextBox", {
      LayoutOrder = i;
      Name = ({"PositionX", "PositionY", "PositionZ"})[i];
      BackgroundColor3 = Color3.new(1, 1, 1);
      BackgroundTransparency = 0.8;
      BorderSizePixel = 0;
      Size = UDim2.new(1 / 3, -2, 1, 0);
      TextColor3 = Color3.new(1, 1, 1);
      FontFace = Font.fromId(11702779517);
      TextSize = 14;
      Text = if position then string.format("%.2f", position) else "";
      [React.Event.FocusLost] = function(self)

        local requestedValue = tonumber(self.Text);
        if requestedValue then

          for _, part in ipairs(props.parts) do
            
            local positionX = if i == 1 then requestedValue else part.Position.X;
            local positionY = if i == 2 then requestedValue else part.Position.Y;
            local positionZ = if i == 3 then requestedValue else part.Position.Z;
            
            ReplicatedStorage.Shared.Functions.UpdateParts:InvokeServer({part.Name}, {Position = Vector3.new(positionX, positionY, positionZ)});

          end

        end

      end
    }));
    
  end;
  
  local handles: Handles?, setHandles = React.useState(React.createElement(React.Fragment));
  
  React.useEffect(function()

    local lastPart = props.parts[#props.parts];
    local originalCFrame = CFrame.identity;
    local handles = React.createElement("Handles", {
      Adornee = lastPart;
      Name = "Handles";
      [React.Event.MouseDrag] = function(self, face, distance)

        local axis = {
          [Enum.NormalId.Right] = lastPart.CFrame.RightVector,
          [Enum.NormalId.Left] = -lastPart.CFrame.RightVector,
          [Enum.NormalId.Top] = lastPart.CFrame.UpVector, 
          [Enum.NormalId.Bottom] = -lastPart.CFrame.UpVector,
          [Enum.NormalId.Front] = lastPart.CFrame.LookVector,
          [Enum.NormalId.Back] = -lastPart.CFrame.LookVector,
        };

        if lastPart then
          
          props.updateParts({CFrame = originalCFrame + axis[face] * distance});

        end

      end;
      [React.Event.MouseButton1Down] = function()

        if lastPart then
          
          originalCFrame = lastPart.CFrame;
          
        end

      end;
    })

    local events = {};
    local function updatePosition()

      local positionX: number?;
      local positionY: number?;
      local positionZ: number?;

      local firstPart = props.parts[1];
      if firstPart then

        positionX = firstPart.Position.X;
        positionY = firstPart.Position.Y;
        positionZ = firstPart.Position.Z;

        for _, part in ipairs(props.parts) do

          positionX = if part.Position.X ~= positionX then nil else positionX;
          positionY = if part.Position.Y ~= positionY then nil else positionY;
          positionZ = if part.Position.Z ~= positionZ then nil else positionZ;

        end;

      end;

      setPositionX(positionX :: any);
      setPositionY(positionY :: any);
      setPositionZ(positionZ :: any);

    end;
    for _, part in ipairs(props.parts) do

      table.insert(events, part:GetPropertyChangedSignal("Orientation"):Connect(function()
      
        updatePosition();

      end));

      updatePosition();

    end;

    setHandles(handles);

    return function()

      for _, event in ipairs(events) do

        event:Disconnect();

      end;

    end;
    
  end, {props.parts});
  
  return React.createElement(Window, {
    name = "Position"; 
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
    handles
  });

end

return PartOrientationModificationWindow;