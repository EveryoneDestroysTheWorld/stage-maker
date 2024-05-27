local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Shared.Packages.react);
local icons = require(ReplicatedStorage.Client.Icons);

type StageButtonProps = {
  stage: any;
  Name: string;
  onSelect: () -> ();
  onConfirm: () -> ();
  LayoutOrder: number;
  isSelected: boolean;
}

local function StageButton(props: StageButtonProps)

  local downloadProgress, setDownloadProgress = React.useState(nil);
  React.useEffect(function()
  
    local downloadProgressEvent = ReplicatedStorage.Shared.Events.StageBuildDataDownloadProgressChanged.OnClientEvent:Connect(function(stageID, partsDownloaded, totalParts)
    
      if stageID == props.stage.ID then

        setDownloadProgress(partsDownloaded / totalParts);

      end;

    end);

    return function()

      downloadProgressEvent:Disconnect();

    end;

  end, {props.stage});

  return React.createElement("Frame", {
    Name = props.Name;
    BackgroundTransparency = 1;
    LayoutOrder = props.LayoutOrder;
    Size = UDim2.new(0, 300, 0, 130);
  }, {
    UIStroke = React.createElement("UIStroke", {
      Color = Color3.new(1, 1, 1);
      LineJoinMode = Enum.LineJoinMode.Miter;
      Thickness = if props.isSelected then 2 else 0;
    });
    Button = React.createElement("TextButton", {
      Text = "";
      BackgroundColor3 = Color3.new(1, 1, 1);
      BackgroundTransparency = 0.7;
      AnchorPoint = Vector2.new(0.5, 0.5);
      Position = UDim2.new(0.5, 0, 0.5, 0);
      Size = UDim2.new(1, -5, 1, -5);
      [React.Event.Activated] = props[if props.isSelected then "onConfirm" else "onSelect"];
    }, {
      UIGradient = React.createElement("UIGradient", {
        Rotation = 90;
        Transparency = NumberSequence.new({
          NumberSequenceKeypoint.new(0, 0), 
          NumberSequenceKeypoint.new(0.5, 0.24375), 
          NumberSequenceKeypoint.new(1, 0.1625)
        });
      });
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        VerticalFlex = Enum.UIFlexAlignment.SpaceBetween;
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingBottom = UDim.new(0, 15);
        PaddingLeft = UDim.new(0, 15);
        PaddingRight = UDim.new(0, 15);
        PaddingTop = UDim.new(0, 15);
      });
      Header = React.createElement("Frame", {
        BackgroundTransparency = 1;
        LayoutOrder = 1;
        Size = UDim2.new(1, 0, 0, 25);
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          HorizontalAlignment = Enum.HorizontalAlignment.Right;
          VerticalAlignment = Enum.VerticalAlignment.Center;
        });
        ImageLabel = React.createElement("ImageLabel", {
          BackgroundTransparency = 1;
          Image = icons.add;
          Size = UDim2.new(0, 25, 0, 25);
        });
      });
      StageNameLabel = React.createElement("TextLabel", {
        BackgroundTransparency = 1;
        Text = props.stage.name;
        Size = UDim2.new(1, 0, 0, 20);
        TextColor3 = Color3.new(1, 1, 1);
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 20;
        TextTruncate = Enum.TextTruncate.AtEnd;
        FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
        LayoutOrder = 2;
      });
    });
    DownloadProgressFrame = if downloadProgress then React.createElement("Frame", {
      Position = UDim2.new(0.5, 0, 1, 8);
      Size = UDim2.new(1, -10, 0, 2);
      AnchorPoint = Vector2.new(0.5, 0.5);
      BackgroundColor3 = Color3.fromRGB(58, 58, 58);
    }, {
      CurrentProgressFrame = React.createElement("Frame", {
        Size = UDim2.new(downloadProgress, 0, 1, 0);
        BackgroundColor3 = Color3.fromRGB(76, 255, 88);
      })
    }) else nil;
  });

end;

return StageButton;