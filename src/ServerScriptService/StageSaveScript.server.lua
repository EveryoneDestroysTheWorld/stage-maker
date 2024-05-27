--!strict
-- StageSaveScript.server.lua
-- Written by Christian "Sudobeast" Toney
-- This script responds to stage save requests.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");

local Player = require(ServerStorage.Player);
local Stage = require(ServerStorage.Stage);

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
    onBuildDataUpdateProgressChanged = stage.onBuildDataUpdateProgressChanged:Connect(function(current, total)

      ReplicatedStorage.Shared.Events.StageBuildDataSaveProgressChanged:FireAllClients(2, current, total);

    end);
    stage:updateMetadata({
      timeUpdated = DateTime.now().UnixTimestampMillis;
    });
    stage:updateBuildData(serializedPackage);
    task.wait();
    onBuildDataUpdateProgressChanged:Disconnect();

    -- 
    print("Successfully saved the stage's build data.");
    ReplicatedStorage.Shared.Events.StageBuildDataSaveCompleted:FireAllClients(player);
    
  end);
  
  isSaving = false;
  
  
  if message then
    
    error(message);
    
  end
  
end;

local isDownloading = false;
ReplicatedStorage.Shared.Functions.DownloadStage.OnServerInvoke = function(player, stageID)

  assert(not isDownloading, "The server is currently downloading a stage. Please cancel the request or wait until the download completes before making a new request.");

  -- Get the stage from the DataStore.
  ReplicatedStorage.Shared.Events.StageBuildDataDownloadStarted:FireAllClients(player);
  local stageBuildData = Stage.fromID(stageID):getBuildData();

  -- Empty the stage.
  for _, instance in ipairs(workspace.Stage:GetChildren()) do

    instance:Destroy();

  end;

  -- Calculate the total parts.
  local totalParts = 0;
  for _, page in ipairs(stageBuildData) do

    for _, instance in ipairs(page) do

      totalParts += 1;

    end;

  end;

  -- Add the parts to the stage model.
  local partsAudited = 0;
  for _, page in ipairs(stageBuildData) do

    for _, instanceData in ipairs(page) do

      local instance = Instance.new(instanceData.type) :: any;
      local function setEnum(enum, property, value)

        for _, enumItem in ipairs(enum:GetEnumItems()) do

          if enumItem.Value == value then
            
            instance[property] = enumItem;

          end;

        end;  

      end;

      for property, value in pairs(instanceData.properties) do

        if property == "Color" then

          instance[property] = Color3.fromHex(value);

        elseif ({Size = 1; Position = 1; Orientation = 1})[property] then

          instance[property] = Vector3.new(value.X, value.Y, value.Z);

        elseif property == "Shape" then

          setEnum(Enum.PartType, property, value);

        elseif property == "Material" then

          setEnum(Enum.Material, property, value);

        elseif ({Name = 1; CastShadow = 1;})[property] then

          instance[property] = value;

        elseif property == "BaseDurability" then

          instance:SetAttribute("BaseDurability", value);

        else

          warn(`Unknown property: {property}`);

        end;

      end;

      instance.Parent = workspace.Stage;

      partsAudited += 1;
      ReplicatedStorage.Shared.Events.StageBuildDataDownloadProgressChanged:FireAllClients(stageID, partsAudited, totalParts);

    end;

  end;

  -- Reset the status so that we can download more stages.
  isDownloading = false;
  ReplicatedStorage.Shared.Events.StageBuildDataDownloadCompleted:FireAllClients(stageID);

  for _, player in ipairs(Players:GetPlayers()) do

    player:LoadCharacter();

  end;

end;