--!strict
-- SaveRequestScript.lua
-- Written by Christian "Sudobeast" Toney
-- This script sends a request to the server to save the current stage.

local ContextActionService = game:GetService("ContextActionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TextChatService = game:GetService("TextChatService");

local saveStartedSound = script.Parent.SaveStarted;
local saveCompleteSound = script.Parent.SaveComplete;

local function sendSaveRequest(): ()
  
  -- Ensure the player pressed CTRL+S instead of just "S".
  if not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and not UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then return; end; 
  
  -- Send a save request to the server.
  print("Asking the server to save the stage...");
  ReplicatedStorage.Functions.SaveStageBuildData:InvokeServer();
  print("The server successfully saved the stage.")
  
end

ReplicatedStorage.Events.StageBuildDataSaveStarted.OnClientEvent:Connect(function(player)
  
  TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(`💾 <font color="#20b83e">{player.Name} saved the stage.</font>`);
  saveStartedSound:Play();
  
end)

ReplicatedStorage.Events.StageBuildDataSaveCompleted.OnClientEvent:Connect(function()
  
  if saveStartedSound.Playing and saveStartedSound.TimePosition <= 3 then
    
    repeat task.wait() until saveStartedSound.TimePosition >= 3;
    
  end

  saveCompleteSound:Play();
  
end)

ContextActionService:BindActionAtPriority("Save", sendSaveRequest, false, 2, Enum.KeyCode.S);
