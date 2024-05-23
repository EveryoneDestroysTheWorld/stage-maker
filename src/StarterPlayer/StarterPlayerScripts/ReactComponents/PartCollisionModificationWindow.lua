local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local Checkbox = require(script.Parent.Parent.ReactComponents.Checkbox);



local function PartCollisionModificationWindow(props: PartCollisionModificationWindowProps)

  local parts: {BasePart?}, setParts = React.useState({});

  local canCollide, setCanCollide = React.useState(false);

  React.useEffect(function()

    local events = {};
    for i, part in ipairs(parts) do

      if i == 1 then

        table.insert(events, part:GetPropertyChangedSignal("CanCollide"):Connect(function()

          setCanCollide(part.Anchored);

        end))

      end

    end;

    return function()

      for _, event in ipairs(events) do

        event:Disconnect();

      end

    end

  end, {parts});

  React.useEffect(function()

    game:GetService("ReplicatedStorage").Events.SelectedPartsChanged.Event:Connect(function(selectedParts)

      setParts(selectedParts);
      setCanCollide(if selectedParts[1] then selectedParts[1].CanCollide else false);

    end)

  end, {});


  return React.createElement(Window, {
    name = "Collisions"; 
    size = UDim2.new(0, 250, 0, 135); 
    onCloseButtonClick = function()

      props.handle.Enabled = false;

    end
  }, {
    React.createElement(Checkbox, {
      text = "Enable collisions";
      isChecked = canCollide;
      onClick = function()

        if parts[1] then

          local canCollide = not parts[1].CanCollide;
          for _, part in ipairs(parts) do

            part.CanCollide = canCollide;

          end

        end

      end;
    });
  })

end

return PartCollisionModificationWindow;