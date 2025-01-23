local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local RaycastHandler = require(ReplicatedStorage.GunCast.RaycastHandler)
local RaycastRemote = ReplicatedStorage.GunCast.Remotes.RaycastRemote
local Promise = require(ReplicatedStorage.GunCast.Packages.Promise)

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Constants
local MAX_DISTANCE = 1000000

-- Store hit timestamps for delay calculation
local clientHitTimestamps = {}

-- Function to handle raycast result
local function handleRaycastResult(result, clientTimestamp, rayOrigin, rayDirection)
	return Promise.new(function(resolve)
		if result.hit and result.hitCharacter then
			clientHitTimestamps[result.hitCharacter] = {
				timestamp = clientTimestamp,
				hitType = result.hitType,
			}

			-- Send to server for validation (with distance check)
			local distance = (rayOrigin - result.position).Magnitude
			if distance <= MAX_DISTANCE then
				RaycastRemote:FireServer(rayOrigin, rayDirection, clientTimestamp)
			end
		end
		resolve()
	end)
end

-- Handle mouse click
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end

	local camera = workspace.CurrentCamera
	if not camera then
		return
	end

	local mouseRay = mouse.UnitRay
	local rayOrigin = mouseRay.Origin
	local rayDirection = mouseRay.Direction * 1000

	-- Perform client-side raycast with rate limiting
	local now = tick()

	local clientTimestamp = now

	-- Perform raycast and handle result
	RaycastHandler:Raycast(true, rayOrigin, rayDirection)
		:andThen(function(result)
			return handleRaycastResult(result, clientTimestamp, rayOrigin, rayDirection)
		end)
		:catch(function(err)
			warn("Raycast failed:", err)
		end)
end)

-- Handle server response
RaycastRemote.OnClientEvent:Connect(function(hitCharacter, hitType, serverTimestamp)
	Promise.try(function()
		if hitCharacter then
			local hitData = clientHitTimestamps[hitCharacter]
			if hitData then
				local delay = serverTimestamp - hitData.timestamp
				print(
					string.format(
						"Hit %s %s | Client: %.3f | Server: %.3f | Delay: %.3fms",
						hitType,
						hitCharacter.Name,
						hitData.timestamp,
						serverTimestamp,
						delay * 1000
					)
				)
				clientHitTimestamps[hitCharacter] = nil
			end
		end
	end):catch(warn)
end)
