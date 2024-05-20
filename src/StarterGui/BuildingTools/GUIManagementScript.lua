--!strict
local player = game:GetService("Players").LocalPlayer;
local window = script.Parent.Window;

local selectedPart: BasePart?;

local buttonInfoPairs: {{string}} = {
  {"CreateButton", "PartCreator"}, 
  {"ColorButton", "PartColorModifier"}
};

local modificationTools = window.ModificationTools;
local enabledGUI: ScreenGui?;

for _, buttonInfoPair in ipairs(buttonInfoPairs) do
  
  local button = window.CreationTools:FindFirstChild(buttonInfoPair[1]) or modificationTools:FindFirstChild(buttonInfoPair[1]);
  button.MouseButton1Click:Connect(function()
    
    if enabledGUI then
      
      enabledGUI.Enabled = false;
      
    end
    
    enabledGUI = player.PlayerGui:FindFirstChild(buttonInfoPair[2]);
    (enabledGUI :: ScreenGui).Enabled = true;

  end)
  
end


game:GetService("ReplicatedStorage").Events.SelectedPartsChanged.Event:Connect(function(part)
  
  selectedPart = part;
  if selectedPart then
    
    modificationTools.GroupColor3 = Color3.new(1, 1, 1);
    
    
  else
    
    modificationTools.GroupColor3 = Color3.fromRGB(167, 167, 167);
    
  end
  
end)
