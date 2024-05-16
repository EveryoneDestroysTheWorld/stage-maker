--!strict
-- TransparencyPulse.lua
-- Written by Christian "Sudobeast" Toney
-- This script pulses the CanvasGroup of an event, hinting that the event is at risk of deletion. This script should be disabled until a handler (like HistoryHandler) enables it.

local TweenService = game:GetService("TweenService");
local Tween1 = TweenService:Create(script.Parent, TweenInfo.new(.75, Enum.EasingStyle.Sine), {GroupTransparency = 0.6});
local Tween2 = TweenService:Create(script.Parent, TweenInfo.new(1, Enum.EasingStyle.Sine), {GroupTransparency = 0.3});

Tween1.Completed:Connect(function()
  
  Tween2:Play();
  
end)

Tween2.Completed:Connect(function()
  
  Tween1:Play();
  
end)

Tween2:Play();
