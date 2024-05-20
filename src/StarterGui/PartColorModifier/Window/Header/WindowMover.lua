--!strict
local mouse = game:GetService("Players").LocalPlayer:GetMouse();
local mouseEvent;

script.Parent.InputBegan:Connect(function(inputObject)

  if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then

    local window = script.Parent.Parent;
    local originalCGXOffset = window.Position.X.Offset;
    local originalCGYOffset = window.Position.Y.Offset;
    local originalMouseXOffset = mouse.X;
    local originalMouseYOffset = mouse.Y;
    mouseEvent = mouse.Move:Connect(function()

      window.Position = UDim2.new(window.Position.X.Scale, originalCGXOffset + (mouse.X - originalMouseXOffset), window.Position.Y.Scale, originalCGYOffset + (mouse.Y - originalMouseYOffset));

    end);

  end

end)

script.Parent.InputEnded:Connect(function(inputObject)

  if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and mouseEvent then

    mouseEvent:Disconnect();
    mouseEvent = nil;

  end

end)
