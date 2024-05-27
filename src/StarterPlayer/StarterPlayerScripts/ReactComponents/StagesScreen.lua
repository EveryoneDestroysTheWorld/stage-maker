local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TeleportService = game:GetService("TeleportService");
local ContextActionService = game:GetService("ContextActionService");
local React = require(ReplicatedStorage.Shared.Packages.react);
local icons = require(ReplicatedStorage.Client.Icons);
local StatusBubble = require(script.Parent.StatusBubble);
local StageButton = require(script.Parent.StageButton);

type StageScreenProps = {onStageDownloaded: () -> ()};

local function StagesScreen(props: StageScreenProps)
  
  local stages, setStages = React.useState({});
  local stageComponents, setStageComponents = React.useState({});
  local selectedStageIndex, setSelectedStageIndex = React.useState(1);
  React.useEffect(function()
  
    setStages(ReplicatedStorage.Shared.Functions.GetStages:InvokeServer())

    local function updateSelectedStageIndex(actionName, inputState)

      print(inputState);
      if inputState == Enum.UserInputState.Begin then

        setSelectedStageIndex(function(selectedStageIndex) return if actionName == "MoveSelectorLeft" then selectedStageIndex + 1 else selectedStageIndex - 1 end);

      end;

    end;

    local function loadStage(_, inputState)

      if selectedStageIndex then

      end;

    end;

    ContextActionService:BindActionAtPriority("LoadStage", loadStage, false, 2, Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter);
    ContextActionService:BindActionAtPriority("MoveSelectorLeft", updateSelectedStageIndex, false, 2, Enum.KeyCode.Left);
    ContextActionService:BindActionAtPriority("MoveSelectorRight", updateSelectedStageIndex, false, 2, Enum.KeyCode.Right);

    return function()

      ContextActionService:UnbindAction("MoveSelectorLeft");
      ContextActionService:UnbindAction("MoveSelectorRight");

    end;

  end, {});

  React.useEffect(function()
  
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
      }));

    end;

    setStageComponents(stageComponents);

  end, {stages, selectedStageIndex});
  
  return React.createElement("CanvasGroup", {
    Size = UDim2.new(1, 0, 1, 0);
    BackgroundColor3 = Color3.fromRGB(18, 18, 18);
    BackgroundTransparency = 0.2;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    Header = React.createElement("Frame", {
      BackgroundTransparency = 1;
      LayoutOrder = 1;
      Size = UDim2.new(1, 0, 0, 50);
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 15);
        PaddingRight = UDim.new(0, 15);
      });
      LobbyTeleportButton = React.createElement("TextButton", {
        Text = "";
        BackgroundTransparency = 1;
        Size = UDim2.new(0, 180, 0, 30);
        [React.Event.Activated] = function()

          TeleportService:Teleport(15555144468);

        end;
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          FillDirection = Enum.FillDirection.Horizontal;
          Padding = UDim.new(0, 10);
          VerticalAlignment = Enum.VerticalAlignment.Center;
          SortOrder = Enum.SortOrder.LayoutOrder;
        });
        BackIcon = React.createElement("ImageLabel", {
          BackgroundTransparency = 1;
          Size = UDim2.new(0, 25, 0, 25);
          Image = icons.arrowBack;
        });
        TextLabel = React.createElement("TextLabel", {
          BackgroundTransparency = 1;
          TextColor3 = Color3.new(1, 1, 1);
          Text = "BACK TO LOBBY";
          TextSize = 20;
          Size = UDim2.new(1, -35, 0, 30);
          FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
          TextXAlignment = Enum.TextXAlignment.Left;
        })
      })
    });
    Content = React.createElement("Frame", {
      BackgroundTransparency = 1;
      LayoutOrder = 2;
      Size = UDim2.new(1, 0, 1, -50);
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
          StatusBubbles = React.createElement("Frame", {
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
              status = if selectedStageIndex > 1 then "Complete" else "Default";
              iconImage = icons.build;
              LayoutOrder = 1;
            });
            Saved = React.createElement(StatusBubble, {
              status = if selectedStageIndex > 1 then "Complete" else "Default";
              iconImage = icons.save;
              LayoutOrder = 2;
            });
            Published = React.createElement(StatusBubble, {
              status = "Default";
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
            Text = if selectedStageIndex > 1 then stages[selectedStageIndex - 1].name else "A BRAND NEW STAGE";
            TextSize = 40;
            TextColor3 = Color3.new(1, 1, 1);
          });
        });
      });
      StageSelector = React.createElement("ScrollingFrame", {
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
          onConfirm = function()

            props.onStageDownloaded();

          end;
        });
        stageComponents;
      });
    });
  });

end

return StagesScreen;