--!strict
local parts: {BasePart} = {};
local currentColor3 = Color3.new();

local hexColorInput = script.Parent.Window.Content.HexColorInput;

local function setCurrentColor3(newColor3: Color3): () 
  
  currentColor3 = newColor3;
  
  for _, part in ipairs(parts) do
    
    part.Color = newColor3;
    
  end
  
  hexColorInput.PlaceholderText = `#{currentColor3:ToHex()}`;
  hexColorInput.Text = "";
  
end

for _, favoriteColorButton in ipairs(script.Parent.Window.Content.FavoriteColors:GetChildren()) do
  
  if not favoriteColorButton:IsA("TextButton") then continue; end;
  
  local function saveColor(): ()
    
    favoriteColorButton.BackgroundColor3 = currentColor3;
    favoriteColorButton.Text = "";
    
  end
  
  favoriteColorButton.MouseButton1Click:Connect(function()
    
    if favoriteColorButton.Text == "+" then
      
      saveColor()
      
    else 
      
      setCurrentColor3(favoriteColorButton.BackgroundColor3);
      
    end;
    
  end)
  favoriteColorButton.MouseButton2Click:Connect(saveColor);
  
end;
  
hexColorInput.FocusLost:Connect(function()
  
  setCurrentColor3(Color3.fromHex(hexColorInput.Text));
  
end)

game:GetService("ReplicatedStorage").Events.SelectedPartsChanged.Event:Connect(function(selectedParts)
  
  parts = selectedParts;
  
end)
