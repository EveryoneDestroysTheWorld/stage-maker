game:GetService("ReplicatedStorage").Functions.CreatePart.OnServerInvoke = function(player: Player, cFrame: CFrame)

  local part = Instance.new("Part");
  part.Name = game:GetService("HttpService"):GenerateGUID();
  part.Anchored = true;
  part.CFrame = cFrame;
  part.Parent = workspace.Stage;
  
  return part.Name;
  
end

game:GetService("ReplicatedStorage").Functions.DestroyPart.OnServerInvoke = function(player: Player, partID: string)
  
  workspace.Stage:FindFirstChild(partID):Destroy();

end
