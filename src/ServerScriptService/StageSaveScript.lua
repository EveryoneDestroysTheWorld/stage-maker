--!strict
-- StageSaveScript.lua
-- Written by Christian "Sudobeast" Toney
-- This script responds to stage save requests.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DataStoreService = game:GetService("DataStoreService");
local ServerStorage = game:GetService("ServerStorage");
local HttpService = game:GetService("HttpService");

local isSaving = false;

ReplicatedStorage.Functions.SaveStageBuildData.OnServerInvoke = function(player)

  -- Verify that the player has permission to save the stage.
  assert(player, "You don't have permission to save this stage.");
  assert(not isSaving, "This stage is already saving. Wait until the process completes.");
  
  isSaving = true;
  
  local _, message = pcall(function()
    
    -- Get the current stage info.
    --local stage = ServerStorage.Functions.GetStage:Invoke();
    local stage = require(ServerStorage.Stage)
    local stageBuild: Model? = workspace:FindFirstChild("Stage");
    assert(stageBuild and stageBuild:IsA("Model"), "Couldn't find Stage the Workspace.");

    -- Package the stage.
    ReplicatedStorage.Events.StageBuildDataSaveStarted:FireAllClients();
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

      ReplicatedStorage.Events.StageBuildDataSaveProgressChanged:FireAllClients(1, index - skippedInstances, #stageBuild:GetChildren() - skippedInstances);

    end;
    
    -- Serialize the package.
    local serializedPackage = {};
    for _, chunk in ipairs(package) do
      
      table.insert(serializedPackage, HttpService:JSONEncode(chunk));
      
    end

    -- Save the stage into a DataStore.
    local onBuildDataUpdateProgressChanged;
    onBuildDataUpdateProgressChanged = stage.onBuildDataUpdateProgressChanged:Connect(function(current, total)

      ReplicatedStorage.Events.StageBuildDataSaveProgressChanged:FireAllClients(2, current, total);

    end)
    stage:updateBuildData(serializedPackage);

    -- 
    print("Successfully saved the stage's build data.");
    ReplicatedStorage.Events.StageBuildDataSaveCompleted:FireAllClients();
    
  end);
  
  isSaving = false;
  
  if message then
    
    error(message);
    
  end
  
end
