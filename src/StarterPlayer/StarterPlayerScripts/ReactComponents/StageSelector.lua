local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContextActionService = game:GetService("ContextActionService");
local React = require(ReplicatedStorage.Shared.Packages.react);
local StageButton = require(script.Parent.StageButton);

type StageSelectorProps = {onStageSelect: (stage: any) -> (); onStageConfirm: (stage: any) -> ()};

local function StageSelector(props: StageSelectorProps)

  local stages, setStages = React.useState({});
  local selectedStageIndex, setSelectedStageIndex = React.useState(1);
  local stageComponents, setStageComponents = React.useState({});

  React.useEffect(function()

    local stages = ReplicatedStorage.Shared.Functions.GetStages:InvokeServer();
    
    local function updateSelectedStageIndex(actionName, inputState)

      if inputState == Enum.UserInputState.Begin then

        setSelectedStageIndex(function(selectedStageIndex) 

          if actionName == "MoveSelectorLeft" and selectedStageIndex - 1 >= 1 then 
            
            return selectedStageIndex - 1;
          
          elseif actionName == "MoveSelectorRight" and selectedStageIndex + 1 <= #stages + 1 then 
            
            return selectedStageIndex + 1;

          end;

          return selectedStageIndex;

        end);

      end;

    end;

    ContextActionService:BindAction("MoveSelectorLeft", updateSelectedStageIndex, false, Enum.KeyCode.Left);
    ContextActionService:BindAction("MoveSelectorRight", updateSelectedStageIndex, false, Enum.KeyCode.Right);

    setStages(stages);

    return function()

      ContextActionService:UnbindAction("MoveSelectorLeft");
      ContextActionService:UnbindAction("MoveSelectorRight");

    end;

  end, {});

  React.useEffect(function()
  
    local function loadStage(_, inputState)

      if inputState == Enum.UserInputState.Begin then

        props.onStageConfirm(stages[selectedStageIndex]);

      end;

    end;  
    
    ContextActionService:BindActionAtPriority("LoadStage", loadStage, false, 2, Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter);

    local stageComponents = {};
    for index, stage in ipairs(stages) do

      table.insert(stageComponents, React.createElement(StageButton, {
        Name = stage.name;
        LayoutOrder = index + 1;
        stageName = stage.name;
        isSelected = selectedStageIndex == index + 1;
        onSelect = function()

          setSelectedStageIndex(index + 1); -- Adding +1 because of the stage creation button.

        end;
        onConfirm = function()

          props.onStageConfirm(stage);

        end;
      }));

    end;

    setStageComponents(stageComponents);

    return function()

      ContextActionService:UnbindAction("LoadStage");

    end;

  end, {stages, selectedStageIndex});
  
  return React.createElement("ScrollingFrame", {
    BackgroundTransparency = 1;
    LayoutOrder = 2;
    Size = UDim2.new(1, 0, 0, 150);
    CanvasSize = UDim2.new(1, if #stages > 0 then #stages * 300 + (15 * #stages) else 0, 0, 0);
    ScrollingDirection = Enum.ScrollingDirection.X;
    CanvasPosition = Vector2.new(if selectedStageIndex > 1 then (selectedStageIndex - 1) * 300 + (15 * (selectedStageIndex - 1)) else 0, 0);
    ScrollBarThickness = 0;
  }, {
    React.createElement("UIListLayout", {
      Name = "UIListLayout";
      SortOrder = Enum.SortOrder.LayoutOrder;
      VerticalAlignment = Enum.VerticalAlignment.Center;
      HorizontalAlignment = Enum.HorizontalAlignment.Center;
      FillDirection = Enum.FillDirection.Horizontal;
      Padding = UDim.new(0, 15);
    });
    React.createElement(StageButton, {
      Name = "CreateStageContainer";
      stageName = "CREATE NEW STAGE";
      isSelected = selectedStageIndex == 1;
      LayoutOrder = 1;
      onSelect = function()
        setSelectedStageIndex(1);
      end;
      onConfirm = props.onStageConfirm;
    });
    stageComponents;
  });

end

return StageSelector;