local ReplicatedStorage = game:GetService("ReplicatedStorage");
  
local stage = workspace.Stage;
ReplicatedStorage.Shared.Functions.CreatePart.OnServerInvoke = function(player: Player, partProperties: {Shape: Enum.PartType; CFrame: CFrame})

  -- TODO: Verify player permissions and part properties.

  -- Create the part then return the part ID.
  local part = Instance.new("Part");
  part.Name = game:GetService("HttpService"):GenerateGUID();
  part.Anchored = true;
  part.Shape = partProperties.Shape;
  part.CFrame = partProperties.CFrame;
  part.Parent = stage;
  
  return part.Name;
  
end

ReplicatedStorage.Shared.Functions.DestroyPart.OnServerInvoke = function(player: Player, partID: string)

  -- TODO: Verify player permissions.

  -- Destroy the part.
  stage:FindFirstChild(partID):Destroy();

end

ReplicatedStorage.Shared.Functions.UpdateParts.OnServerInvoke = function(player: Player, partIds: {string}, newProperties: {[string]: any}): ()

  -- TODO: Verify property names and player permissions.

  -- Update the properties.
  for _, partId in ipairs(partIds) do

    local part = stage:FindFirstChild(partId);
    for propertyName, propertyValue in pairs(newProperties) do

      part[propertyName] = propertyValue;

    end;

  end;
  
end;