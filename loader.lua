--[[ FUST PREMIUM | Universal Free Key ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local Config = {
    ESP_Enabled = true, Aim_Enabled = true, NoDeco_Enabled = true, Fullbright_Enabled = false,
    CustomSky_Enabled = false, TeamCheck = false, WallCheck = true,
    ESP_MaxDist = 1600, AIM_Range = 1500,
    FOV_Size = 100, SMOOTHNESS = 0.95,
    Color = Color3.fromRGB(150, 80, 255),
    SkeletonESP = false, WeaponESP = false, CurrentFOV = 70,
    TargetPart = "Head"
}

-- ==========================================
-- БАЗА КЛЮЧЕЙ
-- ==========================================
local KEY_DATABASE = {
    -- Модер (только для тебя)
    ["moder2563546"] = {role = "moder", user = "fustmycheat"},
    
    -- Премиум (твой клиент)
    ["premium-66645725rip"] = {role = "premium", user = "rip_rimeri5"},
    
    -- Универсальный ключ (без привязки к нику)
    ["free-dlyvseh27636"] = {role = "free", user = "ALL"},
    
    -- СЮДА ДОБАВЛЯЙ НОВЫХ:
    -- ["ключ"] = {role = "free", user = "Ник"},
}

local UserRole = "free"

-- ==========================================
-- KEY SYSTEM UI
-- ==========================================
local KeyGui = Instance.new("ScreenGui"); KeyGui.Name = "KeySystemGui"; KeyGui.ResetOnSpawn = false; KeyGui.Parent = CoreGui
local KeyFrame = Instance.new("Frame"); KeyFrame.Size = UDim2.new(0, 250, 0, 120); KeyFrame.Position = UDim2.new(0.5, -125, 0.5, -60); KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 20); KeyFrame.Parent = KeyGui
local kCorner = Instance.new("UICorner"); kCorner.CornerRadius = UDim.new(0, 8); kCorner.Parent = KeyFrame
local kStroke = Instance.new("UIStroke"); kStroke.Color = Config.Color; kStroke.Thickness = 1.5; kStroke.Parent = KeyFrame
local Title = Instance.new("TextLabel"); Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1; Title.Text = "Введите ключ"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.Parent = KeyFrame
local Input = Instance.new("TextBox"); Input.Size = UDim2.new(1, -20, 0, 30); Input.Position = UDim2.new(0, 10, 0, 40); Input.BackgroundColor3 = Color3.fromRGB(30, 20, 40); Input.TextColor3 = Color3.new(1,1,1); Input.PlaceholderText = "Ключ..."; Input.Font = Enum.Font.Gotham; Input.TextSize = 14; Input.Parent = KeyFrame
local Submit = Instance.new("TextButton"); Submit.Size = UDim2.new(1, -20, 0, 30); Submit.Position = UDim2.new(0, 10, 0, 80); Submit.BackgroundColor3 = Config.Color; Submit.Text = "Активировать"; Submit.TextColor3 = Color3.new(1,1,1); Submit.Font = Enum.Font.GothamBold; Submit.TextSize = 14; Submit.Parent = KeyFrame

-- ==========================================
-- ОСНОВНОЙ ФУНКЦИОНАЛ
-- ==========================================
local function StartCheat()
    -- Watermark
    local WM_Gui = Instance.new("ScreenGui"); WM_Gui.Name = "FustWatermark"; WM_Gui.ResetOnSpawn = false; WM_Gui.Parent = CoreGui
    local WM_Frame = Instance.new("Frame"); WM_Frame.Size = UDim2.new(0, 150, 0, 50); WM_Frame.Position = UDim2.new(1, -160, 1, -60); WM_Frame.BackgroundColor3 = Color3.fromRGB(15, 10, 20); WM_Frame.BackgroundTransparency = 0.7; WM_Frame.Parent = WM_Gui
    local wmCorner = Instance.new("UICorner"); wmCorner.CornerRadius = UDim.new(0, 4); wmCorner.Parent = WM_Frame
    local wmStroke = Instance.new("UIStroke"); wmStroke.Color = Config.Color; wmStroke.Thickness = 1; wmStroke.Transparency = 0.6; wmStroke.Parent = WM_Frame
    
    local TitleLbl = Instance.new("TextLabel"); TitleLbl.Size = UDim2.new(1, 0, 0, 18); TitleLbl.Position = UDim2.new(0, 0, 0, 2); TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "FUST | PREMIUM"; TitleLbl.TextColor3 = Config.Color; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 11; TitleLbl.Parent = WM_Frame
    local FpsLbl = Instance.new("TextLabel"); FpsLbl.Size = UDim2.new(1, 0, 0, 12); FpsLbl.Position = UDim2.new(0, 0, 0, 20); FpsLbl.BackgroundTransparency = 1; FpsLbl.Text = "FPS: 60 | Players: 1"; FpsLbl.TextColor3 = Color3.new(1,1,1); FpsLbl.Font = Enum.Font.Gotham; FpsLbl.TextSize = 10; FpsLbl.Parent = WM_Frame
    local UserLbl = Instance.new("TextLabel"); UserLbl.Size = UDim2.new(1, 0, 0, 12); UserLbl.Position = UDim2.new(0, 0, 0, 34); UserLbl.BackgroundTransparency = 1; UserLbl.Text = "Role: " .. UserRole; UserLbl.TextColor3 = Color3.fromRGB(200, 200, 200); UserLbl.Font = Enum.Font.Gotham; UserLbl.TextSize = 9; UserLbl.Parent = WM_Frame

    local fpsCounter = 0
    local lastTime = tick()
    RunService.RenderStepped:Connect(function()
        fpsCounter = fpsCounter + 1
        if tick() - lastTime >= 1 then
            local fps = math.floor(fpsCounter / (tick() - lastTime))
            local playersCount = #Players:GetPlayers()
            FpsLbl.Text = string.format("FPS: %d | Players: %d", fps, playersCount)
            fpsCounter = 0
            lastTime = tick()
        end
    end)

    -- Fullbright & Sky
    local OldLighting = {Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, ClockTime = Lighting.ClockTime}
    local function SetFullbright(state)
        pcall(function()
            if state then
                Lighting.Ambient = Color3.fromRGB(255, 255, 255); Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            else
                Lighting.Ambient = OldLighting.Ambient; Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient
            end
        end)
    end

    local function SetCustomSky(state)
        pcall(function()
            local oldSky = Lighting:FindFirstChild("FustSky"); if oldSky then oldSky:Destroy() end
            if state then
                local sky = Instance.new("Sky"); sky.Name = "FustSky"
                local tex = "rbxassetid://1146126345"
                sky.SkyboxBk = tex; sky.SkyboxDn = tex; sky.SkyboxFt = tex; sky.SkyboxLf = tex; sky.SkyboxRt = tex; sky.SkyboxUp = tex
                sky.Clouds = ""; sky.CelestialBodiesShown = false; sky.StarCount = 3000; sky.Parent = Lighting
            end
        end)
    end

    -- No Deco
    local function CheckAndHide(part)
        if not part:IsA("BasePart") then return end
        if (part.Material == Enum.Material.Grass or part.Material == Enum.Material.LeafyGrass) and math.max(part.Size.X, part.Size.Y, part.Size.Z) <= 15 then part.Transparency = 1 end
    end
    Workspace.DescendantAdded:Connect(CheckAndHide)
    for _, obj in ipairs(Workspace:GetDescendants()) do CheckAndHide(obj) end

    -- FOV Circle
    local FOV_GUI = Instance.new("ScreenGui"); FOV_GUI.Name = "FOVCircle_New"; FOV_GUI.ResetOnSpawn = false; FOV_GUI.IgnoreGuiInset = true; FOV_GUI.Parent = CoreGui
    local FOV_Frame = Instance.new("Frame"); FOV_Frame.Size = UDim2.new(0, Config.FOV_Size * 2, 0, Config.FOV_Size * 2); FOV_Frame.Position = UDim2.new(0.5, -Config.FOV_Size, 0.5, -Config.FOV_Size); FOV_Frame.BackgroundTransparency = 1; FOV_Frame.Parent = FOV_GUI
    local FOV_Stroke = Instance.new("UIStroke"); FOV_Stroke.Color = Config.Color; FOV_Stroke.Thickness = 1; FOV_Stroke.Parent = FOV_Frame
    local FOV_Corner = Instance.new("UICorner"); FOV_Corner.CornerRadius = UDim.new(0.5, 0); FOV_Corner.Parent = FOV_Frame

    -- ESP & Кэш
    local ESP = {} 
    local function CreateESP(pl)
        if pl == LP or ESP[pl] then return end
        local e = {}
        e.b1 = Drawing.new("Line"); e.b2 = Drawing.new("Line"); e.b3 = Drawing.new("Line"); e.b4 = Drawing.new("Line")
        e.dist = Drawing.new("Text"); e.dist.Size = 12; e.dist.Center = true; e.dist.Outline = true; e.dist.Color = Color3.new(1,1,1)
        e.weapon = Drawing.new("Text"); e.weapon.Size = 11; e.weapon.Center = true; e.weapon.Outline = true; e.weapon.Color = Color3.fromRGB(255, 200, 0); e.weapon.Visible = false
        e.hpBg = Drawing.new("Line"); e.hpBg.Thickness = 2; e.hpBg.Color = Color3.new(0,0,0)
        e.hpFill = Drawing.new("Line"); e.hpFill.Thickness = 2
        e.bones = { Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line") }
        for _, b in ipairs(e.bones) do b.Thickness = 1; b.Color = Color3.fromRGB(255, 100, 100); b.Visible = false end
        e.Cache = {Char = nil, Hum = nil, HRP = nil, Head = nil, Torso = nil, LArm = nil, RArm = nil, LLeg = nil, RLeg = nil}
        ESP[pl] = e
    end

    local function RemoveAll(pl)
        if ESP[pl] then
            local e = ESP[pl]
            pcall(function()
                e.b1:Remove(); e.b2:Remove(); e.b3:Remove(); e.b4:Remove(); e.dist:Remove(); e.hpBg:Remove(); e.hpFill:Remove(); e.weapon:Remove()
                for _, b in ipairs(e.bones) do b:Remove() end
            end)
            ESP[pl] = nil
        end
    end

    local function UpdateCache(pl)
        local char = pl.Character
        if char then
            local e = ESP[pl]
            if e then
                e.Cache = {
                    Char = char,
                    Hum = char:FindFirstChildOfClass("Humanoid"),
                    HRP = char:FindFirstChild("HumanoidRootPart"),
                    Head = char:FindFirstChild("Head"),
                    Torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
                    LArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"),
                    RArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"),
                    LLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"),
                    RLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                }
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do CreateESP(p); UpdateCache(p) end
    Players.PlayerAdded:Connect(function(p) CreateESP(p); p.CharacterAdded:Connect(function() task.wait(0.5); UpdateCache(p) end) end)
    Players.PlayerRemoving:Connect(RemoveAll)

    -- Меню
    local MenuGui = Instance.new("ScreenGui"); MenuGui.Name = "FustMenu"; MenuGui.ResetOnSpawn = false; MenuGui.IgnoreGuiInset = true; MenuGui.Parent = CoreGui
    local BottomBar = Instance.new("TextButton"); BottomBar.Size = UDim2.new(0, 150, 0, 4); BottomBar.Position = UDim2.new(0.5, -75, 1, -20); BottomBar.BackgroundColor3 = Config.Color; BottomBar.Text = ""; BottomBar.Parent = MenuGui
    local barCorner = Instance.new("UICorner"); barCorner.CornerRadius = UDim.new(1, 0); barCorner.Parent = BottomBar

    local MainFrame = Instance.new("Frame"); MainFrame.Size = UDim2.new(0, 380, 0, 260); MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130); MainFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 24); MainFrame.Visible = false; MainFrame.Parent = MenuGui
    local mCorner = Instance.new("UICorner"); mCorner.CornerRadius = UDim.new(0, 8); mCorner.Parent = MainFrame
    local mStroke = Instance.new("UIStroke"); mStroke.Color = Config.Color; mStroke.Thickness = 1.5; mStroke.Parent = MainFrame

    local Sidebar = Instance.new("Frame"); Sidebar.Size = UDim2.new(0, 100, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 8, 18); Sidebar.Parent = MainFrame
    local sCorner = Instance.new("UICorner"); sCorner.CornerRadius = UDim.new(0, 8); sCorner.Parent = Sidebar
    local Logo = Instance.new("TextLabel"); Logo.Size = UDim2.new(1, 0, 0, 30); Logo.Position = UDim2.new(0, 0, 0, 10); Logo.BackgroundTransparency = 1; Logo.Text = "FUST\nPREMIUM"; Logo.TextColor3 = Config.Color; Logo.Font = Enum.Font.GothamBlack; Logo.TextSize = 13; Logo.Parent = Sidebar

    local Content = Instance.new("Frame"); Content.Size = UDim2.new(1, -100, 1, -10); Content.Position = UDim2.new(0, 100, 0, 5); Content.BackgroundTransparency = 1; Content.Parent = MainFrame

    local Tabs = {}
    local function CreateTab(name, icon)
        local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, -10, 0, 25); btn.Position = UDim2.new(0, 5, 0, 50 + (#Tabs * 30)); btn.BackgroundTransparency = 1; btn.Text = " " .. icon .. " " .. name; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Parent = Sidebar
        table.insert(Tabs, {btn = btn, name = name})
        btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(Tabs) do t.btn.TextColor3 = Color3.fromRGB(150, 150, 150) end
            btn.TextColor3 = Config.Color
            for _, v in pairs(Content:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") or v:IsA("Frame") then v:Destroy() end end
            
            if name == "Combat" then
                local function AddToggle(tName, key, pos)
                    local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -10, 0, 30); b.Position = UDim2.new(0, 5, 0, pos); b.BackgroundColor3 = Color3.fromRGB(25, 15, 35); b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.Parent = Content
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
                    b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF") end)
                end
                AddToggle("Aim", "Aim_Enabled", 5)
                AddToggle("TeamCheck", "TeamCheck", 40)
                AddToggle("WallCheck", "WallCheck", 75)
                
                local fovFrame = Instance.new("Frame"); fovFrame.Size = UDim2.new(1, -10, 0, 45); fovFrame.Position = UDim2.new(0, 5, 0, 110); fovFrame.BackgroundColor3 = Color3.fromRGB(25, 15, 35); fovFrame.Parent = Content
                local fovCorner = Instance.new("UICorner"); fovCorner.CornerRadius = UDim.new(0, 4); fovCorner.Parent = fovFrame
                local fovText = Instance.new("TextLabel"); fovText.Size = UDim2.new(1, -20, 0, 15); fovText.Position = UDim2.new(0, 10, 0, 5); fovText.BackgroundTransparency = 1; fovText.Text = "FOV Radius: " .. Config.FOV_Size; fovText.TextColor3 = Color3.new(1,1,1); fovText.Font = Enum.Font.Gotham; fovText.TextSize = 12; fovText.TextXAlignment = Enum.TextXAlignment.Left; fovText.Parent = fovFrame
                local fovBar = Instance.new("Frame"); fovBar.Size = UDim2.new(1, -20, 0, 4); fovBar.Position = UDim2.new(0, 10, 0, 25); fovBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60); fovBar.Parent = fovFrame
                local fovFill = Instance.new("Frame"); fovFill.Size = UDim2.new((Config.FOV_Size - 20) / 130, 0, 1, 0); fovFill.BackgroundColor3 = Config.Color; fovFill.Parent = fovBar
                local fovInput = Instance.new("TextButton"); fovInput.Size = UDim2.new(1, 20, 1, 20); fovInput.Position = UDim2.new(0, -10, 0, -10); fovInput.BackgroundTransparency = 1; fovInput.Text = ""; fovInput.Parent = fovBar
                local fovDragging = false
                fovInput.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then fovDragging = true end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then fovDragging = false end end)
                UserInputService.InputChanged:Connect(function(i)
                    if fovDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        local p = math.clamp((i.Position.X - fovBar.AbsolutePosition.X) / fovBar.AbsoluteSize.X, 0, 1)
                        local v = math.floor(20 + 130 * p)
                        Config.FOV_Size = v
                        fovText.Text = "FOV Radius: " .. v
                        fovFill.Size = UDim2.new(p, 0, 1, 0)
                        FOV_Frame.Size = UDim2.new(0, v * 2, 0, v * 2)
                        FOV_Frame.Position = UDim2.new(0.5, -v, 0.5, -v)
                    end
                end)
                if UserRole == "moder" or UserRole == "premium" then
                    local partBtn = Instance.new("TextButton"); partBtn.Size = UDim2.new(1, -10, 0, 30); partBtn.Position = UDim2.new(0, 5, 0, 165); partBtn.BackgroundColor3 = Config.Color; partBtn.Text = "Target: " .. Config.TargetPart; partBtn.TextColor3 = Color3.new(1,1,1); partBtn.Font = Enum.Font.GothamBold; partBtn.TextSize = 13; partBtn.Parent = Content
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = partBtn
                    partBtn.MouseButton1Click:Connect(function()
                        if Config.TargetPart == "Head" then Config.TargetPart = "Torso"
                        elseif Config.TargetPart == "Torso" then Config.TargetPart = "Legs"
                        else Config.TargetPart = "Head" end
                        partBtn.Text = "Target: " .. Config.TargetPart
                    end)
                end
            elseif name == "Visuals" then
                local function AddToggle(tName, key, pos, callback)
                    local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -10, 0, 30); b.Position = UDim2.new(0, 5, 0, pos); b.BackgroundColor3 = Color3.fromRGB(25, 15, 35); b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.Parent = Content
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
                    b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); if callback then callback(Config[key]) end end)
                end
                AddToggle("ESP", "ESP_Enabled", 5)
                AddToggle("Fullbright", "Fullbright_Enabled", 40, SetFullbright)
                AddToggle("Custom Sky", "CustomSky_Enabled", 75, SetCustomSky)
                AddToggle("NoDeco", "NoDeco_Enabled", 110)
                if UserRole == "moder" or UserRole == "premium" then
                    AddToggle("Skeleton", "SkeletonESP", 145)
                    AddToggle("WeaponESP", "WeaponESP", 180)
                end
            end
        end)
    end
    CreateTab("Combat", "🎯"); CreateTab("Visuals", "👁️")
    if UserRole == "moder" or UserRole == "premium" then CreateTab("Settings", "🛠️") end
    BottomBar.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    -- Главный цикл
    local acc = 0
    RunService.RenderStepped:Connect(function(dt)
        acc = acc + dt; if acc < (1 / 30) then return end; acc = 0
        local cam = Camera; if not cam then return end; local camPos = cam.CFrame.Position
        
        -- Аим
        if Config.Aim_Enabled then
            local targetPart = nil; local shortestDist = Config.FOV_Size
            local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            for pl, e in pairs(ESP) do
                if pl ~= LP and e.Cache.Hum and e.Cache.Hum.Health > 0 and e.Cache.Head then
                    local aimPart = e.Cache.Head
                    if Config.TargetPart == "Torso" then aimPart = e.Cache.Torso or e.Cache.HRP
                    elseif Config.TargetPart == "Legs" then aimPart = e.Cache.LLeg or e.Cache.HRP end
                    if aimPart and not (Config.TeamCheck and pl.Team == LP.Team) then
                        local realDist = (aimPart.Position - camPos).Magnitude
                        if realDist <= Config.AIM_Range then
                            local sp, onScreen = cam:WorldToViewportPoint(aimPart.Position)
                            if onScreen then
                                local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                                if dist < shortestDist then
                                    local visible = true
                                    if Config.WallCheck then
                                        local rayParams = RaycastParams.new(); rayParams.FilterDescendantsInstances = {LP.Character, pl.Character}; rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                        local ray = Workspace:Raycast(cam.CFrame.Position, aimPart.Position - cam.CFrame.Position, rayParams)
                                        if ray and not ray.Instance:IsA("Terrain") then visible = false end
                                    end
                                    if visible then shortestDist = dist; targetPart = aimPart end
                                end
                            end
                        end
                    end
                end
            end
            
            if targetPart then
                FOV_Stroke.Color = Color3.fromRGB(0, 255, 0)
                local smooth = 0.95
                local predict = 0.15
                local targetPos = targetPart.Position + (targetPart.Velocity * predict)
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(camPos, targetPos), smooth)
            else FOV_Stroke.Color = Config.Color end
        end

        -- Отрисовка ESP
        if Config.ESP_Enabled then
            for pl, e in pairs(ESP) do
                local c = e.Cache
                if c.Hum and c.Hum.Health > 0 and c.Head and c.HRP and c.Char and c.Char.Parent then
                    local realDist = (c.HRP.Position - camPos).Magnitude
                    if realDist <= Config.ESP_MaxDist then
                        local headPos, _ = cam:WorldToViewportPoint(c.Head.Position); local rootPos, _ = cam:WorldToViewportPoint(c.HRP.Position)
                        if headPos.Z > 0 then
                            local h = math.abs(headPos.Y - rootPos.Y) * 1.5; local w = h / 2; local x, y = rootPos.X - w / 2, rootPos.Y - h / 2
                            e.b1.Visible = true; e.b1.From = Vector2.new(x, y); e.b1.To = Vector2.new(x + w, y)
                            e.b2.Visible = true; e.b2.From = Vector2.new(x + w, y); e.b2.To = Vector2.new(x + w, y + h)
                            e.b3.Visible = true; e.b3.From = Vector2.new(x + w, y + h); e.b3.To = Vector2.new(x, y + h)
                            e.b4.Visible = true; e.b4.From = Vector2.new(x, y + h); e.b4.To = Vector2.new(x, y)
                            e.dist.Visible = true; e.dist.Text = "[" .. math.floor(realDist) .. "m]"; e.dist.Position = Vector2.new(x + w / 2, y + h + 2)
                            local hpPercent = math.clamp(c.Hum.Health / c.Hum.MaxHealth, 0, 1)
                            e.hpBg.Visible = true; e.hpBg.From = Vector2.new(x - 6, y); e.hpBg.To = Vector2.new(x - 6, y + h)
                            e.hpFill.Visible = true; e.hpFill.From = Vector2.new(x - 6, y + h); e.hpFill.To = Vector2.new(x - 6, y + h - (h * hpPercent)); e.hpFill.Color = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0)
                            
                            if (UserRole == "moder" or UserRole == "premium") and Config.WeaponESP then
                                local toolName = nil
                                local handTool = c.Char:FindFirstChildOfClass("Tool")
                                if handTool then toolName = handTool.Name
                                else
                                    local backpack = pl:FindFirstChild("Backpack")
                                    if backpack then local bpTool = backpack:FindFirstChildOfClass("Tool"); if bpTool then toolName = bpTool.Name .. " (рюкзак)" end end
                                end
                                if toolName then e.weapon.Visible = true; e.weapon.Text = "[" .. toolName .. "]"; e.weapon.Position = Vector2.new(x + w / 2, y - 16) else e.weapon.Visible = false end
                            else e.weapon.Visible = false end
                            
                            if (UserRole == "moder" or UserRole == "premium") and Config.SkeletonESP then
                                local function to2d(p) if not p then return nil end local sp, on = cam:WorldToViewportPoint(p.Position) if on then return Vector2.new(sp.X, sp.Y) end return nil end
                                local h2d, r2d = to2d(c.Head), to2d(c.HRP); local t2d = to2d(c.Torso)
                                local la, ra = to2d(c.LArm), to2d(c.RArm); local ll, rl = to2d(c.LLeg), to2d(c.RLeg)
                                for _, b in ipairs(e.bones) do b.Visible = false end
                                if h2d and r2d then e.bones[1].Visible = true; e.bones[1].From = h2d; e.bones[1].To = r2d end
                                if t2d and r2d then e.bones[2].Visible = true; e.bones[2].From = t2d; e.bones[2].To = r2d end
                                if t2d and la then e.bones[3].Visible = true; e.bones[3].From = t2d; e.bones[3].To = la end
                                if t2d and ra then e.bones[4].Visible = true; e.bones[4].From = t2d; e.bones[4].To = ra end
                                if r2d and ll then e.bones[5].Visible = true; e.bones[5].From = r2d; e.bones[5].To = ll end
                                if r2d and rl then e.bones[6].Visible = true; e.bones[6].From = r2d; e.bones[6].To = rl end
                            else for _, b in ipairs(e.bones) do b.Visible = false end end
                        else
                            for _, obj in ipairs({e.b1, e.b2, e.b3, e.b4, e.dist, e.hpBg, e.hpFill, e.weapon}) do obj.Visible = false end
                            for _, b in ipairs(e.bones) do b.Visible = false end
                        end
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- ЗАПУСК
-- ==========================================
Submit.MouseButton1Click:Connect(function()
    local enteredKey = Input.Text
    local keyData = KEY_DATABASE[enteredKey]
    
    if keyData then
        -- ПРОВЕРКА: Если user == "ALL", пускаем любого
        if keyData.user == "ALL" or keyData.user == LP.Name then
            UserRole = keyData.role
            KeyGui:Destroy()
            StartCheat()
        else
            Input.Text = ""; Input.PlaceholderText = "Ключ привязан к " .. keyData.user
        end
    else
        Input.Text = ""; Input.PlaceholderText = "Неверный ключ!"
    end
end)
