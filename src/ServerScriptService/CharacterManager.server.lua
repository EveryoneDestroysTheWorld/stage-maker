local ReplicatedStorage = game:GetService("ReplicatedStorage");

ReplicatedStorage.Shared.Functions.LoadCharacter.OnServerInvoke = function(player)

  player:LoadCharacter();

end;