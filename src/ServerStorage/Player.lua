--!strict
-- Player.lua
-- Written by Christian "Sudobeast" Toney
-- This module is a class that represents a player.

local DataStoreService = game:GetService("DataStoreService");
local DataStore = {
  PlayerMetadata = DataStoreService:GetDataStore("PlayerMetadata");
  Inventory = DataStoreService:GetDataStore("Inventory");
}
local HttpService = game:GetService("HttpService");
local Stage = require(script.Parent.Stage);

type PlayerMetadataObject = {
  
  -- [Properties]
  -- The player's ID.
  ID: number;

  timeFirstPlayed: number;

  timeLastPlayed: number;
  
}

local Player = {
  __index = {};
};

export type Player = typeof(setmetatable({}, {__index = Player.__index})) & PlayerMetadataObject;

-- Returns a new Player object.
function Player.new(properties: {[string]: any}): Player
  
  local player = {
    ID = properties.ID;
    timeFirstPlayed = properties.timeFirstPlayed;
    timeLastPlayed = properties.timeLastPlayed;
  };
  setmetatable(player, {__index = Player.__index});

  return player :: any;
  
end

-- Returns a Player object based on the ID.
function Player.fromID(playerID: string, createIfNotFound: boolean?): Player
  
  local playerData = DataStore.PlayerMetadata:GetAsync(playerID);
  if not playerData and createIfNotFound then

    local playTime = DateTime.now().UnixTimestampMillis;
    playerData = HttpService:JSONEncode({
      ID = playerID;
      timeFirstPlayed = playTime;
      timeLastPlayed = playTime;
    });
    DataStore.PlayerMetadata:SetAsync(playerID, playerData, {playerID});

  end;
  assert(playerData, `Player {playerID} not found.`);
  
  return Player.new(HttpService:JSONDecode(playerData));
  
end

-- Deletes all player data.
function Player.__index:delete(): ()

end;

-- Creates a stage on behalf of the player.
function Player.__index:createStage(): Stage.Stage

  local timeCreated = DateTime.now().UnixTimestampMillis;
  local stage = Stage.new({
    name = "Unnamed Stage";
    timeUpdated = timeCreated;
    timeCreated = timeCreated;
    description = "";
    isPublished = false;
    permissionOverrides = {};
    members = {
      {
        ID = self.ID;
        role = "Admin";
      }
    };
  });

  stage:verifyID();
  stage:updateMetadata(HttpService:JSONDecode(stage:toString()));

  -- Add this stage to the player's inventory.
  local stageInventoryKeyList = DataStore.Inventory:ListKeysAsync(`{self.ID}/stages`);
  while not stageInventoryKeyList.IsFinished do

    stageInventoryKeyList:AdvanceToNextPageAsync();

  end;
  local latestKeys = stageInventoryKeyList:GetCurrentPage();
  local latestKey = (latestKeys[#latestKeys] or {KeyName = `{self.ID}/stages/1`}).KeyName;
  DataStore.Inventory:UpdateAsync(latestKey, function(encodedStageIDs)
    
    local stageIDs = HttpService:JSONDecode(encodedStageIDs or "{}");
    table.insert(stageIDs, stage.ID);
    return HttpService:JSONEncode(stageIDs);

  end);
  
  return stage;

end;

function Player.__index:getStages(): {Stage.Stage}

  local stages = {};
  local keyList = DataStore.Inventory:ListKeysAsync(`{self.ID}/stages`);
  repeat

    local keys = keyList:GetCurrentPage();
    for _, key in ipairs(keys) do

      local stageListEncoded = DataStore.Inventory:GetAsync(key.KeyName);
      local stageList = HttpService:JSONDecode(stageListEncoded);
      for _, stageID in ipairs(stageList) do
  
        local success, message = pcall(function()

          table.insert(stages, Stage.fromID(stageID));

        end);
        
        if not success then

          warn(message);
  
        end;
  
      end;
  
    end;

    if not keyList.IsFinished then

      keyList:AdvanceToNextPageAsync();

    end;

  until keyList.IsFinished;

  return stages;

end;

return Player;