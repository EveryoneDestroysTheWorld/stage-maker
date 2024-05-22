--!strict
-- SpeedModifierScript.lua
-- Written by Christian "Sudobeast" Toney 
-- This script modifies the speed of the character.

local TextChatService = game:GetService("TextChatService");

local defaultSpeed = 16;
local player = game:GetService("Players").LocalPlayer;

if player.Character then
  
  local humanoid = player.Character:WaitForChild("Humanoid");
  defaultSpeed = humanoid.WalkSpeed;
  
end
  
local speedCommand = TextChatService.Commands.SpeedCommand;
speedCommand.Triggered:Connect(function(_, text)
  
  local arguments: string = text:sub(speedCommand.PrimaryAlias:len() + 2);
  local firstSpaceIndex: number? = arguments:find(" ");
  local firstArgument = if firstSpaceIndex then arguments:sub(1, firstSpaceIndex - 1) else arguments;
  local speed = defaultSpeed;
  if firstArgument ~= "" and firstArgument:lower() ~= "default" then
    
    local possibleSpeed: number? = tonumber(firstArgument);
    if not possibleSpeed then
      
      TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(`Couldn't change {player.Name}'s speed: "{arguments}" isn't a number`);
      return;
      
    end
    speed = possibleSpeed;
    
  end
  
  player.Character.Humanoid.WalkSpeed = speed;
  TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(`Changed {player.Name}'s speed to {speed}`);
  
end)