local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local icons = require(ReplicatedStorage.Client.Icons);
local StatusBubble = require(script.Parent.StatusBubble);
local StageSelector = require(script.Parent.StageSelector);
local BottomButton = require(script.Parent.BottomButton);
local Screen = require(script.Parent.Screen);

type StageScreenProps = {
  onStageDownloaded: () -> (); 
};

local function StagesScreen(props: StageScreenProps)

  local selectedStage, setSelectedStage = React.useState(nil);
  local stages, setStages = React.useState({});

  React.useEffect(function()

    local stages = ReplicatedStorage.Shared.Functions.GetStages:InvokeServer();
    setStages(stages);

    -- Changes the memory address of the stage list so that the state can update.
    local function createNewStageList()

      local newStageList = {};
      for _, stage in ipairs(stages) do

        table.insert(newStageList, stage);

      end;
      stages = newStageList;

    end;

    local onStageAdd = ReplicatedStorage.Shared.Events.StageAdded.OnClientEvent:Connect(function(stage)
    
      createNewStageList();
      table.insert(stages, stage);
      setStages(stages);

    end);

    local onStageDelete = ReplicatedStorage.Shared.Events.StageDeleted.OnClientEvent:Connect(function(stageID)
    
      for stageIndex, stage in ipairs(stages) do

        if stage.ID == stageID then

          -- Remove the stage from the list.
          createNewStageList();
          table.remove(stages, stageIndex);
          setStages(stages);
          break;

        end;

      end;

    end);

    local stageUpdateEvent = ReplicatedStorage.Shared.Events.StageUpdated.OnClientEvent:Connect(function(stageID, newStageData)

      for stageIndex, stage in ipairs(stages) do

        if selectedStage and selectedStage.ID == stageID then

          setSelectedStage(newStageData);

        end;

        if stage.ID == stageID then

          createNewStageList();
          stages[stageIndex] = newStageData;
          setStages(stages);

          break;

        end;

      end;

    end);

    return function()

      onStageDelete:Disconnect();
      stageUpdateEvent:Disconnect();

    end;

  end, {selectedStage});

  return React.createElement(Screen, {
    options = {
      DownloadStage = React.createElement(BottomButton, {
        description = `{if selectedStage then "Download" else "Create new"} stage`;
        keyName = "Enter";
        LayoutOrder = 1;
        onActivate = function() 
        
          ReplicatedStorage.Shared.Functions.SetStage:InvokeServer((selectedStage or {}).ID);
          
          if not selectedStage then

            props.onStageDownloaded();

          end;

        end;
      });
      DeleteStage = if selectedStage then React.createElement(BottomButton, {
        description = "Delete stage";
        keyName = "Del";
        LayoutOrder = 2;
        onActivate = function() 

          ReplicatedStorage.Client.Functions.MarkStageForDeletion:Invoke(selectedStage);

        end;
      }) else nil;
      PublishStage = if selectedStage then React.createElement(BottomButton, {
        description = `{if selectedStage and selectedStage.isPublished then "Unp" else "P"}ublish stage`;
        keyName = "Ins";
        LayoutOrder = 3;
        onActivate = function() 

          ReplicatedStorage.Client.Functions[if selectedStage.isPublished then "MarkStageForUnpublishing" else "MarkStageForPublishing"]:Invoke(selectedStage);

        end;
      }) else nil;
    };
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween;
    });
    StageDescription = React.createElement("Frame", {
      BackgroundTransparency = 1;
      LayoutOrder = 1;
      Size = UDim2.new(1, 0, 1, -150);
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween;
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingBottom = UDim.new(0, 30);
        PaddingLeft = UDim.new(0, 30);
        PaddingRight = UDim.new(0, 30);
      });
      LeftSection = React.createElement("Frame", {
        BackgroundTransparency = 1;
        LayoutOrder = 1;
        Size = UDim2.new(0.3, 0, 1, 0);
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          Padding = UDim.new(0, 10);
          FillDirection = Enum.FillDirection.Vertical;
          VerticalAlignment = Enum.VerticalAlignment.Bottom;
          SortOrder = Enum.SortOrder.LayoutOrder;
        });
        StatusBubbleContainer = React.createElement("Frame", {
          BackgroundTransparency = 1;
          Size = UDim2.new(1, 0, 0, 30);
          LayoutOrder = 2;
        }, {
          UIListLayout = React.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Padding = UDim.new(0, 15);
          });
          Making = React.createElement(StatusBubble, {
            status = if selectedStage then "Complete" else "Default";
            iconImage = icons.build;
            LayoutOrder = 1;
          });
          Saved = React.createElement(StatusBubble, {
            status = if selectedStage then "Complete" else "Default";
            iconImage = icons.save;
            LayoutOrder = 2;
          });
          Published = React.createElement(StatusBubble, {
            status = if selectedStage and selectedStage.isPublished then "Complete" else "Default";
            iconImage = icons.check;
            LayoutOrder = 3;
          });
        });
        StatusLabel = React.createElement("TextLabel", {
          FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
          Text = "STAGE STATUS";
          TextColor3 = Color3.new(1, 1, 1);
          TextTransparency = 0.44;
          BackgroundTransparency = 1;
          Size = UDim2.new(1, 0, 0, 20);
          LayoutOrder = 1;
          TextSize = 14;
          TextXAlignment = Enum.TextXAlignment.Left;
        });
      });
      RightSection = React.createElement("Frame", {
        BackgroundTransparency = 1;
        LayoutOrder = 2;
        Size = UDim2.new(0.7, -15, 1, 0);
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          FillDirection = Enum.FillDirection.Vertical;
          VerticalAlignment = Enum.VerticalAlignment.Bottom;
          SortOrder = Enum.SortOrder.LayoutOrder;
        });
        CreatorNames = React.createElement("TextLabel", {
          BackgroundTransparency = 1;
          LayoutOrder = 1;
          Size = UDim2.new(1, 0, 0, 25);
          FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
          TextTruncate = Enum.TextTruncate.AtEnd;
          TextXAlignment = Enum.TextXAlignment.Right;
          Text = "Coming Soon";
          TextSize = 20;
          TextColor3 = Color3.new(1, 1, 1);
        });
        StageName = React.createElement("TextLabel", {
          BackgroundTransparency = 1;
          LayoutOrder = 2;
          Size = UDim2.new(1, 0, 0, 50);
          FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
          TextTruncate = Enum.TextTruncate.AtEnd;
          TextXAlignment = Enum.TextXAlignment.Right;
          Text = if selectedStage then selectedStage.name else "A BRAND NEW STAGE";
          TextSize = 40;
          TextColor3 = Color3.new(1, 1, 1);
        });
      });
    });
    StageSelector = React.createElement(StageSelector, {
      stages = stages;
      onStageSelect = function(stage)

        setSelectedStage(stage);

      end;
      onStageConfirm = function(stage)

        ReplicatedStorage.Shared.Functions.SetStage:InvokeServer((stage or {}).ID);

        if not stage then

          props.onStageDownloaded();

        end;

      end;
      onDownloadComplete = props.onStageDownloaded;
    });
  });

end

return StagesScreen;