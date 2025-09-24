local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new("Prestige Hub", 5013109572)

local themes = {
Background = Color3.fromRGB(24, 24, 24),
Glow = Color3.fromRGB(0, 0, 0),
Accent = Color3.fromRGB(10, 10, 10),
LightContrast = Color3.fromRGB(20, 20, 20),
DarkContrast = Color3.fromRGB(14, 14, 14),  
TextColor = Color3.fromRGB(255, 255, 255)
}

getgenv().customerWalkSpeed = 16
getgenv().customerSpeedEnabled = false
getgenv().autoCollectCoins = false
getgenv().autoSell = false
getgenv().autoItemPickup = false
getgenv().autoOpenContainers = false
getgenv().autoBuyOPContainer = false
getgenv().autoUpgrades = false
getgenv().autoBuyContainers = false
getgenv().selectedContainer = "Junk [100]"
getgenv().upgradeSettings = getgenv().upgradeSettings or {
    inventoryItems = false,
    flowers = false,
    customers = false,
    enchantmentSlots = false,
    containers = false,
    plotItems = false
}
getgenv().pickedUpItems = getgenv().pickedUpItems or {}
getgenv().startingMoney = getgenv().startingMoney or 0

local function safeToNumber(value)
    if type(value) == "number" then
        return value
    elseif type(value) == "string" then
        local numStr = value:gsub(",", ""):upper()
        local multiplier = 1
        
        if numStr:find("K") then
            multiplier = 1000
            numStr = numStr:gsub("K", "")
        elseif numStr:find("M") then
            multiplier = 1000000
            numStr = numStr:gsub("M", "")
        elseif numStr:find("B") then
            multiplier = 1000000000
            numStr = numStr:gsub("B", "")
        elseif numStr:find("T") then
            multiplier = 1000000000000
            numStr = numStr:gsub("T", "")
        end
        
        local number = tonumber(numStr)
        if number then
            return number * multiplier
        end
    end
    return 0
end

spawn(function()
    wait(2)
    pcall(function()
        local player = game.Players.LocalPlayer
        if player and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money") then
            if getgenv().startingMoney == 0 then
                getgenv().startingMoney = safeToNumber(player.leaderstats.Money.Value)
            end
        end
    end)
end)

local function performUpgrades()
    if not getgenv().autoUpgrades then return end
    
    if getgenv().upgradeSettings.inventoryItems then
        pcall(function()
            local args = {
                buffer.fromstring(":"),
                buffer.fromstring("\254\001\000\006\017MaxInventoryItems")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end)
    end
    
    if getgenv().upgradeSettings.flowers then
        pcall(function()
            local args = {
                buffer.fromstring(":"),
                buffer.fromstring("\254\001\000\006\016MaxFlowersPlaced")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end)
    end
    
    if getgenv().upgradeSettings.customers then
        pcall(function()
            local args = {
                buffer.fromstring(":"),
                buffer.fromstring("\254\001\000\006\fMaxCustomers")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end)
    end
    
    if getgenv().upgradeSettings.enchantmentSlots then
        pcall(function()
            local args = {
                buffer.fromstring(":"),
                buffer.fromstring("\254\001\000\006\019MaxEnchantmentSlots")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end)
    end
    
    if getgenv().upgradeSettings.containers then
        pcall(function()
            local args = {
                buffer.fromstring(":"),
                buffer.fromstring("\254\001\000\006\rMaxContainers")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end)
    end
    
    if getgenv().upgradeSettings.plotItems then
        pcall(function()
            local args = {
                buffer.fromstring(":"),
                buffer.fromstring("\254\001\000\006\014MaxItemsOnPlot")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end)
    end
end

local function buyOPContainer()
    if not getgenv().autoBuyOPContainer then return end
    
    pcall(function()
        local args = {
            buffer.fromstring("("),
            buffer.fromstring("\254\000\000")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
    end)
end

local function buySelectedContainer()
    if not getgenv().selectedContainer then return end
    
    local containerName = getgenv().selectedContainer:match("([^%[]+)"):gsub("%s+$", "")
    
    local containerRemotes = {
        ["Junk"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\rJunkContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Scratched"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\018ScratchedContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Sealed"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\015SealedContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Military"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\017MilitaryContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Metal"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\014MetalContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Frozen"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\015FrozenContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Lava"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\rLavaContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Corrupted"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\018CorruptedContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Stormed"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\016StormedContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Lightning"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\018LightningContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Infernal"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\017InfernalContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Mystic"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\015MysticContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Glitched"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\017GlitchedContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Astral"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\015AstralContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Dream"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\014DreamContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Celestial"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\018CelestialContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Fire"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\rFireContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Golden"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\015GoldenContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Diamond"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\016DiamondContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Emerald"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\016EmeraldContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Ruby"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\rRubyContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Sapphire"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\017SapphireContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Space"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\014SpaceContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Deep Space"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\018DeepSpaceContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Vortex"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\015VortexContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Black Hole"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\018BlackHoleContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end,
        ["Camo"] = function()
            local args = {
                buffer.fromstring("4"),
                buffer.fromstring("\254\001\000\006\rCamoContainer")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
        end
    }
    
    local buyFunction = containerRemotes[containerName]
    if buyFunction then
        pcall(buyFunction)
    end
end

local function openSelectedContainerType()
    if not getgenv().selectedContainer then return end
    
    local containerName = getgenv().selectedContainer:match("([^%[]+)"):gsub("%s+$", "")
    
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character.HumanoidRootPart then return end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    
    local containerNameMappings = {
        ["Junk"] = "JunkContainer",
        ["Scratched"] = "ScratchedContainer", 
        ["Sealed"] = "SealedContainer",
        ["Military"] = "MilitaryContainer",
        ["Metal"] = "MetalContainer",
        ["Frozen"] = "FrozenContainer",
        ["Lava"] = "LavaContainer",
        ["Corrupted"] = "CorruptedContainer",
        ["Stormed"] = "StormedContainer",
        ["Lightning"] = "LightningContainer",
        ["Infernal"] = "InfernalContainer",
        ["Mystic"] = "MysticContainer",
        ["Glitched"] = "GlitchedContainer",
        ["Astral"] = "AstralContainer",
        ["Dream"] = "DreamContainer",
        ["Celestial"] = "CelestialContainer",
        ["Fire"] = "FireContainer",
        ["Golden"] = "GoldenContainer",
        ["Diamond"] = "DiamondContainer",
        ["Emerald"] = "EmeraldContainer",
        ["Ruby"] = "RubyContainer",
        ["Sapphire"] = "SapphireContainer",
        ["Space"] = "SpaceContainer",
        ["Deep Space"] = "DeepSpaceContainer",
        ["Vortex"] = "VortexContainer",
        ["Black Hole"] = "BlackHoleContainer",
        ["Camo"] = "CamoContainer"
    }
    
    local targetContainerName = containerNameMappings[containerName] or containerName
    
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("ProximityPrompt") and item.ActionText == "Open Container!" then
            local containerModel = item.Parent
            
            if containerModel and (containerModel.Name:find(targetContainerName) or containerModel.Name:find(containerName)) then
                
                local containerPos = nil
                if containerModel:FindFirstChild("HumanoidRootPart") then
                    containerPos = containerModel.HumanoidRootPart.Position
                elseif containerModel:IsA("BasePart") then
                    containerPos = containerModel.Position
                elseif containerModel:IsA("Model") and containerModel.PrimaryPart then
                    containerPos = containerModel.PrimaryPart.Position
                elseif containerModel:IsA("Model") then
                    containerPos = containerModel:GetPivot().Position
                end
                
                if containerPos then
                    local distance = (containerPos - playerPos).Magnitude
                    
                    if distance <= 150 then
                        if containerModel:FindFirstChild("HumanoidRootPart") then
                            containerModel:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                        elseif containerModel:IsA("BasePart") then
                            containerModel.CFrame = CFrame.new(playerPos + Vector3.new(0, 2, 0))
                        elseif containerModel:IsA("Model") and containerModel.PrimaryPart then
                            containerModel:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                        elseif containerModel:IsA("Model") then
                            containerModel:PivotTo(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                        end
                        
                        wait(0.1)
                        
                        pcall(function() fireproximityprompt(item) end)
                        pcall(function() item.Triggered:Fire() end)
                        pcall(function() item:InputHoldBegin() item:InputHoldEnd() end)
                    end
                end
            end
        end
    end
end

local function openAllContainers()
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character.HumanoidRootPart then return end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("ProximityPrompt") and item.ActionText == "Open Container!" then
            local containerModel = item.Parent
            
            if containerModel then
                local containerPos = nil
                if containerModel:FindFirstChild("HumanoidRootPart") then
                    containerPos = containerModel.HumanoidRootPart.Position
                elseif containerModel:IsA("BasePart") then
                    containerPos = containerModel.Position
                elseif containerModel:IsA("Model") and containerModel.PrimaryPart then
                    containerPos = containerModel.PrimaryPart.Position
                elseif containerModel:IsA("Model") then
                    containerPos = containerModel:GetPivot().Position
                end
                
                if containerPos then
                    local distance = (containerPos - playerPos).Magnitude
                    
                    if distance <= 150 then
                        if containerModel:FindFirstChild("HumanoidRootPart") then
                            containerModel:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                        elseif containerModel:IsA("BasePart") then
                            containerModel.CFrame = CFrame.new(playerPos + Vector3.new(0, 2, 0))
                        elseif containerModel:IsA("Model") and containerModel.PrimaryPart then
                            containerModel:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                        elseif containerModel:IsA("Model") then
                            containerModel:PivotTo(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                        end
                        
                        wait(0.1)
                        
                        pcall(function() fireproximityprompt(item) end)
                        pcall(function() item.Triggered:Fire() end)
                        pcall(function() item:InputHoldBegin() item:InputHoldEnd() end)
                    end
                end
            end
        end
    end
end

local function autoOpenAllContainers()
    if not getgenv().autoOpenContainers then return end
    
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character.HumanoidRootPart then return end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("ProximityPrompt") and item.ActionText == "Open Container!" then
            local containerModel = item.Parent
            
            if containerModel then
                local containerPos = nil
                if containerModel:FindFirstChild("HumanoidRootPart") then
                    containerPos = containerModel.HumanoidRootPart.Position
                elseif containerModel:IsA("BasePart") then
                    containerPos = containerModel.Position
                elseif containerModel:IsA("Model") and containerModel.PrimaryPart then
                    containerPos = containerModel.PrimaryPart.Position
                elseif containerModel:IsA("Model") then
                    containerPos = containerModel:GetPivot().Position
                end
                
                if containerPos then
                    local distance = (containerPos - playerPos).Magnitude
                    
                    if distance <= 100 then
                        if containerModel:FindFirstChild("HumanoidRootPart") then
                            containerModel:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                        elseif containerModel:IsA("BasePart") then
                            containerModel.CFrame = CFrame.new(playerPos + Vector3.new(0, 2, 0))
                        elseif containerModel:IsA("Model") and containerModel.PrimaryPart then
                            containerModel:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                        elseif containerModel:IsA("Model") then
                            containerModel:PivotTo(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                        end
                        
                        wait(0.1)
                        
                        pcall(function() fireproximityprompt(item) end)
                        pcall(function() item.Triggered:Fire() end)
                        pcall(function() item:InputHoldBegin() item:InputHoldEnd() end)
                    end
                end
            end
        end
    end
end

local function collectContainerItems()
    if not getgenv().autoItemPickup then return end
    
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character.HumanoidRootPart then return end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("ProximityPrompt") and item.ActionText == "Pick up!" then
            local itemModel = item.Parent
            if itemModel and itemModel.Name:match("^ITEM_") then
                
                -- FIXED: replaced 'continue' with normal conditional
                if not getgenv().pickedUpItems[itemModel.Name] then
                    
                    local itemPos
                    if itemModel:FindFirstChild("HumanoidRootPart") then
                        itemPos = itemModel.HumanoidRootPart.Position
                    elseif itemModel:IsA("BasePart") then
                        itemPos = itemModel.Position
                    elseif itemModel:IsA("Model") and itemModel.PrimaryPart then
                        itemPos = itemModel.PrimaryPart.Position
                    end
                    
                    if itemPos then
                        local distance = (itemPos - playerPos).Magnitude
                        
                        if distance <= 50 then
                            local inSellZone = false
                            pcall(function()
                                local gameplay = workspace:FindFirstChild("Gameplay")
                                if gameplay then
                                    local plots = gameplay:FindFirstChild("Plots")
                                    if plots then
                                        for _, plot in pairs(plots:GetChildren()) do
                                            local plotLogic = plot:FindFirstChild("PlotLogic")
                                            if plotLogic then
                                                local zones = plotLogic:FindFirstChild("Zones")
                                                if zones then
                                                    local sellableZone = zones:FindFirstChild("SellableZone")
                                                    if sellableZone and sellableZone:IsA("Part") then
                                                        local sellDistance = (itemPos - sellableZone.Position).Magnitude
                                                        if sellDistance <= 20 then
                                                            inSellZone = true
                                                            break
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                            
                            if not inSellZone then
                                if itemModel:FindFirstChild("HumanoidRootPart") then
                                    itemModel:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                                elseif itemModel:IsA("BasePart") then
                                    itemModel.CFrame = CFrame.new(playerPos + Vector3.new(0, 2, 0))
                                elseif itemModel:IsA("Model") and itemModel.PrimaryPart then
                                    itemModel:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                                end
                                
                                task.wait(0.05)
                                
                                pcall(function() fireproximityprompt(item) end)
                                pcall(function() item.Triggered:Fire() end)
                                pcall(function() item:InputHoldBegin() item:InputHoldEnd() end)
                                
                                getgenv().pickedUpItems[itemModel.Name] = true
                            end
                        end
                    end
                end
            end
        end
    end
end

local function collectAllCoins()
    if not getgenv().autoCollectCoins then return end
    
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character.HumanoidRootPart then return end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    
    local coinHolder = workspace:FindFirstChild("Gameplay")
    if coinHolder then
        coinHolder = coinHolder:FindFirstChild("CoinHolder")
        if coinHolder then
            for _, coin in pairs(coinHolder:GetChildren()) do
                if coin.Name:find("MONEY_SPAWN") and coin:IsA("MeshPart") then
                    coin.CFrame = CFrame.new(playerPos + Vector3.new(0, 2, 0))
                    
                    local proximityPrompt = coin:FindFirstChildOfClass("ProximityPrompt")
                    if proximityPrompt then
                        pcall(function() fireproximityprompt(proximityPrompt) end)
                        pcall(function() proximityPrompt.Triggered:Fire(player) end)
                        pcall(function() 
                            proximityPrompt:InputHoldBegin()
                            proximityPrompt:InputHoldEnd()
                        end)
                    end
                end
            end
        end
    end
end

local function hasItemsInInventory()
    local player = game.Players.LocalPlayer
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local itemCount = #backpack:GetChildren()
        if itemCount > 0 then
            return true
        end
    end
    
    return false
end

local function dropAllItems()
    if not getgenv().autoSell then return end
    
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character.HumanoidRootPart then return end
    
    if not hasItemsInInventory() then
        return
    end
    
    local sellZonePosition = nil
    local playerPos = player.Character.HumanoidRootPart.Position
    local closestDistance = math.huge
    
    pcall(function()
        local gameplay = workspace:FindFirstChild("Gameplay")
        if gameplay then
            local plots = gameplay:FindFirstChild("Plots")
            if plots then
                for _, plot in pairs(plots:GetChildren()) do
                    local plotLogic = plot:FindFirstChild("PlotLogic")
                    if plotLogic then
                        local zones = plotLogic:FindFirstChild("Zones")
                        if zones then
                            local sellableZone = zones:FindFirstChild("SellableZone")
                            if sellableZone and sellableZone:IsA("Part") then
                                local distance = (sellableZone.Position - playerPos).Magnitude
                                if distance < closestDistance then
                                    closestDistance = distance
                                    sellZonePosition = sellableZone.Position
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    if sellZonePosition then
        local currentPosition = player.Character.HumanoidRootPart.CFrame
        
        spawn(function()
            local targetPosition = Vector3.new(sellZonePosition.X, currentPosition.Position.Y, sellZonePosition.Z)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
            
            wait(0.15)
            
            local args = {
                buffer.fromstring("\v"),
                buffer.fromstring("\254\000\000")
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
            
            wait(0.1)
            player.Character.HumanoidRootPart.CFrame = currentPosition
        end)
    end
end

local function setAllCustomersSpeed(speed)
    local customersFolder = workspace:FindFirstChild("Gameplay")
    if customersFolder then
        customersFolder = customersFolder:FindFirstChild("Customers")
        if customersFolder then
            for _, customer in pairs(customersFolder:GetChildren()) do
                if customer:IsA("Model") then
                    local humanoid = customer:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = speed
                    end
                end
            end
        end
    end
end

spawn(function()
    local customersFolder = workspace:FindFirstChild("Gameplay")
    if customersFolder then
        customersFolder = customersFolder:FindFirstChild("Customers")
        if customersFolder then
            customersFolder.ChildAdded:Connect(function(newCustomer)
                if newCustomer:IsA("Model") and getgenv().customerSpeedEnabled then
                    wait(0.5)
                    local humanoid = newCustomer:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = getgenv().customerWalkSpeed
                    end
                end
            end)
        end
    end
end)

local automationPage = venyx:addPage("Automation", 5012544693)
local automationSection1 = automationPage:addSection("Auto Features")
local automationSection2 = automationPage:addSection("Settings")

automationSection1:addToggle("Auto Item Pickup", nil, function(value)
    getgenv().autoItemPickup = value
    
    if value then
        spawn(function()
            while getgenv().autoItemPickup do
                collectContainerItems()
                wait(0.1)
            end
        end)
    end
end)

automationSection1:addToggle("Auto Sell", nil, function(value)
    getgenv().autoSell = value
    
    if value then
        spawn(function()
            while getgenv().autoSell do
                dropAllItems()
                wait(5)
            end
        end)
    end
end)

automationSection1:addToggle("Auto Open Containers", nil, function(value)
    getgenv().autoOpenContainers = value
    
    if value then
        spawn(function()
            while getgenv().autoOpenContainers do
                autoOpenAllContainers()
                wait(2)
            end
        end)
    end
end)

automationSection1:addToggle("Auto Collect Coins", nil, function(value)
    getgenv().autoCollectCoins = value
    
    if value then
        spawn(function()
            while getgenv().autoCollectCoins do
                collectAllCoins()
                wait(0.1)
            end
        end)
    end
end)

automationSection1:addToggle("Auto Buy OP Container", nil, function(value)
    getgenv().autoBuyOPContainer = value
    
    if value then
        spawn(function()
            while getgenv().autoBuyOPContainer do
                buyOPContainer()
                wait(900)
            end
        end)
    end
end)

automationSection2:addSlider("Walk Speed", 16, 16, 100, function(value)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

automationSection2:addButton("Unload Hub", function()
    venyx:Notify("Prestige Hub", "Unloading hub...")
    wait(0.5)
    
    pcall(function()
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui.Name:find("Venyx") or gui.Name:find("Prestige") then
                gui:Destroy()
            end
        end
    end)
    
    getgenv().customerWalkSpeed = nil
    getgenv().customerSpeedEnabled = nil
    getgenv().autoCollectCoins = nil
    getgenv().autoSell = nil
    getgenv().autoItemPickup = nil
    getgenv().autoOpenContainers = nil
    getgenv().autoBuyOPContainer = nil
    getgenv().autoUpgrades = nil
    getgenv().upgradeSettings = nil
end)

local cratesPage = venyx:addPage("Crates", 5012544693)
local cratesSection1 = cratesPage:addSection("Container Options")

local containers = {
    "Junk [100]", "Scratched [200]", "Sealed [700]", "Military [3k]", "Metal [10k]", 
    "Frozen [25k]", "Lava [50k]", "Corrupted [100k]", "Stormed [250k]", "Lightning [500k]", 
    "Infernal [750k]", "Mystic [1.5m]", "Glitched [5m]", "Astral [10m]", "Dream [25m]", 
    "Celestial [50m]", "Fire [100m]", "Golden [250m]", "Diamond [500m]", "Emerald [2.5b]", 
    "Ruby [10b]", "Sapphire [75b]", "Space [150b]", "Deep Space [500b]", "Vortex [1t]", 
    "Black Hole [2.5t]", "Camo [5t]"
}

cratesSection1:addDropdown("Choose Container", containers, function(container)
    getgenv().selectedContainer = container
end)

cratesSection1:addButton("Buy Selected Container", function()
    buySelectedContainer()
end)

cratesSection1:addToggle("Auto Buy Containers", nil, function(value)
    getgenv().autoBuyContainers = value
    
    if value then
        spawn(function()
            while getgenv().autoBuyContainers do
                local startTime = tick()
                
                while tick() - startTime < 3 and getgenv().autoBuyContainers do
                    buySelectedContainer()
                    wait(0.1)
                end
                
                if getgenv().autoBuyContainers then
                    wait(5)
                end
            end
        end)
    end
end)

cratesSection1:addButton("Open Selected Container", function()
    openSelectedContainerType()
end)

cratesSection1:addButton("Open All Containers", function()
    openAllContainers()
end)

local itemsPage = venyx:addPage("Items", 5012544693)
local itemsSection1 = itemsPage:addSection("Item Management")

itemsSection1:addButton("Sell All Items", function()
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character.HumanoidRootPart then return end
    
    if not hasItemsInInventory() then return end
    
    local sellZonePosition = nil
    local playerPos = player.Character.HumanoidRootPart.Position
    local closestDistance = math.huge
    
    pcall(function()
        local gameplay = workspace:FindFirstChild("Gameplay")
        if gameplay then
            local plots = gameplay:FindFirstChild("Plots")
            if plots then
                for _, plot in pairs(plots:GetChildren()) do
                    local plotLogic = plot:FindFirstChild("PlotLogic")
                    if plotLogic then
                        local zones = plotLogic:FindFirstChild("Zones")
                        if zones then
                            local sellableZone = zones:FindFirstChild("SellableZone")
                            if sellableZone and sellableZone:IsA("Part") then
                                local distance = (sellableZone.Position - playerPos).Magnitude
                                if distance < closestDistance then
                                    closestDistance = distance
                                    sellZonePosition = sellableZone.Position
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    if sellZonePosition then
        local currentPosition = player.Character.HumanoidRootPart.CFrame
        
        spawn(function()
            local targetPosition = Vector3.new(sellZonePosition.X, currentPosition.Position.Y, sellZonePosition.Z)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
            
            wait(0.15)
            
            local args = {
                buffer.fromstring("\v"),
                buffer.fromstring("\254\000\000")
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
            
            wait(0.1)
            player.Character.HumanoidRootPart.CFrame = currentPosition
        end)
    end
end)

itemsSection1:addButton("Collect All Items", function()
    getgenv().pickedUpItems = getgenv().pickedUpItems or {}

    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local playerPos = player.Character.HumanoidRootPart.Position

    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("ProximityPrompt") and item.ActionText == "Pick up!" then
            local itemModel = item.Parent
            if itemModel and itemModel.Name:match("^ITEM_") then

                if not getgenv().pickedUpItems[itemModel.Name] then

                    local itemPos
                    if itemModel:FindFirstChild("HumanoidRootPart") then
                        itemPos = itemModel.HumanoidRootPart.Position
                    elseif itemModel:IsA("BasePart") then
                        itemPos = itemModel.Position
                    elseif itemModel:IsA("Model") and itemModel.PrimaryPart then
                        itemPos = itemModel.PrimaryPart.Position
                    end

                    if itemPos then
                        local distance = (itemPos - playerPos).Magnitude

                        if distance <= 50 then

                            local inSellZone = false
                            pcall(function()
                                local gameplay = workspace:FindFirstChild("Gameplay")
                                if gameplay then
                                    local plots = gameplay:FindFirstChild("Plots")
                                    if plots then
                                        for _, plot in pairs(plots:GetChildren()) do
                                            local plotLogic = plot:FindFirstChild("PlotLogic")
                                            if plotLogic then
                                                local zones = plotLogic:FindFirstChild("Zones")
                                                if zones then
                                                    local sellableZone = zones:FindFirstChild("SellableZone")
                                                    if sellableZone and sellableZone:IsA("Part") then
                                                        local sellDistance = (itemPos - sellableZone.Position).Magnitude
                                                        if sellDistance <= 20 then
                                                            inSellZone = true
                                                            break
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end)

                            if not inSellZone then
                                if itemModel:FindFirstChild("HumanoidRootPart") then
                                    pcall(function()
                                        itemModel:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                                    end)
                                elseif itemModel:IsA("BasePart") then
                                    pcall(function()
                                        itemModel.CFrame = CFrame.new(playerPos + Vector3.new(0, 2, 0))
                                    end)
                                elseif itemModel:IsA("Model") and itemModel.PrimaryPart then
                                    pcall(function()
                                        itemModel:SetPrimaryPartCFrame(CFrame.new(playerPos + Vector3.new(0, 2, 0)))
                                    end)
                                end

                                task.wait(0.05)

                                pcall(function() fireproximityprompt(item) end)
                                pcall(function() item.Triggered:Fire() end)
                                pcall(function() item:InputHoldBegin() item:InputHoldEnd() end)

                                getgenv().pickedUpItems[itemModel.Name] = true
                            end
                        end
                    end
                end
            end
        end
    end
end)

local upgradesPage = venyx:addPage("Upgrades", 5012544693)
local upgradesSection1 = upgradesPage:addSection("Auto Upgrade Settings")
local upgradesSection2 = upgradesPage:addSection("Manual Upgrades")

upgradesSection1:addToggle("Auto Upgrade: Inventory Items", nil, function(value)
    getgenv().upgradeSettings.inventoryItems = value
    
    if value then
        spawn(function()
            while getgenv().upgradeSettings.inventoryItems do
                pcall(function()
                    local args = {
                        buffer.fromstring(":"),
                        buffer.fromstring("\254\001\000\006\017MaxInventoryItems")
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
                end)
                wait(10)
            end
        end)
    end
end)

upgradesSection1:addToggle("Auto Upgrade: Flowers", nil, function(value)
    getgenv().upgradeSettings.flowers = value
    
    if value then
        spawn(function()
            while getgenv().upgradeSettings.flowers do
                pcall(function()
                    local args = {
                        buffer.fromstring(":"),
                        buffer.fromstring("\254\001\000\006\016MaxFlowersPlaced")
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
                end)
                wait(10)
            end
        end)
    end
end)

upgradesSection1:addToggle("Auto Upgrade: Customers", nil, function(value)
    getgenv().upgradeSettings.customers = value
    
    if value then
        spawn(function()
            while getgenv().upgradeSettings.customers do
                pcall(function()
                    local args = {
                        buffer.fromstring(":"),
                        buffer.fromstring("\254\001\000\006\fMaxCustomers")
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
                end)
                wait(10)
            end
        end)
    end
end)

upgradesSection1:addToggle("Auto Upgrade: Enchantment Slots", nil, function(value)
    getgenv().upgradeSettings.enchantmentSlots = value
    
    if value then
        spawn(function()
            while getgenv().upgradeSettings.enchantmentSlots do
                pcall(function()
                    local args = {
                        buffer.fromstring(":"),
                        buffer.fromstring("\254\001\000\006\019MaxEnchantmentSlots")
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
                end)
                wait(10)
            end
        end)
    end
end)

upgradesSection1:addToggle("Auto Upgrade: Containers", nil, function(value)
    getgenv().upgradeSettings.containers = value
    
    if value then
        spawn(function()
            while getgenv().upgradeSettings.containers do
                pcall(function()
                    local args = {
                        buffer.fromstring(":"),
                        buffer.fromstring("\254\001\000\006\rMaxContainers")
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
                end)
                wait(10)
            end
        end)
    end
end)

upgradesSection1:addToggle("Auto Upgrade: Plot Items", nil, function(value)
    getgenv().upgradeSettings.plotItems = value
    
    if value then
        spawn(function()
            while getgenv().upgradeSettings.plotItems do
                pcall(function()
                    local args = {
                        buffer.fromstring(":"),
                        buffer.fromstring("\254\001\000\006\014MaxItemsOnPlot")
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
                end)
                wait(10)
            end
        end)
    end
end)

upgradesSection2:addButton("Upgrade Inventory Items", function()
    pcall(function()
        local args = {
            buffer.fromstring(":"),
            buffer.fromstring("\254\001\000\006\017MaxInventoryItems")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
    end)
end)

upgradesSection2:addButton("Upgrade Flowers", function()
    pcall(function()
        local args = {
            buffer.fromstring(":"),
            buffer.fromstring("\254\001\000\006\016MaxFlowersPlaced")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
    end)
end)

upgradesSection2:addButton("Upgrade Customers", function()
    pcall(function()
        local args = {
            buffer.fromstring(":"),
            buffer.fromstring("\254\001\000\006\fMaxCustomers")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
    end)
end)

upgradesSection2:addButton("Upgrade Enchantment Slots", function()
    pcall(function()
        local args = {
            buffer.fromstring(":"),
            buffer.fromstring("\254\001\000\006\019MaxEnchantmentSlots")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
    end)
end)

upgradesSection2:addButton("Upgrade Containers", function()
    pcall(function()
        local args = {
            buffer.fromstring(":"),
            buffer.fromstring("\254\001\000\006\rMaxContainers")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
    end)
end)

upgradesSection2:addButton("Upgrade Plot Items", function()
    pcall(function()
        local args = {
            buffer.fromstring(":"),
            buffer.fromstring("\254\001\000\006\014MaxItemsOnPlot")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
    end)
end)

local customersPage = venyx:addPage("Customers", 5012544693)
local customersSection1 = customersPage:addSection("Customer Control")

customersSection1:addToggle("Enable Customer Speed", false, function(value)
    getgenv().customerSpeedEnabled = value
    
    if value then
        setAllCustomersSpeed(getgenv().customerWalkSpeed)
    else
        setAllCustomersSpeed(16)
    end
end)

customersSection1:addSlider("Customer Walk Speed", 1, 1, 10, function(value)
    local actualSpeed = value * 16
    getgenv().customerWalkSpeed = actualSpeed
    
    if getgenv().customerSpeedEnabled then
        setAllCustomersSpeed(actualSpeed)
    end
end)

local statisticsPage = venyx:addPage("Statistics", 5012544693)
local statisticsSection1 = statisticsPage:addSection("Profit Tracker")

statisticsSection1:addButton("Show Profit/Loss", function()
    local currentMoney = 0
    
    pcall(function()
        local player = game.Players.LocalPlayer
        if player and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money") then
            currentMoney = safeToNumber(player.leaderstats.Money.Value)
        end
    end)
    
    local startingMoney = safeToNumber(getgenv().startingMoney)
    local netProfit = currentMoney - startingMoney
    
    local function formatMoney(amount)
        if amount >= 1000000000000 then
            return string.format("%.2fT", amount / 1000000000000)
        elseif amount >= 1000000000 then
            return string.format("%.2fB", amount / 1000000000)
        elseif amount >= 1000000 then
            return string.format("%.2fM", amount / 1000000)
        elseif amount >= 1000 then
            return string.format("%.2fK", amount / 1000)
        else
            return string.format("%.0f", amount)
        end
    end
    
    local profitSymbol = netProfit >= 0 and "+" or "-"
    local notificationTitle = netProfit >= 0 and "Profit Report" or "Loss Report"
    
    local notificationMessage = string.format(
        "Start: $%s | Current: $%s\n%s$%s", 
        formatMoney(startingMoney),
        formatMoney(currentMoney),
        profitSymbol,
        formatMoney(math.abs(netProfit))
    )
    
    venyx:Notify(notificationTitle, notificationMessage)
end)

statisticsSection1:addButton("Reset Profit Tracker", function()
    pcall(function()
        local player = game.Players.LocalPlayer
        if player and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money") then
            getgenv().startingMoney = safeToNumber(player.leaderstats.Money.Value)
            
            local function formatMoney(amount)
                if amount >= 1000000000000 then
                    return string.format("%.2fT", amount / 1000000000000)
                elseif amount >= 1000000000 then
                    return string.format("%.2fB", amount / 1000000000)
                elseif amount >= 1000000 then
                    return string.format("%.2fM", amount / 1000000)
                elseif amount >= 1000 then
                    return string.format("%.2fK", amount / 1000)
                else
                    return string.format("%.0f", amount)
                end
            end
            
            local resetMessage = "New baseline: $" .. formatMoney(getgenv().startingMoney)
            venyx:Notify("Tracker Reset", resetMessage)
        else
            venyx:Notify("Error", "Could not access money data for reset")
        end
    end)
end)

local theme = venyx:addPage("Theme", 5012544693)
local colors = theme:addSection("Colors")

for themeName, color in pairs(themes) do
    colors:addColorPicker(themeName, color, function(color3)
        venyx:setTheme(themeName, color3)
    end)
end

venyx:SelectPage(venyx.pages[1], true)
