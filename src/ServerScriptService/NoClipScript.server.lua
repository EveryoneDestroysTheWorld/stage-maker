--!strict
-- NoClipScript.lua
-- Written by Christian "Sudobeast" Toney
game:GetService("ReplicatedStorage").Shared.Functions.TogglePlayerCollision.OnServerInvoke = function(player, mode)

  -- Let the player go through walls.
  for _, instance in ipairs(player.Character:GetChildren()) do
    
    if instance:IsA("BasePart") then
      
      instance.CollisionGroup = if mode == "walking" then "Default" else "Flyers";
      
    end
    
  end
  
end