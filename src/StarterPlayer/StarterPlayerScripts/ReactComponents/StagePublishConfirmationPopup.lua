local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Popup = require(script.Parent.Popup);
local Button = require(script.Parent.Button);
local ParagraphTextLabel = require(script.Parent.ParagraphTextLabel);

type StagePublishConfirmationPopupProps = {
  stage: any;
  onClose: () -> ();
};

local function StagePublishConfirmationPopup(props: StagePublishConfirmationPopupProps)

  local isPublishingStage, setIsPublishingStage = React.useState(false);

  React.useEffect(function()
  
    if isPublishingStage then

      ReplicatedStorage.Shared.Functions.PublishStage:InvokeServer(props.stage.id);
      props.onClose();

    end;

  end, {isPublishingStage, props.stage});

  return React.createElement(Popup, {
    headingText = `PUBLISH {props.stage.name}?`;
    taglineText = "ON THE FRIDGE IT GOES";
    options = {
      ConfirmButton = React.createElement(Button, {
        text = "Publish stage";
        isDisabled = isPublishingStage;
        onClick = function()

          setIsPublishingStage(true);

        end;
        LayoutOrder = 1;
      });
      CancelButton = React.createElement(Button, {
        text = "Nevermind";
        isDisabled = isPublishingStage;
        onClick = function()

          props.onClose();
          
        end;
        LayoutOrder = 2;
      });
    }
  }, {
    React.createElement(ParagraphTextLabel, {
      text = "In v1.0.0, all stages must pass a community review before publishing; but, for now, you can directly publish your stage because I think you're a cool cat, and cool cats follow the Roblox rules. Cool cats also know if they don't follow the Roblox rules, their knees will get bent the other way.";
    })
  });

end

return StagePublishConfirmationPopup;