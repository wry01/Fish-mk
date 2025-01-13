--Load library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--Create Main Window
local Window = Rayfield:CreateWindow({
   Name = "[🦴] Fisch | Version 0.0.55_fix17",
   LoadingTitle = "[🦴] Fisch",
   LoadingSubtitle = "by Kirymeww",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Fisch",
      FileName = "FischCfg"
   },

   KeySystem = true,
   KeySettings = {
      Title = "[🦴] Fisch",
      Subtitle = "🔑 Key System",
      Note = "Nope.",
      SaveKey = true,
      Key = {"mayke1"}
   }
})

--Services
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--Values
_G.acast = false
_G.ashake = false
_G.areel = false
_G.freezep = false
_G.asell = false
_G.asellinhand = false

_G.areelmode = false
_G.ashakemode = true
_G.ashakespeed = true
_G.acastmode = true
_G.tpmode = true
_G.smerchant = nil

_G.plspeed = 16
_G.pljump = 50

_G.espisonade = false

local themes = {
    {"🌟 Default", "Default"},
    {"✨ Amber Glow", "AmberGlow"},
    {"💜 Amethyst", "Amethyst"},
    {"🌸 Bloom", "Bloom"},
    {"🌌 Dark Blue", "DarkBlue"},
    {"🍃 Green", "Green"},
    {"🌞 Light", "Light"},
    {"🌊 Ocean", "Ocean"},
    {"🌿 Serenity", "Serenity"}
}

--Functions
local function clickAndHoldCenterOfScreen()
    local player = game:GetService("Players").LocalPlayer
    local camera = game:GetService("Workspace").CurrentCamera
    local screenWidth = camera.ViewportSize.X
    local screenHeight = camera.ViewportSize.Y
    local shakeui = player.PlayerGui:FindFirstChild("shakeui")
    local reelui = player.PlayerGui:FindFirstChild("reel")

    local centerX = screenWidth / 2
    local centerY = screenHeight / 2

    local rod = nil

    if player.Character and player.Character:FindFirstChildOfClass("Tool") then
        rod = player.Character:FindFirstChildOfClass("Tool")
    else
        for _, item in ipairs(player.Backpack:GetChildren()) do
            if item.Name:find("Rod") then
                rod = item
                break
            end
        end
    end

    if rod then
        if rod.Parent ~= player.Character then
            rod.Parent = player.Character
        end

        if not shakeui and not reelui then
            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, player, 0)
            task.wait(1.5)
            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, player, 0)
        end
    end
end

local function AutoCastEvent()
   while _G.acast do
      local player = game.Players.LocalPlayer
      local rod = nil

      if player.Character and player.Character:FindFirstChildOfClass("Tool") then
         rod = player.Character:FindFirstChildOfClass("Tool")
      else
         for _, item in ipairs(player.Backpack:GetChildren()) do
            if item.Name:find("Rod") then
               rod = item
               break
            end
         end
      end

      if rod then
         if rod.Parent ~= player.Character then
            rod.Parent = player.Character
         end

      local args = {
         [1] = 100,
         [2] = 1
      }

         if rod:FindFirstChild("events") and rod.events:FindFirstChild("cast") then
            rod.events.cast:FireServer(unpack(args))
         end
      end
      task.wait(0.5)
   end
end

local function AutoCast()
    while _G.acast do
        if _G.acastmode then
            AutoCastEvent()
            task.wait(0.01)
        else
            clickAndHoldCenterOfScreen()
            task.wait(0.01)
        end
    end
end

local function navigateAndClick()
    local player = Players.LocalPlayer
    local button = player.PlayerGui:FindFirstChild("shakeui") and player.PlayerGui.shakeui:FindFirstChild("safezone") and player.PlayerGui.shakeui.safezone:FindFirstChild("button")

    if button then
        GuiService.SelectedObject = button
        if GuiService.SelectedObject == button then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
        end
    end
end

local function clickWithCursor()
    local player = Players.LocalPlayer
    local button = player.PlayerGui:FindFirstChild("shakeui") and player.PlayerGui.shakeui:FindFirstChild("safezone") and player.PlayerGui.shakeui.safezone:FindFirstChild("button")

    if button then
        local bPos = button.AbsolutePosition
        local bSize = button.AbsoluteSize
        local centerX = bPos.X + (bSize.X / 2) + 50
        local centerY = bPos.Y + (bSize.Y / 2) + 50
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, player, 0)
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, player, 0)
    end
end

local function AutoShake()
    while _G.ashake do
        if _G.ashakemode then
            navigateAndClick()
            if _G.ashakespeed then
                task.wait(0.001)
            else
                task.wait(math.random(50, 110) / 100)
            end
        else
            clickWithCursor()
            if _G.ashakespeed then
                task.wait(0.001)
            else
                task.wait(math.random(50, 110) / 100)
            end
        end
    end
end

local function NormalReelGui()
    local player = Players.LocalPlayer
    local playerbar = player.PlayerGui:FindFirstChild("reel") and player.PlayerGui.reel:FindFirstChild("bar") and player.PlayerGui.reel.bar:FindFirstChild("playerbar")

    if playerbar then
        playerbar.Position = UDim2.new(0.5, 0, 0.5, 0)
        playerbar.Size = UDim2.new(1, 0, 1.3, 0)
    end
end

local function AutoReel()
    local args = {}

    while _G.areel do
        if _G.areelmode then
            NormalReelGui()
            args = {}
        else
            args = {
                [1] = 100,
                [2] = true
            }
        end

        if #args > 0 then
            game:GetService("ReplicatedStorage").events.reelfinished:FireServer(unpack(args))
        end
        task.wait(0.2)
    end
end

local function AutoSell()
   while _G.asell do
      if _G.smerchant then
         local merchant = workspace.world.npcs:FindFirstChild(_G.smerchant)
         if merchant then
            merchant.merchant.sellall:InvokeServer()
         end
      end
      task.wait(0.1)
   end
end

local function AutoSellInHand()
   while _G.asellinhand do
      if _G.smerchant then
         local merchant = workspace.world.npcs:FindFirstChild(_G.smerchant)
         if merchant then
            merchant.merchant.sell:InvokeServer()
         end
      end
      task.wait(0.2)
   end
end

local function FreezePlayer()
   local player = game.Players.LocalPlayer
   local initialCFrame = nil
   local humanoid = nil

   while _G.freezep do
      if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         if not initialCFrame then
            initialCFrame = player.Character.HumanoidRootPart.CFrame
            humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
               humanoid.WalkSpeed = 0
               humanoid.JumpPower = 0
            end
         end
         player.Character.HumanoidRootPart.CFrame = initialCFrame
      end
      task.wait(0.01)
   end

   if humanoid then
      humanoid.WalkSpeed = _G.plspeed
      humanoid.JumpPower = _G.pljump
   end
end

local function Espisonade()
   local player = game.Players.LocalPlayer
   local notifiedIsonades = {}
   local isonades = workspace:FindFirstChild("zones")

   while _G.espisonade do
      if isonades and isonades:FindFirstChild("fishing") then
         for _, isonade in pairs(isonades.fishing:GetChildren()) do
            if isonade.Name == "Isonade" and not isonade:FindFirstChild("BillboardGui") then
               local billboardGui = Instance.new("BillboardGui")
               local textLabel = Instance.new("TextLabel")

               billboardGui.Adornee = isonade
               billboardGui.Size = UDim2.new(0, 150, 0, 40)
               billboardGui.StudsOffset = Vector3.new(0, 110, 0)
               billboardGui.AlwaysOnTop = true
               textLabel.Parent = billboardGui
               textLabel.Size = UDim2.new(1, 0, 1, 0)
               textLabel.BackgroundTransparency = 1
               textLabel.TextColor3 = Color3.fromRGB(200, 100, 150)
               textLabel.TextScaled = false
               textLabel.TextSize = 14
               textLabel.Font = Enum.Font.FredokaOne
               textLabel.Text = "Isonade"
               billboardGui.Parent = isonade

               -- Получаем координаты зоны Isonade
               local position = isonade.Position
               local coords = string.format("X: %.2f, Y: %.2f, Z: %.2f", position.X, position.Y, position.Z)

               if not notifiedIsonades[isonade] then
                  Rayfield:Notify({
                     Title = "🚩 Event",
                     Content = "Isonade zone at " .. coords,
                     Duration = 3,
                     Image = "flag",
                  })
                  notifiedIsonades[isonade] = true
               end
            end
         end
      end
      task.wait(1)
   end
end

local function DelEspisonade()
   for _, isonade in pairs(workspace:FindFirstChild("zones").fishing:GetChildren()) do
      if isonade:FindFirstChild("BillboardGui") then
         isonade.BillboardGui:Destroy()
      end
   end
end

local function teleportPlayer(x, y, z)
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local character = player.Character
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        if _G.tpmode then
            humanoidRootPart.CFrame = CFrame.new(x, y, z)
        else
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local goal = {CFrame = CFrame.new(x, y, z)}
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, goal)
            tween:Play()
        end
    end
end

local function chooseRandomTheme()
    math.randomseed(os.time())
    return themes[math.random(1, #themes)]
end

--Tabs
local ma = Window:CreateTab("Fisching", "fish")
local tp = Window:CreateTab("Teleport", "earth")
local treasure = Window:CreateTab("Treasure", "gem")
local misc = Window:CreateTab("Misc", "hammer")
local setting = Window:CreateTab("Settings", "bolt")

--Main
local Section = ma:CreateSection("🎣 Auto Cast")
local acastmode = ma:CreateDropdown({
   Name = "🎣 Select Cast Mode",
   Options = {"⚡ RemoteEvent", "🖱 Mouse"},
   CurrentOption = {"⚡ RemoteEvent"},
   MultipleOptions = false,
   Flag = "acastmode",
   Callback = function(Options)
      if Options[1] == "⚡ RemoteEvent" then
         _G.acastmode = true
      else
         _G.acastmode = false
      end
   end,
})

local acast = ma:CreateToggle({
   Name = "🎣 Auto Cast",
   CurrentValue = false,
   Flag = "acast",
   Callback = function(AcastV)
         _G.acast = AcastV
         AutoCast()
   end,
})

local Section = ma:CreateSection("🔀 Auto Shake")
local ashakespeed = ma:CreateDropdown({
   Name = "⚡ Select Shake Speed",
   Options = {"🟨 Cheat", "🟩 Human"},
   CurrentOption = {"🟨 Cheat"},
   MultipleOptions = false,
   Flag = "ashakespeed",
   Callback = function(Options)
      if Options[1] == "🟨 Cheat" then
         _G.ashakespeed = true
      else
         _G.ashakespeed = false
      end
   end,
})

local ashakemode = ma:CreateDropdown({
   Name = "🔀 Select Shake Mode",
   Options = {"⌨ KeyCode", "🖱 Mouse"},
   CurrentOption = {"⌨ KeyCode"},
   MultipleOptions = false,
   Flag = "ashakemode",
   Callback = function(Options)
      if Options[1] == "⌨ KeyCode" then
         _G.ashakemode = true
      else
         _G.ashakemode = false
      end
   end,
})

local ashake = ma:CreateToggle({
   Name = "🔀 Auto Shake",
   CurrentValue = false,
   Flag = "ashake",
   Callback = function(AshakeV)
         _G.ashake = AshakeV
         AutoShake()
   end,
})

local Section = ma:CreateSection("🔃 Auto Reel")
local areelmode = ma:CreateDropdown({
   Name = "🔃 Select Reel Mode",
   Options = {"🟩 Normal", "🟨 Instant"},
   CurrentOption = {"🟨 Instant"},
   MultipleOptions = false,
   Flag = "areelmode",
   Callback = function(Options)
      if Options[1] == "🟩 Normal" then
         _G.areelmode = true
      else
         _G.areelmode = false
      end
   end,
})

local areel = ma:CreateToggle({
   Name = "🔃 Auto Reel",
   CurrentValue = false,
   Flag = "areel",
   Callback = function(AreelV)
         _G.areel = AreelV
         AutoReel()
   end,
})

local Section = ma:CreateSection("🛒 Merchant")
local smerchant = ma:CreateDropdown({
   Name = "👨‍🦰 Select Merchant",
   Options = {
      "🌲 Marc", "🏖 Matt", "🌞 Max", "❄️ Mike", 
      "⚛ Marytn", "🌊 Maverick", "🌌 Mel", "⛏ Milo"
   },
   CurrentOption = "",  
   MultipleOptions = false,
   Flag = "smerchant",
   Callback = function(Options)
      local selectedMerchant = Options[1]
      if selectedMerchant == "🌲 Marc" then
         _G.smerchant = "Marc Merchant"
      elseif selectedMerchant == "🏖 Matt" then
         _G.smerchant = "Matt Merchant"
      elseif selectedMerchant == "🌞 Max" then
         _G.smerchant = "Max Merchant"
      elseif selectedMerchant == "❄️ Mike" then
         _G.smerchant = "Mike Merchant"
      elseif selectedMerchant == "⚛ Marytn" then
         _G.smerchant = "Marytn Merchant"
      elseif selectedMerchant == "🌊 Maverick" then
         _G.smerchant = "Maverick Merchant"
      elseif selectedMerchant == "🌌 Mel" then
         _G.smerchant = "Mel Merchant"
      elseif selectedMerchant == "⛏ Milo" then
         _G.smerchant = "Milo Merchant"
      end
   end,
})

local asell = ma:CreateToggle({
   Name = "💰 Auto Sell All",
   CurrentValue = false,
   Flag = "asell",
   Callback = function(AsellV)
         _G.asell = AsellV
         AutoSell()
   end,
})

local asellinhand = ma:CreateToggle({
   Name = "💰 Auto Sell In Hand",
   CurrentValue = false,
   Flag = "asellinhand",
   Callback = function(AsellihV)
         _G.asellinhand = AsellihV
         AutoSellInHand()
   end,
})

--Teleport
local Section = tp:CreateSection("🌎 Locations")
local tlocation = tp:CreateDropdown({
   Name = "🗺 Select Location",
   Options = {
      "🌲 Moosewood", "🏖 Roslit Bay", "🌋 Roslit Volcano",
      "🍄 Mushgrove Swamp", "🏝 Terrapin Island", "❄️ Snowcap Island",
      "🌞 Sunstone Island", "🏴‍☠️ Forsaken Shores", "🗿 Statue Of Sovereignty",
      "⛪ Keepers Altar", "🌪 Vertigo", "🌊 Desolate Deep", "🌌 Desolate Pocket", 
      "⛏ The Depths", "🌊 Brine Pool", "🌴 Earmark Isle", "🎸 Haddock Rock",
      "🌉 The Arch", "🌳 Birch Cay", "⚒ Harvesters Spike", "🦴 Uncharted Island"
   },
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "tlocation",
   Callback = function(Options)
         local selectedLocation = Options[1]
         if selectedLocation == "🌲 Moosewood" then
            teleportPlayer(380, 135, 223)
         elseif selectedLocation == "🏖 Roslit Bay" then
            teleportPlayer(-1485, 133, 720)
         elseif selectedLocation == "🌋 Roslit Volcano" then
            teleportPlayer(-1910, 165, 317)
         elseif selectedLocation == "🍄 Mushgrove Swamp" then
            teleportPlayer(2500, 131, -720)
         elseif selectedLocation == "🏝 Terrapin Island" then
            teleportPlayer(-18, 156, 1975)
         elseif selectedLocation == "❄️ Snowcap Island" then
            teleportPlayer(2624, 142, 2471)
         elseif selectedLocation == "🌞 Sunstone Island" then
            teleportPlayer(-933, 132, -1118)
         elseif selectedLocation == "🏴‍☠️ Forsaken Shores" then
            teleportPlayer(-2500, 134, 1540)
         elseif selectedLocation == "🗿 Statue Of Sovereignty" then
            teleportPlayer(50, 132, -1009)
         elseif selectedLocation == "⛪ Keepers Altar" then
            teleportPlayer(1307, -805, -96)
         elseif selectedLocation == "🌪 Vertigo" then
            teleportPlayer(-108, -515, 1065)
         elseif selectedLocation == "🌊 Desolate Deep" then
            teleportPlayer(-1000, -245, -2725)
         elseif selectedLocation == "🌌 Desolate Pocket" then
            teleportPlayer(-1500, -235, -2856)
         elseif selectedLocation == "⛏ The Depths" then
            teleportPlayer(948, -712, 1268)
         elseif selectedLocation == "🌊 Brine Pool" then
            teleportPlayer(-1800, -143, -3404)
         elseif selectedLocation == "🌴 Earmark Isle" then
            teleportPlayer(1230, 125, 575)
         elseif selectedLocation == "🎸 Haddock Rock" then
            teleportPlayer(-570, 182, -413)
         elseif selectedLocation == "🌉 The Arch" then
            teleportPlayer(1000, 125, -1250)
         elseif selectedLocation == "🌳 Birch Cay" then
            teleportPlayer(1700, 125, -2500)
         elseif selectedLocation == "⚒ Harvesters Spike" then
            teleportPlayer(-1257, 139, 1550)
         elseif selectedLocation == "🦴 Uncharted Island" then
            teleportPlayer(4033, 132, 77)
         end
   end,
})

local Section = tp:CreateSection("🛠 Items")
local ttotem = tp:CreateDropdown({
   Name = "🗿 Select Totem",
   Options = {
      "🕰️ Sundial", 
      "🌌 Aurora", 
      "🌬️ Windset", 
      "💨 Smokescreen", 
      "🌪️ Tempest"
   },
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "ttotem",
   Callback = function(Options)
         local selectedTotem = Options[1]

         if selectedTotem == "🕰️ Sundial" then
            teleportPlayer(-1148, 135, -1075)
         elseif selectedTotem == "🌌 Aurora" then
            teleportPlayer(-1811, -137, -3282)
         elseif selectedTotem == "🌬️ Windset" then
            teleportPlayer(2849, 179, 2702)
         elseif selectedTotem == "💨 Smokescreen" then
            teleportPlayer(2789, 140, -625)
         elseif selectedTotem == "🌪️ Tempest" then
            teleportPlayer(35, 132.5, 1943)
         end
   end,
})

local tfishingRods = tp:CreateDropdown({
   Name = "🎣 Select Fishing Rod",
   Options = {
      "🍣 Basic Rods",
      "🎯 Long Rod",
      "⚡ Rapid & ⏳ Steady Rods",
      "🍀 Fortune Rod",
      "🧲 Magnet Rod", 
      "🔱 Trident Rod",
      "🌌 Aurora Rod", 
      "🌙 Nocturnal Rod",
      "🔍 Kings Rod",
      "🛠️ Reinforced Rod",
      "🏴‍☠️ Scurvy Rod",
      "🏮 Rod Of The Depths",
      "🦴 Relic Rod"
   },
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "tfishingRods",
   Callback = function(Options)
         local selectedRod = Options[1]

         if selectedRod == "🍣 Basic Rods" then
            teleportPlayer(454, 151, 239)
         elseif selectedRod == "🎯 Long Rod" then
            teleportPlayer(486, 175, 151)
         elseif selectedRod == "⚡ Rapid & ⏳ Steady Rods" then
            teleportPlayer(-1510, 142, 761)
         elseif selectedRod == "🍀 Fortune Rod" then
            teleportPlayer(-1523, 142, 770)
         elseif selectedRod == "🧲 Magnet Rod" then
            teleportPlayer(-200, 133, 1930)
         elseif selectedRod == "🔱 Trident Rod" then
            teleportPlayer(-1484, -226, -2201)
         elseif selectedRod == "🌌 Aurora Rod" then
            teleportPlayer(-141, -512, 1145)
         elseif selectedRod == "🌙 Nocturnal Rod" then
            teleportPlayer(-141, -512, 1145)
         elseif selectedRod == "🔍 Kings Rod" then
            teleportPlayer(1381, -808, -302)
         elseif selectedRod == "🛠️ Reinforced Rod" then
            teleportPlayer(-989, -243, -2693)
         elseif selectedRod == "🏴‍☠️ Scurvy Rod" then
            te
