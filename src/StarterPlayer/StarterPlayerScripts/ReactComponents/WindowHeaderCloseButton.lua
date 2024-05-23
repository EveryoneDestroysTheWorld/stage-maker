local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);

type WindowHeaderCloseButtonProps = {
  onClick: () -> ();
}

local function WindowHeaderCloseButton(props: WindowHeaderCloseButtonProps)
  
  return React.createElement("TextButton", {
    Text = "";
    Name = "CloseButton";
    BackgroundColor3 = Color3.fromRGB(255, 89, 89);
    Size = UDim2.new(0, 10, 0, 10);
    LayoutOrder = 2;
    [React.Event.Activated] = function()

      props.onClick();

    end,
  }, {
    React.createElement("UICorner", {CornerRadius = UDim.new(1, 0)});
  });
  
end

return WindowHeaderCloseButton;
