--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");

ReplicatedStorage.Shared.Events.StageBuildDataSaveStarted.OnClientEvent:Connect(function()
  
  TweenService:Create(script.Parent, TweenInfo.new(), {GroupTransparency = 0}):Play();
  
end)

ReplicatedStorage.Shared.Events.StageBuildDataSaveCompleted.OnClientEvent:Connect(function()
  
  if script.Parent.Parent.SaveStarted.Playing then
    
    script.Parent.Parent.SaveStarted.Ended:Wait();
    
  end;
  
  TweenService:Create(script.Parent, TweenInfo.new(), {GroupTransparency = 1}):Play();

end)