game:GetService("ReplicatedStorage").Functions.CreatePart.OnServerInvoke = function(player: Player, cFrame: CFrame)

  local part = Instance.new("Part");
  part.Anchored = true;
  part.CFrame = cFrame;
  part.Parent = workspace.Stage;
  
end
