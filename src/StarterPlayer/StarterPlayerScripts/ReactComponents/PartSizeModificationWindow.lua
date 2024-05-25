--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Window = require(script.Parent.Window);

type PartSizeModificationWindowProps = {onClose: () -> (); parts: {BasePart}; updateParts: (newProperties: any) -> ();};

local function PartSizeModificationWindow(props: PartSizeModificationWindowProps)
  
  local textBoxes = {};
  local sizeX: number?, setSizeX = React.useState(nil);
  local sizeY: number?, setSizeY = React.useState(nil);
  local sizeZ: number?, setSizeZ = React.useState(nil);
  for i = 1, 3 do

    local position = ({sizeX, sizeY, sizeZ})[i];
    table.insert(textBoxes, React.createElement("TextBox", {
      LayoutOrder = i;
      Name = ({"SizeX", "SizeY", "SizeZ"})[i];
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
            
            local sizeX = if i == 1 then requestedValue else part.Size.X;
            local sizeY = if i == 2 then requestedValue else part.Size.Y;
            local sizeZ = if i == 3 then requestedValue else part.Size.Z;
            
            ReplicatedStorage.Shared.Functions.UpdateParts:InvokeServer({part.Name}, {Size = Vector3.new(sizeX, sizeY, sizeZ)});

          end

        end

      end
    }));
    
  end;
  
  local handles: Handles?, setHandles = React.useState(React.createElement(React.Fragment));
  
  React.useEffect(function()

    local lastPart = props.parts[#props.parts];
    local originalSize = Vector3.new();
    local originalCFrame = CFrame.identity;
    local handles = React.createElement("Handles", {
      Adornee = lastPart;
      Name = "Handles";
      Style = Enum.HandlesStyle.Resize;
      [React.Event.MouseDrag] = function(self, face, distance)

        if lastPart then
          
          local direction = Vector3.fromNormalId(face);
          local size = Vector3.new(math.abs(direction.X), math.abs(direction.Y), math.abs(direction.Z))
          props.updateParts({
            Size = originalSize + size * distance;
            CFrame = originalCFrame * CFrame.new(direction / 2 * distance);
          });

        end

      end;
      [React.Event.MouseButton1Down] = function()

        if lastPart then
          
          originalSize = lastPart.Size;
          originalCFrame = lastPart.CFrame;
          
        end

      end;
    })

    local events = {};
    local function updateSize()

      local sizeX: number?;
      local sizeY: number?;
      local sizeZ: number?;

      local firstPart = props.parts[1];
      if firstPart then

        sizeX = firstPart.Size.X;
        sizeY = firstPart.Size.Y;
        sizeZ = firstPart.Size.Z;

        for _, part in ipairs(props.parts) do

          sizeX = if part.Size.X ~= sizeX then nil else sizeX;
          sizeX = if part.Size.Y ~= sizeY then nil else sizeY;
          sizeX = if part.Size.Z ~= sizeZ then nil else sizeZ;

        end;

      end;

      setSizeX(sizeX :: any);
      setSizeY(sizeY :: any);
      setSizeZ(sizeZ :: any);

    end;
    for _, part in ipairs(props.parts) do

      table.insert(events, part:GetPropertyChangedSignal("Size"):Connect(function()
      
        updateSize();

      end));

      updateSize();

    end;

    setHandles(handles);

    return function()

      for _, event in ipairs(events) do

        event:Disconnect();

      end;

    end;
    
  end, {props.parts});
  
  return React.createElement(Window, {
    name = "Size"; 
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

return PartSizeModificationWindow;