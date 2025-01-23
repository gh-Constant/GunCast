local RaycastHandler = {}

local RaycastDebug = require(script.Parent.RaycastDebug)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage.GunCast.Packages.Promise)
local CHARACTERS_FOLDER_NAME = "Characters"

-- Cache the characters folder reference
local charactersFolder = nil

-- Cache raycast params
local defaultRaycastParams = RaycastParams.new()
defaultRaycastParams.FilterType = Enum.RaycastFilterType.Include

-- Initialize on first use
local function initializeIfNeeded()
	return Promise.new(function(resolve)
		if not charactersFolder then
			charactersFolder = workspace:FindFirstChild(CHARACTERS_FOLDER_NAME)
			if not charactersFolder then
				charactersFolder = Instance.new("Folder")
				charactersFolder.Name = CHARACTERS_FOLDER_NAME
				charactersFolder.Parent = workspace
			end
			defaultRaycastParams.FilterDescendantsInstances = { charactersFolder }
		end
		resolve()
	end)
end

function RaycastHandler:Raycast(
	doShow: boolean,
	rayOrigin: Vector3,
	rayDirection: Vector3,
	raycastParams: RaycastParams?
): typeof(Promise.new(function(resolve)
	resolve({
		hit = false :: boolean,
		hitCharacter = nil :: Model?,
		hitType = nil :: string?,
		hitPart = nil :: BasePart?,
		position = nil :: Vector3?,
	})
end))
	return Promise.new(function(resolve)
		initializeIfNeeded():andThen(function()
			-- Use cached params if none provided
			local params = if raycastParams then raycastParams else defaultRaycastParams

			-- Perform raycast
			local raycastResult = workspace:Raycast(rayOrigin, rayDirection, params)

			-- Handle visualization after raycast to not affect timing
			if doShow then
				Promise.try(function()
					RaycastDebug.visualize(rayOrigin, rayDirection, raycastResult and raycastResult.Position)
				end)
			end

			-- Quick return if no hit
			if not raycastResult then
				resolve({
					hit = false,
					hitCharacter = nil,
					hitType = nil,
					hitPart = nil,
					position = nil,
				})
				return
			end

			-- Process hit result
			local hitPart = raycastResult.Instance
			local hitCharacter = hitPart:FindFirstAncestorWhichIsA("Model")
			local humanoid = hitCharacter and hitCharacter:FindFirstChild("Humanoid")
			local hitType = if humanoid
				then if Players:GetPlayerFromCharacter(hitCharacter) then "Player" else "NPC"
				else nil

			resolve({
				hit = true,
				hitCharacter = hitCharacter,
				hitType = hitType,
				hitPart = hitPart,
				position = raycastResult.Position,
			})
		end)
	end)
end

return RaycastHandler
