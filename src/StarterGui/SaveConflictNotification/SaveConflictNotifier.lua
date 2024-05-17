local ReplicatedStorage = game:GetService("ReplicatedStorage");
local shouldWarnPlayer = false;

local events = {};

ReplicatedStorage.Events.StageBuildDataSaveStarted.OnClientEvent:Connect(function()
  
  table.insert(events, workspace.Stage.ChildRemoved:Connect(function()
    
    shouldWarnPlayer = true;
    
  end));
  
  table.insert(events, workspace.Stage.ChildAdded:Connect(function()

    shouldWarnPlayer = true;

  end));
  
end);

ReplicatedStorage.Events.StageBuildDataSaveCompleted.OnClientEvent:Connect(function()
  
  for _, event in ipairs(events) do

    event:Disconnect();
    
  end
  
  events = {};
  
  if shouldWarnPlayer then
    
    script.Parent.Enabled = true;
    script.Parent.Warning:Play();
    game:GetService("TweenService"):Create(script.Parent.CanvasGroup, TweenInfo.new(0.5), {GroupTransparency = 0}):Play();
    
  end
  
end)

local function closeGUI()
  
  local tween = game:GetService("TweenService"):Create(script.Parent.CanvasGroup, TweenInfo.new(0.5), {GroupTransparency = 1});
  tween.Completed:Connect(function()
    
    script.Parent.Enabled = false;
    
  end);
  tween:Play();
  
end

script.Parent.CanvasGroup.CanvasGroup.Yes.MouseButton1Click:Connect(function()
  
  closeGUI();
  ReplicatedStorage.Functions.SaveStageBuildData:InvokeServer();
  
end)

script.Parent.CanvasGroup.CanvasGroup.No.MouseButton1Click:Connect(closeGUI);
