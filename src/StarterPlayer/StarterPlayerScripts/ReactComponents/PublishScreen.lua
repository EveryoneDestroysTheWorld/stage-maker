local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local BottomButton = require(script.Parent.BottomButton);
local Screen = require(script.Parent.Screen);
local TextInput = require(script.Parent.TextInput);
local Button = require(script.Parent.Button);

type StageScreenProps = {onBack: () -> ()};

local function PublishScreen(props: StageScreenProps)

  local stageName: string, setStageName = React.useState("");
  local isPublishing, setIsPublishing = React.useState(false);

  React.useEffect(function()
  
    if isPublishing then

      print("Asking the server to publish the stage...");
      
      local isStagePublished, errorMessage = pcall(function()
      
        ReplicatedStorage.Shared.Functions.PublishStage:InvokeServer();

      end);

      if isStagePublished then

        print("The server successfully published the stage.");

      else

        warn(`Couldn't publish stage: {errorMessage}`);

      end;
      props.onBack();

    end;

  end, {isPublishing});

  return React.createElement(Screen, {
    options = {
      PublishStage = React.createElement(BottomButton, {
        description = "Back";
        keyName = "←";
        LayoutOrder = 1;
        onActivate = if isPublishing then nil else function() 

          setIsPublishing(true);

        end;
      });
      Back = React.createElement(BottomButton, {
        description = "OK";
        keyName = "Enter";
        LayoutOrder = 2;
        onActivate = if isPublishing then nil else function() 
        
          props.onBack();

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
      LayoutOrder = 3;
    });
    DescriptionInput = React.createElement(TextInput, {
      labelText = "Description";
      value = "";
      placeholderText = "I hope you did all this stuff this morning.";
      onChange = function() end;
      LayoutOrder = 4;
    });
    NoteLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = "In v1.0.0, all stages must pass a community review before publishing; but, for now, you can directly publish your stage because I think you're a cool cat, and cool cats follow the Roblox rules. Cool cats also know if they don't follow the Roblox rules, their knees will get bent the other way.";
      BackgroundTransparency = 1;
      TextWrapped = true;
      TextColor3 = Color3.new(1, 1, 1);
      FontFace = Font.fromId(11702779517);
      Size = UDim2.new();
      LineHeight = 1.25;
      TextXAlignment = Enum.TextXAlignment.Left;
      TextSize = 14;
      LayoutOrder = 2;
    });
    PublishStageButton = React.createElement(Button, {
      text = "PUBLISH";
      isDisabled = isPublishing;
      LayoutOrder = 5;
      onClick = function() setIsPublishing(true) end;
    });
  });

end

return PublishScreen;