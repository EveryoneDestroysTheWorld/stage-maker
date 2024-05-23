--!strict
-- ProgressVisualizationScript.lua
-- Written by Christian "Sudobeast" Toney
-- This script resizes the progress bars as the server saves the current stage.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");

local savingTextLabel = script.Parent.SavingText;
local saveCompletedTextLabel = script.Parent.SaveCompletedText;
local nothingSavedTextLabel = script.Parent.NothingSavedText;

script.Parent.GroupTransparency = 1;

local saveStartTime;

local lastTotal = 0;
ReplicatedStorage.Events.StageBuildDataSaveStarted.OnClientEvent:Connect(function()
  
  saveStartTime = os.time();
  lastTotal = 0;
  
  script.Parent.GroupColor3 = Color3.new(255, 255, 255);
  savingTextLabel.Visible = true;
  saveCompletedTextLabel.Visible = false;
  nothingSavedTextLabel.Visible = false;
  for _, progressBar in ipairs({script.Parent.LoadingBar.Packaging.Progress, script.Parent.LoadingBar.Saving.Progress}) do
    
    progressBar.Size = UDim2.new(0, progressBar.Size.X.Offset, progressBar.Size.Y.Scale, progressBar.Size.Y.Offset);
    
  end;
  
  TweenService:Create(script.Parent, TweenInfo.new(), {GroupTransparency = 0}):Play();
  
end)

local saveStartedSound = script.Parent.Parent.SaveStarted;
ReplicatedStorage.Events.StageBuildDataSaveProgressChanged.OnClientEvent:Connect(function(step: number, current: number, total: number)
  
  local progressBar = script.Parent.LoadingBar:FindFirstChild(if step == 1 then "Packaging" else "Saving");
  
  local delay = 1.2;
  if step == 2 and saveStartedSound.Playing and saveStartedSound.TimePosition <= 1.5 then
    
    repeat task.wait() until saveStartedSound.TimePosition >= 1.5;
    delay = 1.5;
    
  end
  if step == 1 then lastTotal = total; end;
  TweenService:Create(progressBar.Progress, TweenInfo.new(delay, Enum.EasingStyle.Sine, Enum.EasingDirection[if step == 1 then "Out" else "In"]), {Size = UDim2.new(current / total, progressBar.Progress.Size.X.Offset, progressBar.Progress.Size.Y.Scale, progressBar.Progress.Size.Y.Offset)}):Play()
  
end);

ReplicatedStorage.Events.StageBuildDataSaveCompleted.OnClientEvent:Connect(function()

  if saveStartedSound.Playing and saveStartedSound.TimePosition <= 3 then

    repeat task.wait() until saveStartedSound.TimePosition >= 3;

  end

  (if lastTotal == 0 then nothingSavedTextLabel else saveCompletedTextLabel).Visible = true;
  savingTextLabel.Visible = false;
  script.Parent.GroupColor3 = Color3.fromRGB(32, 184, 62);
  
  local originalStartTime = saveStartTime;
  task.wait(3);
  
  if originalStartTime == saveStartTime then
    
    TweenService:Create(script.Parent, TweenInfo.new(), {GroupTransparency = 1}):Play();
    
  end
    
  
end)