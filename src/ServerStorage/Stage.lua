--!strict
-- Stage.lua
-- Written by Christian "Sudobeast" Toney
-- This module is a class that represents a stage.

local DataStoreService = game:GetService("DataStoreService");
local DataStore = {
  StageMetadata = DataStoreService:GetDataStore("StageMetadata");
  StageBuildData = DataStoreService:GetDataStore("StageBuildData");
}
local HttpService = game:GetService("HttpService");

type PermissionOverride = {
  ["stage.delete"]: boolean?;
  ["stage.save"]: boolean?;
};

type NewDataParameter = {
  permissionOverrides: {PermissionOverride}?;
  name: string?;
  description: string?;
};

type StageMemberObject = {
  id: number;
  role: number;
};

type StageMetadataObject = {
  
  -- [Properties]
  -- The stage's unique ID.
  ID: string?;
  
  -- A list of stage overrides.
  permissionOverrides: {PermissionOverride};
  
  -- The stage's name.
  name: string;
  
  -- Time in seconds when the stage was created.
  timeCreated: number;
  
  --Time in seconds when the stage was last updated.
  timeUpdated: number;
  
  -- The stage's description.
  description: string?;

  -- The stage's members.
  members: {
    {
      ID: string;
      role: "admin";
    }
  };
  
}

type StageMethods = {
  updateBuildData: (self: StageMetadataObject, newData: NewDataParameter) -> ();
  updateMetadata: (self: StageMetadataObject, newData: NewDataParameter) -> ();
  delete: (self: StageMetadataObject) -> ();
  verifyID: (self: StageMetadataObject) -> ();
}

type StageEvents = {
  -- Fires when the stage metadata is updated.
  onMetadataUpdate: RBXScriptSignal;
  
  -- Fires when the build data is completely updated.
  onBuildDataUpdate: RBXScriptSignal;
  
  -- Fires when the build data is partially updated. 
  onBuildDataUpdateProgressChanged: RBXScriptSignal;
  
  -- Fires when the stage is deleted.
  onDelete: RBXScriptSignal;
}

local Stage = {
  __index = {};
};

export type Stage = typeof(setmetatable({}, {__index = Stage.__index})) & StageMetadataObject & StageMethods & StageEvents;

local events = {};

function Stage.new(properties: {[string]: any}?): Stage
  
  local stage = {
    name = "Unnamed Stage";
    timeCreated = DateTime.now().UnixTimestampMillis;
    timeUpdated = DateTime.now().UnixTimestampMillis;
    members = {};
  };

  for _, eventName in ipairs({"onMetadataUpdate", "onBuildDataUpdate", "onBuildDataUpdateProgressChanged", "onDelete"}) do

    events[eventName] = Instance.new("BindableEvent");
    stage[eventName] = events[eventName].Event;

  end

  if properties then

    stage.ID = if properties.ID then properties.ID else stage.ID;
    stage.name = if properties.name then properties.name else stage.name;
    stage.description = if properties.description then properties.description else stage.description;
    stage.timeCreated = if properties.timeCreated then properties.timeCreated else stage.timeCreated;
    stage.timeUpdated = if properties.timeUpdated then properties.timeUpdated else stage.timeUpdated;
    stage.permissionOverrides = if properties.permissionOverrides then properties.permissionOverrides else stage.permissionOverrides;
    stage.members = if properties.members then properties.members else stage.members;

  end;

  setmetatable(stage, {__index = Stage.__index});
  
  return stage :: any;
  
end

function Stage.fromID(id: string): Stage
  
  local stageData = DataStoreService:GetDataStore("StageMetadata"):GetAsync(id);
  assert(stageData, `Stage {id} doesn't exist yet.`);
  
  return Stage.new(stageData);
  
end

function Stage.__index:verifyID(): ()
  
  while not self.ID do

    -- Generate a stage ID.
    local possibleID = HttpService:GenerateGUID();
    local canGetStage = pcall(function() Stage.fromID(possibleID) end);
    if not canGetStage then 

      self.ID = possibleID;

    end;
    
  end;
  
end

-- Edits the stage's metadata.
function Stage.__index:updateBuildData(newBuildData: {string}): ()
  
  self:verifyID();
  
  for index, chunk in ipairs(newBuildData) do

    DataStore.StageBuildData:SetAsync(`{self.ID}/{index}`, chunk);
    events.onBuildDataUpdateProgressChanged:Fire(index, #newBuildData);

  end
  events.onBuildDataUpdate:Fire();

end

-- Edits the stage's metadata.
function Stage.__index:updateMetadata(newData: StageMetadataObject): ()

  self:verifyID();

  DataStore.StageMetadata:UpdateAsync(self.ID, function(encodedOldMetadata)
  
    local newMetadata = HttpService:JSONDecode(encodedOldMetadata or "{}");
    for key, value in pairs(newData) do

      newMetadata[key] = value;

    end;

    return HttpService:JSONEncode(newMetadata);

  end);

  for key, value in pairs(newData) do

    self[key] = value;

  end;
  
  events.onMetadataUpdate:Fire(newData);
  
end

-- Irrecoverably deletes the stage, including its build data.
function Stage.__index:delete(): ()
  
  -- Delete build data.
  local stageBuildDataDataStore = DataStoreService:GetDataStore("StageBuildData");
  local keys = stageBuildDataDataStore:ListKeysAsync(self.ID);
  for _, key in ipairs(keys) do

    stageBuildDataDataStore:RemoveAsync(key);

  end
  
  -- Delete metadata.
  DataStoreService:GetDataStore("StageMetadata"):RemoveAsync(self.ID);
  
  -- Tell the player.
  print(`Stage {self.ID} has been successfully deleted.`);
  events.onDelete:Fire();
  
end

function Stage.__index:getBuildData(): {{{type: string; properties: {[string]: any}}}}

  local keyList = DataStore.StageBuildData:ListKeysAsync(self.ID);
  local buildDataEncoded = {};
  repeat

    local keys = keyList:GetCurrentPage();
    for _, key in ipairs(keys) do

      table.insert(buildDataEncoded, HttpService:JSONDecode(DataStore.StageBuildData:GetAsync(key.KeyName)));
  
    end;

    if not keyList.IsFinished then

      keyList:AdvanceToNextPageAsync();

    end;

  until keyList.IsFinished;

  return buildDataEncoded;

end;

return Stage;