local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local Popup = require(script.Parent.Popup);
local Button = require(script.Parent.Button);
local ParagraphTextLabel = require(script.Parent.ParagraphTextLabel);

type StageDeletionConfirmationPopupProps = {
  stage: any;
  onClose: () -> ();
};

local function StageDeletionConfirmationPopup(props: StageDeletionConfirmationPopupProps)

  local isDeletingStage, setIsDeletingStage = React.useState(false);

  React.useEffect(function()
  
    if isDeletingStage then

      ReplicatedStorage.Shared.Functions.DeleteStage:InvokeServer(props.stage.ID);
      props.onClose();

    end;

  end, {isDeletingStage, props.stage});

  return React.createElement(Popup, {
    headingText = `Delete {props.stage.name}?`;
    options = {
      ConfirmButton = React.createElement(Button, {
        text = "Let it shrivel up and die";
        isDisabled = isDeletingStage;
        onClick = function()

          setIsDeletingStage(true);

        end;
        LayoutOrder = 1;
      });
      CancelButton = React.createElement(Button, {
        text = "Nevermind";
        isDisabled = isDeletingStage;
        onClick = function()

          props.onClose();
          
        end;
        LayoutOrder = 2;
      });
    }
  }, {
    React.createElement(ParagraphTextLabel, {
      text = "Are you sure you want to delete your stage? This will also remove access from all collaborators and unpublish it. No takesies-backsies.";
    })
  });

end

return StageDeletionConfirmationPopup;