--!strict
-- NoClipScript.lua
-- Written by Christian "Sudobeast" Toney
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContextActionService = game:GetService("ContextActionService");

local ActionHandlerStateChanged = Instance.new("BindableEvent");
local player = game:GetService("Players").LocalPlayer;
local monitoring = false;
local cframeEvent;
ActionHandlerStateChanged.Event:Connect(function(alignOrientation: AlignOrientation)

  -- Prevent extra events by checking if we're already monitoring the player's orientation.
  if monitoring then return; end;
  monitoring = true;

  -- Start monitoring the player's orientation.
  cframeEvent = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()

    local cameraRotationX, cameraRotationY, cameraRotationZ = workspace.CurrentCamera.CFrame:ToEulerAnglesXYZ();
    alignOrientation.CFrame = CFrame.new(player.Character.HumanoidRootPart.CFrame.Position) * CFrame.Angles(cameraRotationX, cameraRotationY, cameraRotationZ);

  end)

end)

local directionVelocity = nil;
local alignOrientation = nil;

local mode: "walking" | "flying" = "walking";
local function checkJump(_, inputState)
  
  if inputState ~= Enum.UserInputState.Begin then return; end;
    
  mode = if mode == "walking" then "flying" else "walking";

  -- Toggle collisions from the server side.
  ReplicatedStorage.Shared.Functions.TogglePlayerCollision:InvokeServer(mode);

  -- Check if the player wants to stand or fly.
  local humanoidRootPart = player.Character.HumanoidRootPart;
  if mode == "flying" then

    -- Disable player controls in favor of scriptable controls.
    (require(player.PlayerScripts.PlayerModule) :: any):GetControls():Disable();

    directionVelocity = Instance.new("LinearVelocity");
    directionVelocity.Name = "Direction";
    directionVelocity.Attachment0 = humanoidRootPart:FindFirstChild("RootAttachment") :: Attachment;
    directionVelocity.MaxForce = math.huge;
    directionVelocity.RelativeTo = Enum.ActuatorRelativeTo.Attachment0;
    directionVelocity.Parent = humanoidRootPart;

    alignOrientation = Instance.new("AlignOrientation");
    alignOrientation.Name = "Angle";
    alignOrientation.Attachment0 = humanoidRootPart:FindFirstChild("RootAttachment") :: Attachment;
    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment;
    alignOrientation.Responsiveness = math.huge;
    alignOrientation.MaxTorque = math.huge;
    alignOrientation.Parent = humanoidRootPart;

    -- Stop all player animation tracks.
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid");
    if humanoid then

      for _, animationTrack in humanoid:GetPlayingAnimationTracks() do

        animationTrack:Stop();

      end

    end

    local currentDirections = {};

    local function handleAction(actionName, inputState: Enum.UserInputState, inputObject: InputObject)

      local direction = ({W = "forward"; A = "left"; S = "backward"; D = "right"})[inputObject.KeyCode.Name];
      if direction then

        ActionHandlerStateChanged:Fire(alignOrientation);

        -- Move the player.
        local forceX = if direction == "left" or direction == "right" then 0 else directionVelocity.VectorVelocity.X;
        local forceZ = if direction == "forward" or direction == "backward" then 0 else directionVelocity.VectorVelocity.Z;
        if inputState == Enum.UserInputState.Begin then

          currentDirections[direction] = true;

          forceX = if currentDirections.left then -100 elseif currentDirections.right then 100 else 0;
          forceZ = if currentDirections.forward then -100 elseif currentDirections.backward then 100 else 0; 

        else

          currentDirections[direction] = nil;

        end

        directionVelocity.VectorVelocity = Vector3.new(forceX, 0, forceZ);

      end;

    end
    ContextActionService:BindAction("FlyingDirection", handleAction, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D);

  else

    -- Stop monitoring the player's orientation.
    if cframeEvent then

      cframeEvent:Disconnect();
      cframeEvent = nil;

    end
    monitoring = false;

    -- Re-enable player controls.
    if alignOrientation then

      alignOrientation:Destroy();

    end

    if directionVelocity then

      directionVelocity:Destroy();

    end
    ContextActionService:UnbindAction("FlyingDirection");
    (require(player.PlayerScripts.PlayerModule) :: any):GetControls():Enable();

  end
  
end

ContextActionService:BindActionAtPriority("ToggleFlying", checkJump, false, 1, Enum.KeyCode.F);