--!strict
-- HistoryStore.lua
-- Written by Christian "Sudobeast" Toney

export type HistoryEvent = {
  label: string;
  imageId: string;
  redo: (self: HistoryEvent) -> ();
  undo: (self: HistoryEvent) -> ();
}

type HistoryStore = {
  -- Properties
  events: {HistoryEvent};
  pointerOffset: number;
  eventCapacity: number;
  
  -- Methods
  add: (self: HistoryStore, event: HistoryEvent) -> ();
  setPointerOffset: (self: HistoryStore, newPointerOffset: number) -> ();
  setEventCapacity: (self: HistoryStore, newEventCapacity: number) -> ();
  
  -- Events
  onEventAdd: BindableEvent;
  onPointerOffsetChange: BindableEvent;
  onEventCapacityChange: BindableEvent;
};

local HistoryStore: HistoryStore = {
  events = {};
  pointerOffset = 0;
  eventCapacity = math.huge;
  onEventAdd = Instance.new("BindableEvent");
  onPointerOffsetChange = Instance.new("BindableEvent");
  onEventCapacityChange = Instance.new("BindableEvent");
} :: HistoryStore;


-- Adds an event to the HistoryStore.
function HistoryStore:add(event: HistoryEvent): ()
  
  -- Check if we need to delete a timeline.
  if self.pointerOffset ~= 0 then
    
    self.events = table.pack(table.unpack(self.events, 1, #self.events - self.pointerOffset));
    
  end
  
  -- Add item to the list.
  self.events[#self.events + 1] = event;
  
  -- Reset the pointer offset.
  self.pointerOffset = 0;
  
  -- Fire the event.
  self.onEventAdd:Fire();
  
end

-- Changes the pointer offset of the HistoryStore. 
function HistoryStore:setPointerOffset(newPointerOffset: number): ()
  
  if newPointerOffset == self.pointerOffset then return; end;
  
  local increment = if newPointerOffset > self.pointerOffset then 1 else -1;
  for i = self.pointerOffset, newPointerOffset, increment do
    
    local event = self.events[#self.events - i];
    local method = if increment == 1 then "undo" else "redo";
    event[method](event);
    
  end
  
  self.pointerOffset = newPointerOffset;
  
  self.onPointerOffsetChange:Fire();
  
end

-- Changes the event capacity of the HistoryStore. Existing events beyond the new capacity will be deleted.
function HistoryStore:setEventCapacity(newEventCapacity: number): ()
  
  self.eventCapacity = newEventCapacity;
  
  if #self.events > self.eventCapacity then
    
    self.events = table.pack(table.unpack(self.events, 1 + (#self.events - self.eventCapacity), #self.events))
    
  end
  
  self.onEventCapacityChange:Fire();
  
end

return HistoryStore;
