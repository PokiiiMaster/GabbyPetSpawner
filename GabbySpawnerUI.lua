-- PetSpawnerGab UI Script (Minimizable + Draggable)

-- Load Spawner Script
local Spawner = loadstring(game:HttpGet("https://codeberg.org/GrowAFilipino/GrowAGarden/raw/branch/main/Spawner.lua"))()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpawnerUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Title Bar
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Name = "TitleBar"
TitleBar.Active = true
TitleBar.Draggable = true

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -35, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Grow A Garden - Spawner"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0, 30, 1, 0)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.BorderSizePixel = 0

local ContentFrame = Instance.new("Frame", Frame)
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, 0, 1, -35)
ContentFrame.Position = UDim2.new(0, 0, 0, 35)
ContentFrame.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", ContentFrame)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Dropdown creator
local function createDropdown(labelText, items, onSelect)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 25)
	label.Text = labelText
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.LayoutOrder = 1

	local dropdown = Instance.new("TextButton")
	dropdown.Size = UDim2.new(1, -20, 0, 30)
	dropdown.Text = "Select " .. labelText
	dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	dropdown.TextColor3 = Color3.new(1, 1, 1)
	dropdown.Font = Enum.Font.Gotham
	dropdown.TextSize = 14
	dropdown.LayoutOrder = 2

	local selectedItem = nil
	local dropdownOpen = false

	dropdown.MouseButton1Click:Connect(function()
		dropdownOpen = not dropdownOpen
		if dropdownOpen then
			for _, item in ipairs(items) do
				local itemButton = Instance.new("TextButton", ContentFrame)
				itemButton.Size = UDim2.new(1, -20, 0, 25)
				itemButton.Text = item
				itemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				itemButton.TextColor3 = Color3.new(1, 1, 1)
				itemButton.Font = Enum.Font.Gotham
				itemButton.TextSize = 14
				itemButton.LayoutOrder = 2

				itemButton.MouseButton1Click:Connect(function()
					selectedItem = item
					dropdown.Text = item
					onSelect(item)
					for _, v in ipairs(ContentFrame:GetChildren()) do
						if v:IsA("TextButton") and v ~= dropdown then v:Destroy() end
					end
					dropdownOpen = false
				end)
			end
		else
			for _, v in ipairs(ContentFrame:GetChildren()) do
				if v:IsA("TextButton") and v ~= dropdown then v:Destroy() end
			end
		end
	end)

	label.Parent = ContentFrame
	dropdown.Parent = ContentFrame
end

-- Button creator
local function createButton(text, callback)
	local button = Instance.new("TextButton", ContentFrame)
	button.Size = UDim2.new(1, -20, 0, 35)
	button.Text = text
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.LayoutOrder = 100
	button.MouseButton1Click:Connect(callback)
end

-- UI Functionality
createDropdown("Pet", Spawner.GetPets(), function(pet)
	createButton("Spawn " .. pet, function()
		Spawner.SpawnPet(pet, 1, 2)
	end)
end)

createDropdown("Seed", Spawner.GetSeeds(), function(seed)
	createButton("Spawn " .. seed, function()
		Spawner.SpawnSeed(seed)
	end)
end)

createButton("Spawn Night Egg", function()
	Spawner.SpawnEgg("Night Egg")
end)

createButton("Spin Sunflower", function()
	Spawner.Spin("Sunflower")
end)

createButton("Load Default UI", function()
	Spawner.Load()
end)

-- Minimize functionality
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	ContentFrame.Visible = not minimized
	if minimized then
		MinimizeBtn.Text = "+"
	else
		MinimizeBtn.Text = "-"
	end
end)
