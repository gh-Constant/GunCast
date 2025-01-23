local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RaycastHandler = require(ReplicatedStorage.GunCast.RaycastHandler)
local RaycastRemote = ReplicatedStorage.GunCast.Remotes.RaycastRemote
local Promise = require(ReplicatedStorage.GunCast.Packages.Promise)

-- Function to set up character in Characters folder
local function setupCharacter(character: Model)
	return Promise.new(function(resolve)
		local charactersFolder = workspace:WaitForChild("Characters")
		character.Parent = charactersFolder
		resolve()
	end)
end

-- Handle player character spawning
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		setupCharacter(character):catch(warn)
	end)
end)

-- Move existing player characters
for _, player in Players:GetPlayers() do
	if player.Character then
		setupCharacter(player.Character):catch(warn)
	end
	player.CharacterAdded:Connect(function(character)
		setupCharacter(character):catch(warn)
	end)
end

RaycastRemote.OnServerEvent:Connect(function(player, rayOrigin, rayDirection)
	-- Perform server-side raycast
	local serverTimestamp = tick()

	RaycastHandler:Raycast(true, rayOrigin, rayDirection)
		:andThen(function(result)
			if result.hit and result.hitCharacter then
				print("Server hit", result.hitType, result.hitCharacter.Name, "at:", serverTimestamp)
				-- Send hit confirmation back to client
				RaycastRemote:FireClient(player, result.hitCharacter, result.hitType, serverTimestamp)
			end
		end)
		:catch(function(err)
			warn("Server raycast failed:", err)
		end)
end)
