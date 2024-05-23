local ReplicatedStorage = game:GetService("ReplicatedStorage");
  
ReplicatedStorage.Shared.Functions.CreatePart.OnServerInvoke = function(player: Player, partData: {Shape: Enum.PartType; CFrame: CFrame})

  local part = Instance.new("Part");
  part.Name = game:GetService("HttpService"):GenerateGUID();
  part.Anchored = true;
  part.Shape = partData.Shape;
  part.CFrame = partData.CFrame;
  part.Parent = workspace.Stage;
  
  return part.Name;
  
end

ReplicatedStorage.Shared.Functions.DestroyPart.OnServerInvoke = function(player: Player, partID: string)

  workspace.Stage:FindFirstChild(partID):Destroy();

end