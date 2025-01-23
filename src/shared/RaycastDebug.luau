local RaycastDebug = {}

local RunService = game:GetService("RunService")
local IsServer = RunService:IsServer()

local BLOCK_SIZE = Vector3.new(0.25, 0.25, 0.25)
local LIFETIME = 5 -- seconds
local CLIENT_COLOR = ColorSequence.new(Color3.fromRGB(0, 10, 255))
local SERVER_COLOR = ColorSequence.new(Color3.fromRGB(0, 255, 0))

local function createVisualizationPart(): Part
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Size = BLOCK_SIZE
	part.Material = Enum.Material.Neon
	return part
end

local function getDebugFolder(): Folder
	local folderName = "Raycasts " .. (IsServer and "Server" or "Client")
	local folder = workspace:FindFirstChild(folderName)

	if not folder then
		folder = Instance.new("Folder")
		folder.Name = folderName
		folder.Parent = workspace
	end

	return folder
end

function RaycastDebug.visualize(rayOrigin: Vector3, rayDirection: Vector3, hitPosition: Vector3?)
	local folder = getDebugFolder()

	-- Create visualization container
	local container = Instance.new("Model")
	container.Name = "RaycastVisualization"
	container.Parent = folder

	-- Create start point
	local startPart = createVisualizationPart()
	startPart.Name = "Start"
	startPart.Position = rayOrigin
	startPart.Parent = container

	-- Create end point
	local endPart = createVisualizationPart()
	endPart.Name = "End"
	endPart.Position = rayOrigin + rayDirection
	endPart.Parent = container

	-- Create beam
	local attachment0 = Instance.new("Attachment")
	attachment0.Parent = startPart

	local attachment1 = Instance.new("Attachment")
	attachment1.Parent = endPart

	local beam = Instance.new("Beam")
	beam.Name = "RaycastBeam"
	beam.Color = IsServer and SERVER_COLOR or CLIENT_COLOR
	beam.Width0 = 0.1
	beam.Width1 = 0.1
	beam.Attachment0 = attachment0
	beam.Attachment1 = attachment1
	beam.Parent = container

	-- Create hit point if there was a hit
	if hitPosition then
		local hitPart = createVisualizationPart()
		hitPart.Name = "HitPoint"
		hitPart.Position = hitPosition
		hitPart.Parent = container
	end

	-- Cleanup after lifetime
	task.delay(LIFETIME, function()
		container:Destroy()
	end)
end

return RaycastDebug
