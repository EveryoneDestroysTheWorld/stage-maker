--!strict
local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");
local TextChatService = game:GetService("TextChatService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local Window = require(script.Parent.Parent.ReactComponents.Window);
local ActionHistoryEventList = require(script.Parent.Parent.ReactComponents.ActionHistoryEventList);

local handle = Instance.new("ScreenGui");
handle.Name = "History";
handle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
handle.Parent = game.Players.LocalPlayer.PlayerGui;
handle.Enabled = false;

local root = ReactRoblox.createRoot(handle);
local historyStore = require(script.HistoryStore);

local function ActionHistoryWindow()
  
  local events, setEvents = React.useState({});
  
  React.useEffect(function()
    
    local function updateHistory(): ()

      local newEvents = {};

      for index, event in ipairs(historyStore.events) do

        newEvents[index] = {
          iconImage = event.iconImage or "rbxassetid://17505040253";
          description = event.description;
        }

      end

      setEvents(newEvents);

    end
    
    historyStore.onEventAdd.Event:Connect(updateHistory);
    historyStore.onEventCapacityChange.Event:Connect(updateHistory);
    historyStore.onPointerOffsetChange.Event:Connect(updateHistory);
    
  end, {});
  
  local ActionHistoryEventList = React.createElement(ActionHistoryEventList, {
    events = events;
    historyStore = historyStore;
  });
  local EmptyHistoryMessage = React.createElement("TextLabel", {
    BackgroundTransparency = 1;
    FontFace = Font.fromId(11702779517);
    Position = UDim2.new(0.5, -100, 0.5, -30);
    Size = UDim2.new(0, 200, 0, 30);
    Text = "Nice and squeaky clean. Let's have fun!";
    Visible = #events == 0;
  });
  
  return React.createElement(Window, {
    name = "Action history"; 
    size = UDim2.new(0, 230, 0, 254); 
    onCloseButtonClick = function()

      handle.Enabled = false;

    end
  }, {ActionHistoryEventList});
  
end

root:render(React.createElement(ActionHistoryWindow));

---


-- Undo and redo when the player presses CTRL+Z and CTRL+Y respectively.
local function handleHistoryKeybind(actionName, inputState)

  if inputState ~= Enum.UserInputState.Begin then return; end;

  local isControlPressed = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl);
  if isControlPressed then

    historyStore:setPointerOffset(historyStore.pointerOffset + (if actionName == "Undo" then 1 else -1));

  end

end

ContextActionService:BindAction("Undo", handleHistoryKeybind, false, Enum.KeyCode.Z);
ContextActionService:BindAction("Redo", handleHistoryKeybind, false, Enum.KeyCode.Y);

ReplicatedStorage.Client.Functions.AddToHistoryStore.OnInvoke = function(event: historyStore.HistoryEvent)

  historyStore:add(event)

end

local historyCommand = TextChatService.Commands.HistoryCommand;
historyCommand.Triggered:Connect(function(_, text)

  handle.Enabled = not handle.Enabled;

end)
