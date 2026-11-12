--[[ FUST | Final Fix | ESP Death Fix + TeamCheck + WallCheck + Prediction ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- ОЧИСТКА
pcall(function()
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "FustMenu" or v.Name == "FOVCircle_New" then v:Destroy() end
    end
end)

-- НАСТРОЙКИ
local Config = {
    ESP_Enabled = true,
    Aim_Enabled = true,
    NoDeco_Enabled = true,
    TeamCheck = true,  -- Игнорировать тиммейтов
    WallCheck = true,  -- Не наводиться сквозь стены
    MaxDist = 600,
    FOV_Size = 20,
    SMOOTHNESS = 0.5, -- Быстрое наведение
    PREDICTION = 0.15, -- Предугадывание (0.15 сек)
    Color = Color3.fromRGB(150, 80, 255)
}

-- ==========================================
-- 1. FULLBRIGHT (Мягкий)
-- ==========================================
pcall(function()
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "Fust_CC"
    cc.Brightness = 0.15
    cc.Parent = Lighting
end)

-- ==========================================
-- 2. NO DECO
-- ==========================================
local function HidePart(part)
    if part:IsA("BasePart") then
        part.Transparency = 1
        part.CanCollide = false
    end
end
local function CheckAndHide(part)
    if not part:IsA("BasePart") then return end
    local mat = part.Material
    local maxSize = math.max(part.Size.X, part.Size.Y, part.Size.Z)
    if (mat == Enum.Material.Grass or mat == Enum.Material.LeafyGrass) and maxSize <= 15 then HidePart(part) end
end
for _, obj in ipairs(Workspace:GetDescendants()) do CheckAndHide(obj) end
Workspace.DescendantAdded:Connect(function(obj) CheckAndHide(obj) end)

-- ==========================================
-- 3. КРУГ FOV
-- ==========================================
local FOV_GUI = Instance.new("ScreenGui")
FOV_GUI.Name = "FOVCircle_New"
FOV_GUI.ResetOnSpawn = false
FOV_GUI.IgnoreGuiInset = true
FOV_GUI.Parent = CoreGui

local FOV_Frame = Instance.new("Frame")
FOV_Frame.Size = UDim2.new(0, Config.FOV_Size * 2, 0, Config.FOV_Size * 2)
FOV_Frame.Position = UDim2.new(0.5, -Config.FOV_Size, 0.5, -Config.FOV_Size)
FOV_Frame.BackgroundTransparency = 1
FOV_Frame.Parent = FOV_GUI

local FOV_Stroke = Instance.new("UIStroke")
FOV_Stroke.Color = Config.Color
FOV_Stroke.Thickness = 1
FOV_Stroke.Parent = FOV_Frame
local FOV_Corner = Instance.new("UICorner")
FOV_Corner.CornerRadius = UDim.new(0.5, 0)
FOV_Corner.Parent = FOV_Frame

-- ==========================================
-- 4. ESP + КЭШ
-- ==========================================
local ESP = {}
local Cache = {}

local function CreateESP(pl)
    if pl == LP or ESP[pl] then return end
    local e = {}
    e.b1 = Drawing.new("Line"); e.b2 = Drawing.new("Line")
    e.b3 = Drawing.new("Line"); e.b4 = Drawing.new("Line")
    e.b1.Thickness = 1; e.b2.Thickness = 1; e.b3.Thickness = 1; e.b4.Thickness = 1
    e.b1.Color = Config.Color; e.b2.Color = Config.Color; e.b3.Color = Config.Color; e.b4.Color = Config.Color
    
    e.dist = Drawing.new("Text")
    e.dist.Size = 12; e.dist.Center = true; e.dist.Outline = true; e.dist.Color = Color3.new(1,1,1)
    e.hpBg = Drawing.new("Line"); e.hpBg.Thickness = 2; e.hpBg.Color = Color3.new(0,0,0)
    e.hpFill = Drawing.new("Line"); e.hpFill.Thickness = 2
    ESP[pl] = e
end

local function RemoveAll(pl)
    if ESP[pl] then
        local e = ESP[pl]
        pcall(function()
            e.b1:Remove(); e.b2:Remove(); e.b3:Remove(); e.b4:Remove()
            e.dist:Remove(); e.hpBg:Remove(); e.hpFill:Remove()
        end)
        ESP[pl] = nil
    end
    Cache[pl] = nil
end

local function UpdateCache(pl)
    local char = pl.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum and head and hrp then
            Cache[pl] = { Char = char, Hum = hum, HRP = hrp, Head = head }
        else
            Cache[pl] = nil
        end
    else
        Cache[pl] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do UpdateCache(p); CreateESP(p) end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(0.5); UpdateCache(p) end)
    UpdateCache(p); CreateESP(p)
end)
Players.PlayerRemoving:Connect(RemoveAll)

task.spawn(function()
    while task.wait(1) do
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP then
                local data = Cache[pl]
                if not data or not data.Head.Parent or not data.HRP.Parent then
                    UpdateCache(pl)
                end
            end
        end
    end
end)

-- ==========================================
-- 5. АИМ (Prediction + Team + Wall)
-- ==========================================
local Target = nil
local function GetClosestTarget()
    if not Camera then return nil end
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closest = nil
    local shortestDist = Config.FOV_Size

    for pl, data in pairs(Cache) do
        if pl ~= LP and data.Hum and data.Hum.Health > 0 and data.Head then
            
            -- 1. TEAM CHECK
            local isTeammate = false
            if Config.TeamCheck and pl.Team == LP.Team then isTeammate = true end
            
            if not isTeammate then
                local realDist = (data.Head.Position - Camera.CFrame.Position).Magnitude
                if realDist <= Config.MaxDist then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(data.Head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist < shortestDist then
                            
                            -- 2. WALL CHECK
                            local visible = true
                            if Config.WallCheck then
                                local rayParams = RaycastParams.new()
                                rayParams.FilterDescendantsInstances = {LP.Character, pl.Character}
                                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                local ray = Workspace:Raycast(Camera.CFrame.Position, data.Head.Position - Camera.CFrame.Position, rayParams)
                                if ray then visible = false end
                            end
                            
                            if visible then
                                shortestDist = dist
                                closest = data.Head
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- ==========================================
-- 6. МЕНЮ (Полоска внизу)
-- ==========================================
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "FustMenu"
MenuGui.ResetOnSpawn = false
MenuGui.Parent = CoreGui

local BottomBar = Instance.new("TextButton")
BottomBar.Size = UDim2.new(0, 150, 0, 4)
BottomBar.Position = UDim2.new(0.5, -75, 1, -20)
BottomBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BottomBar.Text = ""
BottomBar.Parent = MenuGui
local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = BottomBar

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 150, 0, 160) -- Чуть выше из-за новых кнопок
MainFrame.Position = UDim2.new(0.5, -75, 1, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Visible = false
MainFrame.Parent = MenuGui
local stroke = Instance.new("UIStroke")
stroke.Color = Config.Color
stroke.Thickness = 1
stroke.Parent = MainFrame
local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 6)
mCorner.Parent = MainFrame

local function CreateToggle(name, key, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.Position = UDim2.new(0, 5, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = name .. ": " .. (Config[key] and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = MainFrame
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        btn.Text = name .. ": " .. (Config[key] and "ON" or "OFF")
        if key == "ESP_Enabled" and not Config.ESP_Enabled then
            for _, e in pairs(ESP) do
                for _, obj in pairs(e) do if obj.Remove then obj.Visible = false end end
            end
        end
    end)
end

CreateToggle("ESP", "ESP_Enabled", 5)
CreateToggle("Aim", "Aim_Enabled", 35)
CreateToggle("TeamCheck", "TeamCheck", 65)
CreateToggle("WallCheck", "WallCheck", 95)
CreateToggle("NoDeco", "NoDeco_Enabled", 125)

BottomBar.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
-- 7. ГЛАВНЫЙ ЦИКЛ
-- ==========================================
local acc = 0
RunService.RenderStepped:Connect(function(dt)
    acc = acc + dt
    if acc < (1 / 30) then return end
    acc = 0

    local cam = Camera
    if not cam then return end
    local camPos = cam.CFrame.Position

    -- Аим с предугадыванием
    if Config.Aim_Enabled then
        Target = GetClosestTarget()
        if Target then
            FOV_Stroke.Color = Color3.fromRGB(0, 255, 0)
            
            -- ПРЕДУГАДЫВАНИЕ: берем скорость цели и умножаем на время
            local targetVelocity = Target.Velocity
            local predictedPos = Target.Position + (targetVelocity * Config.PREDICTION)
            
            local currentCFrame = cam.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, predictedPos)
            cam.CFrame = currentCFrame:Lerp(targetCFrame, Config.SMOOTHNESS)
        else
            FOV_Stroke.Color = Config.Color
        end
    end

    -- ESP
    if Config.ESP_Enabled then
        for pl, e in pairs(ESP) do
            local data = Cache[pl]
            
            -- ФИКС: Если игрок мертв или модель исчезла - скрываем
            if data and data.Hum and data.Hum.Health > 0 and data.Char and data.Char.Parent and data.Head.Parent and data.HRP.Parent then
                local realDist = (data.HRP.Position - camPos).Magnitude
                if realDist <= Config.MaxDist then
                    local headPos, _ = cam:WorldToViewportPoint(data.Head.Position)
                    local rootPos, _ = cam:WorldToViewportPoint(data.HRP.Position)
                    
                    if headPos.Z > 0 then
                        local height = math.abs(headPos.Y - rootPos.Y) * 1.5
                        local width = height / 2
                        local x, y = rootPos.X - width / 2, rootPos.Y - height / 2
                        
                        e.b1.Visible = true; e.b1.From = Vector2.new(x, y); e.b1.To = Vector2.new(x + width, y)
                        e.b2.Visible = true; e.b2.From = Vector2.new(x + width, y); e.b2.To = Vector2.new(x + width, y + height)
                        e.b3.Visible = true; e.b3.From = Vector2.new(x + width, y + height); e.b3.To = Vector2.new(x, y + height)
                        e.b4.Visible = true; e.b4.From = Vector2.new(x, y + height); e.b4.To = Vector2.new(x, y)

                        e.dist.Visible = true
                        e.dist.Text = "[" .. math.floor(realDist) .. "m]"
                        e.dist.Position = Vector2.new(x + width / 2, y + height + 2)

                        local hpPercent = math.clamp(data.Hum.Health / data.Hum.MaxHealth, 0, 1)
                        e.hpBg.Visible = true; e.hpBg.From = Vector2.new(x - 6, y); e.hpBg.To = Vector2.new(x - 6, y + height)
                        e.hpFill.Visible = true; e.hpFill.From = Vector2.new(x - 6, y + height)
                        e.hpFill.To = Vector2.new(x - 6, y + height - (height * hpPercent))
                        e.hpFill.Color = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0)
                    else
                        e.b1.Visible = false; e.b2.Visible = false; e.b3.Visible = false; e.b4.Visible = false
                        e.dist.Visible = false; e.hpBg.Visible = false; e.hpFill.Visible = false
                    end
                else
                    e.b1.Visible = false; e.b2.Visible = false; e.b3.Visible = false; e.b4.Visible = false
                    e.dist.Visible = false; e.hpBg.Visible = false; e.hpFill.Visible = false
                end
            else
                -- Если мертв или нет данных - скрываем
                if e.b1 then
                    e.b1.Visible = false; e.b2.Visible = false; e.b3.Visible = false; e.b4.Visible = false
                    e.dist.Visible = false; e.hpBg.Visible = false; e.hpFill.Visible = false
                end
            end
        end
    end
end)

print("[FUST] Финальный фикс: Трупный ESP убран, добавлены TeamCheck, WallCheck и Prediction.")
