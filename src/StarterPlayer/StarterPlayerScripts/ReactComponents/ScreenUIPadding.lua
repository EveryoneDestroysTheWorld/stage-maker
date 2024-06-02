local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);

local function ScreenUIPadding()

  return React.createElement("UIPadding", {
    PaddingLeft = UDim.new(0, 30);
    PaddingRight = UDim.new(0, 30);
    PaddingTop = UDim.new(0, 30);
    PaddingBottom = UDim.new(0, 30);
  });

end

return ScreenUIPadding;