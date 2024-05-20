--!strict
-- HistoryHandler.lua
-- Written by Christian "Sudobeast" Toney

local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");
local TextChatService = game:GetService("TextChatService");

local window = script.Parent.Window;
local eventListFrame = window.Content.EventList;
local eventTemplate = eventListFrame.EventTemplate:Clone();
eventListFrame.EventTemplate:Destroy();

local historyStore = require(script.HistoryStore);
local function updateHistory(): ()
  
  for _, button in ipairs(eventListFrame:GetChildren()) do
    
    if button:IsA("CanvasGroup") then
      
      button:Destroy();
      
    end
    
  end
  
  window.Content.EmptyHistoryMessage.Visible = #historyStore.events == 0;
  
  for index, event in ipairs(historyStore.events) do
    
    local buttonCanvasGroup = eventTemplate:Clone();
    local eventIndex = #historyStore.events - index;
    buttonCanvasGroup.Name = eventIndex;
    buttonCanvasGroup.LayoutOrder = eventIndex;
    
    local button = buttonCanvasGroup.Button;
    button.Icon.Image = event.imageId or "rbxassetid://17505040253";
    button.Label.Text = event.label;
    button.MouseButton1Click:Connect(function()
      
      script.Parent.Processing:Play();
      historyStore:setPointerOffset(#historyStore.events - index);
      script.Parent.Processing:Stop();
      script.Parent.Done:Play();
      
    end);
    
    if historyStore.pointerOffset > eventIndex then
      
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

local historyCommand = TextChatService.Commands.HistoryCommand;
historyCommand.Triggered:Connect(function(_, text)

  script.Parent.Enabled = not script.Parent.Enabled;

end)
