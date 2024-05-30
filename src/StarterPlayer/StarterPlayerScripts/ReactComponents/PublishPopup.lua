local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local BottomButton = require(script.Parent.BottomButton);
local Screen = require(script.Parent.Screen);
local TextInput = require(script.Parent.TextInput);

type StageScreenProps = {};

local function PublishScreen(props: StageScreenProps)

  local stageName: string, setStageName = React.useState("");

  return React.createElement(Screen, {
    options = {
      PublishStage = React.createElement(BottomButton, {
        description = "Back";
        keyName = "←";
        LayoutOrder = 2;
        onActivate = function() 

          -- ReplicatedStorage.Shared.Functions.PublishStage:InvokeServer(selectedStage.ID);

        end;
      });
      Back = React.createElement(BottomButton, {
        description = "OK";
        keyName = "Enter";
        LayoutOrder = 1;
        onActivate = function() 
        
          

        end;
      });
    };
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      Padding = UDim.new(0, 15);
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 30);
      PaddingRight = UDim.new(0, 30);
      PaddingTop = UDim.new(0, 30);
      PaddingBottom = UDim.new(0, 30);
    });
    Heading = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = "PUBLISH STAGE";
      BackgroundTransparency = 1;
      TextColor3 = Color3.new(1, 1, 1);
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
      Size = UDim2.new();
      TextSize = 25;
      LayoutOrder = 1;
      TextXAlignment = Enum.TextXAlignment.Left;
    });
    StageNameInput = React.createElement(TextInput, {
      labelText = "Stage name";
      value = stageName;
      placeholderText = "Firey Fist O' Pain";
      onChange = function(newStageName) setStageName(newStageName) end; 
      LayoutOrder = 2;
    });
    DescriptionInput = React.createElement(TextInput, {
      labelText = "Description";
      value = "";
      placeholderText = "I hope you did all this stuff this morning.";
      onChange = function() end;
      LayoutOrder = 3;
    });
  });

end

return PublishScreen;