--!strict
-- SpeedModifierScript.lua
-- Written by Christian "Sudobeast" Toney 
-- This script modifies the speed of the character.

local defaultSpeed = 16;
local player = game:GetService("Players").LocalPlayer;
local currentSpeedTextBox = script.Parent.CurrentSpeed;
local defaultSpeedButton = script.Parent.Default;
function changeDefaultSpeed(newSpeed: number): ()
  
  defaultSpeed = newSpeed;
  defaultSpeedButton.Visible = defaultSpeed ~= tonumber(currentSpeedTextBox.PlaceholderText);
  
end;

if player.Character then
  
  local humanoid = player.Character.Humanoid;
  currentSpeedTextBox.PlaceholderText = humanoid.WalkSpeed;
  changeDefaultSpeed(humanoid.WalkSpeed);
  humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    
    currentSpeedTextBox.PlaceholderText = humanoid.WalkSpeed;
    defaultSpeedButton.Visible = defaultSpeed ~= tonumber(currentSpeedTextBox.PlaceholderText);
    
  end)
  
end
  
currentSpeedTextBox.FocusLost:Connect(function(enterPressed)
  
  if enterPressed then
    
    player.Character.Humanoid.WalkSpeed = tonumber(currentSpeedTextBox.Text);
    
  end
    
  currentSpeedTextBox.Text = "";
  
end)

defaultSpeedButton.MouseButton1Click:Connect(function() 
  
  player.Character.Humanoid.WalkSpeed = defaultSpeed;
  
end)
