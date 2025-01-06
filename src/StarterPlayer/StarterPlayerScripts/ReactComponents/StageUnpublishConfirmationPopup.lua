local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Popup = require(script.Parent.Popup);
local Button = require(script.Parent.Button);
local ParagraphTextLabel = require(script.Parent.ParagraphTextLabel);

type StageUnpublishConfirmationPopupProps = {
  stage: any;
  onClose: () -> ();
};

local function StageUnpublishConfirmationPopup(props: StageUnpublishConfirmationPopupProps)

  local isUnpublishingStage, setIsUnpublishingStage = React.useState(false);

  React.useEffect(function()
  
    if isUnpublishingStage then

      ReplicatedStorage.Shared.Functions.UnpublishStage:InvokeServer(props.stage.id);
      props.onClose();

    end;

  end, {isUnpublishingStage, props.stage});

  return React.createElement(Popup, {
    headingText = `UNPUBLISH {props.stage.name}?`;
    options = {
      ConfirmButton = React.createElement(Button, {
        text = "Take it down";
        isDisabled = isUnpublishingStage;
        onClick = function()

          setIsUnpublishingStage(true);

        end;
        LayoutOrder = 1;
      });
      CancelButton = React.createElement(Button, {
        text = "Nevermind";
        isDisabled = isUnpublishingStage;
        onClick = function()

          props.onClose();
          
        end;
        LayoutOrder = 2;
      });
    }
  }, {
    React.createElement(ParagraphTextLabel, {
      text = "Are you sure you want to unpublish your stage?";
    })
  });

end

return StageUnpublishConfirmationPopup;