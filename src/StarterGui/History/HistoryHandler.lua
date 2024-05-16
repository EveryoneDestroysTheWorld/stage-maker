--!strict
-- HistoryHandler.lua
-- Written by Christian "Sudobeast" Toney

local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");

local eventListFrame = script.Parent.CanvasGroup.CanvasGroup.EventList;
local eventTemplate = eventListFrame.EventTemplate:Clone();
eventListFrame.EventTemplate:Destroy();

local historyStore = require(script.HistoryStore);
local function updateHistory(): ()
  
  for _, button in ipairs(eventListFrame:GetChildren()) do
    
    if button:IsA("CanvasGroup") then
      
      button:Destroy();
      
    end
    
  end
  
  script.Parent.CanvasGroup.EmptyHistoryMessage.Visible = #historyStore.events == 0;
  
  for index, event in ipairs(historyStore.events) do
    
    local buttonCanvasGroup = eventTemplate:Clone();
    local eventIndex = #historyStore.events - index;
    buttonCanvasGroup.Name = eventIndex;
    buttonCanvasGroup.LayoutOrder = eventIndex;
    
    local button = buttonCanvasGroup.Button;
    button.Icon.Image = event.imageId or "rbxassetid://17505040253";
    button.Label.Text = event.label;
    button.MouseButton1Click:Connect(function()
      
      historyStore:setPointerOffset(#historyStore.events - index);
      
    end);
    
    if historyStore.pointerOffset > eventIndex then
      
      --button.BackgroundColor3 = Color3.fromRGB(189, 189, 189);
      buttonCanvasGroup.TransparencyPulse.Enabled = true;
      
    end
    
    buttonCanvasGroup.Parent = eventListFrame;
    
  end
  
end

historyStore.onEventAdd.Event:Connect(updateHistory);
historyStore.onEventCapacityChange.Event:Connect(updateHistory);
historyStore.onPointerOffsetChange.Event:Connect(updateHistory);

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

script.AddToHistoryStore.OnInvoke = function(event: historyStore.HistoryEvent)
  
  historyStore:add(event)
  
end
