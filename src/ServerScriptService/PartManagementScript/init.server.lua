local ReplicatedStorage = game:GetService("ReplicatedStorage");

local canPlayerManageParts = true;
script.ToggleBuildingTools.OnInvoke = function(canPlayerNowManageParts: boolean)

  canPlayerManageParts = canPlayerNowManageParts;
  ReplicatedStorage.Shared.Events.BuildingToolsToggled:FireAllClients(canPlayerManageParts);

end;

local function verifyPlayerPermissions(player: Player)

  assert(canPlayerManageParts, `{player.Name} cannot manage parts on this stage right now.`);

end;
  
local stage = workspace.Stage;
ReplicatedStorage.Shared.Functions.CreatePart.OnServerInvoke = function(player: Player, partProperties: {Shape: Enum.PartType; CFrame: CFrame})

  -- TODO: Verify player permissions and part properties.
  verifyPlayerPermissions(player);

  -- Create the part then return the part ID.
  local part = Instance.new("Part");
  part.Name = game:GetService("HttpService"):GenerateGUID();
  part.Anchored = true;
  part.Shape = partProperties.Shape;
  part.CFrame = partProperties.CFrame;
  part:SetAttribute("BaseDurability", math.huge);
  part.Parent = stage;
  
  return part.Name;
  
end

ReplicatedStorage.Shared.Functions.DestroyPart.OnServerInvoke = function(player: Player, partID: string)

  -- TODO: Verify player permissions.
  verifyPlayerPermissions(player);

  -- Destroy the part.
  stage:FindFirstChild(partID):Destroy();

end

ReplicatedStorage.Shared.Functions.UpdateParts.OnServerInvoke = function(player: Player, partIds: {string}, newProperties: {[string]: any}): ()

  -- TODO: Verify property names and player permissions.
  verifyPlayerPermissions(player);

  -- Update the properties.
  for _, partId in ipairs(partIds) do

    local part = stage:FindFirstChild(partId);
    for propertyName, propertyValue in pairs(newProperties) do

      if propertyName == "BaseDurability" then

        part:SetAttribute("BaseDurability", propertyValue);

      else 

        part[propertyName] = propertyValue;

      end;

    end;

  end;
  
end;