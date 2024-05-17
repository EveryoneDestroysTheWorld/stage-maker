--!strict
-- Stage.lua
-- Written by Christian "Sudobeast" Toney
-- This module is a class that represents a stage.

local DataStoreService = game:GetService("DataStoreService");

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
  
  -- A list of StageMemberObject.
  members: {StageMemberObject};
  
  -- The stage's description.
  description: string?;
  
  -- [Methods]
  updateBuildData: (self: StageMetadataObject, newData: NewDataParameter) -> ();
  updateMetadata: (self: StageMetadataObject, newData: NewDataParameter) -> ();
  delete: (self: StageMetadataObject) -> ();
  verifyID: (self: StageMetadataObject) -> ();
  
  -- [Events]
  -- Fires when the stage metadata is updated.
  onMetadataUpdate: RBXScriptSignal;
  
  -- Fires when the build data is completely updated.
  onBuildDataUpdate: RBXScriptSignal;
  
  -- Fires when the build data is partially updated. 
  onBuildDataUpdateProgressChanged: RBXScriptSignal;
  
  -- Fires when the stage is deleted.
  onDelete: RBXScriptSignal;
  
}


local Stage: StageMetadataObject = {} :: StageMetadataObject;

local events = {};
for _, eventName in ipairs({"onMetadataUpdate", "onBuildDataUpdate", "onBuildDataUpdateProgressChanged", "onDelete"}) do

  events[eventName] = Instance.new("BindableEvent");
  Stage[eventName] = events[eventName].Event;
  
end

function Stage:verifyID(): ()
  
  -- Generate a stage ID.
  if not self.ID then
    
    self.ID = "#3";
    
  end
  
end

-- Edits the stage's metadata.
function Stage:updateBuildData(newBuildData: {string}): ()
  
  self:verifyID();
  
  local datastore = DataStoreService:GetDataStore("StageBuildData");
  for index, chunk in ipairs(newBuildData) do

    datastore:SetAsync(`{self.ID}/{index}`, chunk);
    events.onBuildDataUpdateProgressChanged:Fire(index, #newBuildData);

  end
  events.onBuildDataUpdate:Fire();

end

-- Edits the stage's metadata.
function Stage:updateMetadata(newData: NewDataParameter): ()

  self:verifyID();
  
  events.onMetadataUpdate:Fire();
  
end

-- Irrecoverably deletes the stage, including its build data.
function Stage:delete(): ()
  
  print(`Stage {self.ID} has been successfully deleted.`);
  events.onDelete:Fire();
  
end

return Stage;
