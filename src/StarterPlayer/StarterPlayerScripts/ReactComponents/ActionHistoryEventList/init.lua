--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);
local ReactRoblox = require(ReplicatedStorage.Packages.ReactLua.ReactRoblox);
local ActionHistoryEventItem = require(script.Parent.ActionHistoryEventItem);
local HistoryStore = require(script.Parent.Parent.ReactUIRoots.ActionHistory.HistoryStore);

type ActionHistoryEventListProps = {
  historyStore: HistoryStore.HistoryStore;
  events: {{
    iconImage: string;
    description: string;
  }}
}

local function ActionHistoryEventList(props: ActionHistoryEventListProps)

  local eventItems = {};
  for index, event in ipairs(props.events) do

    eventItems[#props.events - index + 1] = React.createElement(ActionHistoryEventItem, {
      LayoutOrder = #props.events - index;
      description = event.description;
      iconImage = event.iconImage;
      currentPointerOffset = props.historyStore.pointerOffset;
      onClick = function()

        script.Processing:Play();
        props.historyStore:setPointerOffset(#props.events - index);
        script.Processing:Stop();
        script.Done:Play();

      end
    });

  end

  return React.createElement("ScrollingFrame", {
    Name = "EventList";
    BackgroundTransparency = 1;
    Size = UDim2.new(1, 0, 1, 0);
    CanvasSize = UDim2.new(0, 0, 1, -30);
    AutomaticCanvasSize = Enum.AutomaticSize.Y;
    VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    BorderSizePixel = 0;
    ScrollingDirection = Enum.ScrollingDirection.Y;
  }, {
    React.createElement("UIListLayout", {Padding = UDim.new(0, 5); SortOrder = Enum.SortOrder.LayoutOrder;}),
    React.createElement("UIPadding", {
      PaddingBottom = UDim.new(0, 5);
      PaddingLeft = UDim.new(0, 5);
      PaddingRight = UDim.new(0, 5);
      PaddingTop = UDim.new(0, 5);
    }) :: React.ReactElement,
    eventItems
  });

end

return ActionHistoryEventList;
