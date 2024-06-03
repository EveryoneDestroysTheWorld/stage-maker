--!strict
-- StageSaveScript.server.lua
-- Written by Christian "Sudobeast" Toney
-- This script responds to stage save requests.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local HttpService = game:GetService("HttpService");
local ServerScriptService = game:GetService("ServerScriptService");

local Player = require(ServerStorage.Player);
local Stage = require(ServerStorage.Stage);

local isSaving = false;

local currentStage = nil;

local function getCurrentStage(player)

  if not currentStage then

    print("[Saving] Current stage not found. Creating a new one.");
    currentStage = Player.fromID(player.UserId, true):createStage();

  end;

  return currentStage;

end;

script.GetCurrentStage.OnInvoke = function()

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
  print(`[Saving] {player.Name} ({player.UserId}) requested to save the stage.`);
  assert(player, "You don't have permission to save this stage.");
  assert(not isSaving, "This stage is already saving. Wait until the process completes.");
  
  isSaving = true;
  
  local _, message = pcall(function()

    -- Start the process!
    ReplicatedStorage.Shared.Events.StageBuildDataSaveStarted:FireAllClients(player);
    
    -- Get the current stage info.
    local stage = getCurrentStage(player);
    print(`[Saving] Stage ID: {stage.ID}`);
    local stageBuild: Model? = workspace:FindFirstChild("Stage");
    assert(stageBuild and stageBuild:IsA("Model"), "Couldn't find Stage the Workspace.");

    -- Package the stage.
    type Vector3Serialization = {X: number; Y: number; Z: number};
    local package: Stage.StageBuildData = {{}};
    local chunkIndex = 1;
    local skippedInstances = 0;
    for index, instance in ipairs(stageBuild:GetChildren()) do
      
      if instance:IsA("BasePart") then 
        
        local packageInstance: Stage.StageBuildDataItem = {
          type = "Part";
          properties = {
            Anchored = instance.Anchored;
            CanCollide = instance.CanCollide;
            Color = instance.Color:ToHex();
            CastShadow = instance.CastShadow;
            Material = instance.Material.Value;
            Size = {
              X = instance.Size.X;
              Y = instance.Size.Y;
              Z = instance.Size.Z;
            };
            Position = {
              X = instance.Position.X;
              Y = instance.Position.Y;
              Z = instance.Position.Z;
            };
            Orientation = {
              X = instance.Orientation.X;
              Y = instance.Orientation.Y;
              Z = instance.Orientation.Z;
            };
            BackSurface = instance.BackSurface.Value;
            BottomSurface = instance.BottomSurface.Value;
            FrontSurface = instance.FrontSurface.Value;
            LeftSurface = instance.LeftSurface.Value;
            RightSurface = instance.RightSurface.Value;
            TopSurface = instance.TopSurface.Value;
            Name = instance.Name;
            Reflectance = instance.Reflectance;
            Transparency = instance.Transparency;
            Shape = if instance:IsA("Part") then instance.Shape.Value else nil;
          };
          attributes = {
            BaseDurability = instance:GetAttribute("BaseDurability");
          };
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
    onBuildDataUpdateProgressChanged = stage.onBuildDataUpdateProgressChanged:Connect(function(current, total)

      ReplicatedStorage.Shared.Events.StageBuildDataSaveProgressChanged:FireAllClients(2, current, total);

    end);

    print("[Saving] Updating stage metadata...");
    stage:updateMetadata({
      timeUpdated = DateTime.now().UnixTimestampMillis;
    });

    print("[Saving] Updating stage build data...");
    stage:updateBuildData(serializedPackage);
    task.wait();
    onBuildDataUpdateProgressChanged:Disconnect();

    -- 
    print("[Saving] Successfully saved the stage's build data.");
    ReplicatedStorage.Shared.Events.StageBuildDataSaveCompleted:FireAllClients(player);
    
  end);
  
  isSaving = false;
  
  if message then
    
    error(message);
    
  end
  
end;

ReplicatedStorage.Shared.Functions.DeleteStage.OnServerInvoke = function(player, stageID)

  Stage.fromID(stageID):delete();
  ReplicatedStorage.Shared.Events.StageDeleted:FireAllClients(stageID);

end;

local isDownloading = false;
ReplicatedStorage.Shared.Functions.SetStage.OnServerInvoke = function(player, stageID)

  assert(not isDownloading, "The server is currently downloading a stage. Please cancel the request or wait until the download completes before making a new request.");
  isDownloading = true;

  -- Empty the stage.
  for _, instance in ipairs(workspace.Stage:GetChildren()) do

    instance:Destroy();

  end;
  
  if stageID then

    -- Get the stage from the DataStore.
    ReplicatedStorage.Shared.Events.StageBuildDataDownloadStarted:FireAllClients(player, stageID);
    currentStage = Stage.fromID(stageID);

    local downloadProgressChangedEvent = currentStage.onStageBuildDataDownloadProgressChanged:Connect(function(partsAudited, totalParts)
    
      ReplicatedStorage.Shared.Events.StageBuildDataDownloadProgressChanged:FireAllClients(stageID, partsAudited, totalParts);

    end);
    local stageModel = currentStage:download();
    downloadProgressChangedEvent:Disconnect();
    
    for _, instance in ipairs(stageModel:GetChildren()) do

      instance.Parent = workspace.Stage;

    end;
    stageModel:Destroy();

    ReplicatedStorage.Shared.Events.StageBuildDataDownloadCompleted:FireAllClients(stageID);
  end;

  -- Reset the status so that we can download more stages.
  isDownloading = false;

end;

ReplicatedStorage.Shared.Functions.PublishStage.OnServerInvoke = function(player: Player, stageID: string)

  -- Verify that the stage ID is a string.
  assert(typeof(stageID) == "string", "Stage ID must be a string.");

  -- Lock editing on this stage.
  local isPublishingCurrentStage = if currentStage then currentStage.ID == stageID else false;
  if isPublishingCurrentStage then

    ServerScriptService.PartManagementScript.ToggleBuildingTools:Invoke(false);

  end;

  -- Find and publish the stage.
  local stage = if isPublishingCurrentStage then currentStage else Stage.fromID(stageID); 
  local isStagePublished, errorMessage = pcall(function()
  
    print(`Publishing Stage {stageID}...`);
    stage:publish();
    ReplicatedStorage.Shared.Events.StageUpdated:FireAllClients(stageID, stage);

  end);

  if not isStagePublished then

    -- Unlock editing on this stage if a problem happened.
    if isPublishingCurrentStage then

      ServerScriptService.PartManagementScript.ToggleBuildingTools:Invoke(true);

    end;
    error(`Could not publish stage: {errorMessage}`);

  end;

end;

ReplicatedStorage.Shared.Functions.UnpublishStage.OnServerInvoke = function(player: Player, stageID: string)

  -- Verify that the stage ID is a string.
  assert(typeof(stageID) == "string", "Stage ID must be a string.");

  -- Find and publish the stage.
  local isUnpublishingCurrentStage = if currentStage then currentStage.ID == stageID else false;
  local stage = if isUnpublishingCurrentStage then currentStage else Stage.fromID(stageID); 
  local isStageUnpublished, errorMessage = pcall(function()
  
    print(`Publishing Stage {stageID}...`);
    stage:unpublish();
    ReplicatedStorage.Shared.Events.StageUpdated:FireAllClients(stageID, stage);

  end);

  if not isStageUnpublished then

    error(`Could not unpublish stage: {errorMessage}`);

  end;

  -- Unlock editing on this stage.
  if isUnpublishingCurrentStage then

    ServerScriptService.PartManagementScript.ToggleBuildingTools:Invoke(true);

  end;

end;