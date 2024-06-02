local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local icons = require(ReplicatedStorage.Client.Icons);
local StatusBubble = require(script.Parent.StatusBubble);
local StageSelector = require(script.Parent.StageSelector);
local BottomButton = require(script.Parent.BottomButton);
local Screen = require(script.Parent.Screen);

type StageScreenProps = {onStageDownloaded: () -> (); navigate: (screenName: string) -> (); currentStage: any; setCurrentStage: (stage: any) -> ();};

local function StagesScreen(props: StageScreenProps)

  return React.createElement(Screen, {
    options = {
      DownloadStage = React.createElement(BottomButton, {
        description = `{if props.currentStage then "Download" else "Create new"} stage`;
        keyName = "Enter";
        LayoutOrder = 1;
        onActivate = function() 
        
          ReplicatedStorage.Shared.Functions.SetStage:InvokeServer((props.currentStage or {}).ID);
          
          if not props.currentStage then

            props.onStageDownloaded();

          end;

        end;
      });
      DeleteStage = if props.currentStage then React.createElement(BottomButton, {
        description = "Delete stage";
        keyName = "Del";
        LayoutOrder = 2;
        onActivate = function() 

          ReplicatedStorage.Client.Functions.MarkStageForDeletion:Invoke(props.currentStage);

        end;
      }) else nil;
      PublishStage = if props.currentStage then React.createElement(BottomButton, {
        description = `{if props.currentStage and props.currentStage.isPublished then "Unp" else "P"}ublish stage`;
        keyName = "Ins";
        LayoutOrder = 3;
        onActivate = function() 

          props.navigate("PublishScreen");

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
            status = if props.currentStage then "Complete" else "Default";
            iconImage = icons.build;
            LayoutOrder = 1;
          });
          Saved = React.createElement(StatusBubble, {
            status = if props.currentStage then "Complete" else "Default";
            iconImage = icons.save;
            LayoutOrder = 2;
          });
          Published = React.createElement(StatusBubble, {
            status = if props.currentStage and props.currentStage.isPublished then "Complete" else "Default";
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
          Text = if props.currentStage then props.currentStage.name else "A BRAND NEW STAGE";
          TextSize = 40;
          TextColor3 = Color3.new(1, 1, 1);
        });
      });
    });
    StageSelector = React.createElement(StageSelector, {
      onStageSelect = function(stage)

        props.setCurrentStage(stage);

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