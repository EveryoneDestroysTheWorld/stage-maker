--!strict
-- StageSaveScript.server.lua
-- Written by Christian "Sudobeast" Toney
-- This script responds to stage save requests.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local HttpService = game:GetService("HttpService");

local Player = require(ServerStorage.Player);

local isSaving = false;

local currentStage = nil;

local function getCurrentStage(player)

  if not currentStage then

    currentStage = Player.fromID(player.UserId, true):createStage();

  end;

  return currentStage;

end;

ReplicatedStorage.Shared.Functions.GetStages.OnServerInvoke = function(player)

  local stages = {};

  local success, message = pcall(function()
  
    stages = Player.fromID(player.UserId):getStages();

  end);

  if not success then

    warn(`Couldn't get Player {player.UserId}'s stages: {message}`);

  end;

  return stages;

end;

ReplicatedStorage.Shared.Functions.SaveStageBuildData.OnServerInvoke = function(player)

  -- Verify that the player has permission to save the stage.
  assert(player, "You don't have permission to save this stage.");
  assert(not isSaving, "This stage is already saving. Wait until the process completes.");
  
  isSaving = true;
  
  local _, message = pcall(function()

    -- Start the process!
    ReplicatedStorage.Shared.Events.StageBuildDataSaveStarted:FireAllClients(player);
    
    -- Get the current stage info.
    local stage = getCurrentStage(player);
    local stageBuild: Model? = workspace:FindFirstChild("Stage");
    assert(stageBuild and stageBuild:IsA("Model"), "Couldn't find Stage the Workspace.");

    -- Package the stage.
    type Vector3Serialization = {X: number; Y: number; Z: number};
    type PackageInstance = {{
      type: string;
      properties: {
        Color: string?;
        CastShadow: boolean;
        Material: number;
        Size: Vector3Serialization;
        Position: Vector3Serialization;
        Orientation: Vector3Serialization;
        Shape: number?;
        Name: string;
      }
    }};
    local package: {{PackageInstance}} = {{}};
    local chunkIndex = 1;
    local skippedInstances = 0;
    for index, instance in ipairs(stageBuild:GetChildren()) do
      
      if instance:IsA("BasePart") then 
        
        local packageInstance: PackageInstance = {
          type = "Part";
          properties = {
            Color = instance.Color:ToHex();
            CastShadow = instance.CastShadow;
            Material = instance.Material.Value;
            Size = {
              X = instance.Size.X;
              Y = instance.Size.Y;
              Z = instance.Size.Z;
            };
            Position = {
              X = instance.Size.X;
              Y = instance.Size.Y;
              Z = instance.Size.Z;
            };
            Orientation = {
              X = instance.Size.X;
              Y = instance.Size.Y;
              Z = instance.Size.Z;
            };
            Name = instance.Name;
            Shape = if instance:IsA("Part") then instance.Shape.Value else nil;
          }
        };
        
        table.insert(package[chunkIndex], packageInstance);
        
        if HttpService:JSONEncode(package[chunkIndex]):len() > 4194304 then
          
          table.remove(package[chunkIndex], #package[chunkIndex]);
          chunkIndex += 1;
          package[chunkIndex] = {packageInstance};

        end

      else

        skippedInstances += 1;

      end;

      ReplicatedStorage.Shared.Events.StageBuildDataSaveProgressChanged:FireAllClients(1, index - skippedInstances, #stageBuild:GetChildren() - skippedInstances);

    end;
    
    -- Serialize the package.
    local serializedPackage = {};
    for _, chunk in ipairs(package) do
      
      table.insert(serializedPackage, HttpService:JSONEncode(chunk));
      
    end

    -- Save the stage into a DataStore.
    local onBuildDataUpdateProgressChanged;
    onBuildDataUpdateProgressChanged = stage.onBuildDataUpdateProgressChanged.Event:Connect(function(current, total)

      ReplicatedStorage.Shared.Events.StageBuildDataSaveProgressChanged:FireAllClients(2, current, total);

    end);
    stage:updateMetadata({
      timeUpdated = DateTime.now().UnixTimestampMillis;
    });
    stage:updateBuildData(serializedPackage);
    onBuildDataUpdateProgressChanged:Disconnect();

    -- 
    print("Successfully saved the stage's build data.");
    ReplicatedStorage.Shared.Events.StageBuildDataSaveCompleted:FireAllClients(player);
    
  end);
  
  isSaving = false;
  
  
  if message then
    
    error(message);
    
  end
  
end