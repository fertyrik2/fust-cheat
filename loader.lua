--[[ FUST PREMIUM | No-Drawing Stealth Edition (No Hooks) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local rnd = function() return tostring(math.random(1e6, 9e6)) end
local function safeCclosure(fn) if newcclosure then return newcclosure(fn) end return fn end

local function getHiddenUI()
    if gethui then local s, r = pcall(gethui) if s and r then return r end end
    return game:GetService("CoreGui")
end
local GuiParent = getHiddenUI()

local Config = {
    ESP_Enabled = true, Aim_Enabled = true, NoDeco_Enabled = true, Fullbright_Enabled = false,
    CustomSky_Enabled = false, TeamCheck = false, WallCheck = true,
    ESP_MaxDist = 1600, AIM_Range = 1500,
    FOV_Size = 150,
    SMOOTHNESS = 0.20, -- Быстрая наводка
    Color = Color3.fromRGB(150, 80, 255),
    TargetPart = "Head",
    SkeletonESP = false, WeaponESP = false
}

-- ==========================================
-- БАЗА КЛЮЧЕЙ
-- ==========================================
local KEY_DATABASE = {
    -- Привязка к dhsdvdv
    ["moder2563546"] = {role = "moder", user = "dhsdvdv"},
    ["premium-66645725rip"] = {role = "premium", user = "rip_rimeri5"},
    ["free-dlyvseh27636"] = {role = "free", user = "ALL"},
}
local UserRole = "free"

-- ==========================================
-- KEY SYSTEM UI
-- ==========================================
local KeyGui = Instance.new("ScreenGui"); KeyGui.Name = "sg_" .. rnd(); KeyGui.ResetOnSpawn = false; KeyGui.Parent = GuiParent
local KeyFrame = Instance.new("Frame"); KeyFrame.Name = "f_" .. rnd(); KeyFrame.Size = UDim2.new(0, 250, 0, 120); KeyFrame.Position = UDim2.new(0.5, -125, 0.5, -60); KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 20); KeyFrame.Parent = KeyGui
local kCorner = Instance.new("UICorner"); kCorner.CornerRadius = UDim.new(0, 8); kCorner.Parent = KeyFrame
local Title = Instance.new("TextLabel"); Title.Name = "t_" .. rnd(); Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1; Title.Text = "Введите ключ"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.Parent = KeyFrame
local Input = Instance.new("TextBox"); Input.Name = "i_" .. rnd(); Input.Size = UDim2.new(1, -20, 0, 30); Input.Position = UDim2.new(0, 10, 0, 40); Input.BackgroundColor3 = Color3.fromRGB(30, 20, 40); Input.TextColor3 = Color3.new(1,1,1); Input.PlaceholderText = "Ключ..."; Input.Font = Enum.Font.Gotham; Input.TextSize = 14; Input.Parent = KeyFrame
local Submit = Instance.new("TextButton"); Submit.Name = "b_" .. rnd(); Submit.Size = UDim2.new(1, -20, 0, 30); Submit.Position = UDim2.new(0, 10, 0, 80); Submit.BackgroundColor3 = Config.Color; Submit.Text = "Активировать"; Submit.TextColor3 = Color3.new(1,1,1); Submit.Font = Enum.Font.GothamBold; Submit.TextSize = 14; Submit.Parent = KeyFrame

-- ==========================================
-- ОСНОВНОЙ ФУНКЦИОНАЛ
-- ==========================================
local function StartCheat()
    -- Водяной знак
    local WM_Gui = Instance.new("ScreenGui"); WM_Gui.Name = "sg_" .. rnd(); WM_Gui.ResetOnSpawn = false; WM_Gui.Parent = GuiParent
    local WM_Frame = Instance.new("Frame"); WM_Frame.Name = "f_" .. rnd(); WM_Frame.Size = UDim2.new(0, 150, 0, 50); WM_Frame.Position = UDim2.new(1, -160, 1, -60); WM_Frame.BackgroundColor3 = Color3.fromRGB(15, 10, 20); WM_Frame.BackgroundTransparency = 0.7; WM_Frame.Parent = WM_Gui
    local wmCorner = Instance.new("UICorner"); wmCorner.CornerRadius = UDim.new(0, 4); wmCorner.Parent = WM_Frame
    
    local TitleLbl = Instance.new("TextLabel"); TitleLbl.Name = "t_" .. rnd(); TitleLbl.Size = UDim2.new(1, 0, 0, 18); TitleLbl.Position = UDim2.new(0, 0, 0, 2); TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "FUST | PREMIUM"; TitleLbl.TextColor3 = Config.Color; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 11; TitleLbl.Parent = WM_Frame
    local FpsLbl = Instance.new("TextLabel"); FpsLbl.Name = "t_" .. rnd(); FpsLbl.Size = UDim2.new(1, 0, 0, 12); FpsLbl.Position = UDim2.new(0, 0, 0, 20); FpsLbl.BackgroundTransparency = 1; FpsLbl.Text = "FPS: 60 | Players: 1"; FpsLbl.TextColor3 = Color3.new(1,1,1); FpsLbl.Font = Enum.Font.Gotham; FpsLbl.TextSize = 10; FpsLbl.Parent = WM_Frame
    local UserLbl = Instance.new("TextLabel"); UserLbl.Name = "t_" .. rnd(); UserLbl.Size = UDim2.new(1, 0, 0, 12); UserLbl.Position = UDim2.new(0, 0, 0, 34); UserLbl.BackgroundTransparency = 1; UserLbl.Text = "Role: " .. UserRole; UserLbl.TextColor3 = Color3.fromRGB(200, 200, 200); UserLbl.Font = Enum.Font.Gotham; UserLbl.TextSize = 9; UserLbl.Parent = WM_Frame

    -- Fullbright & Sky
    local OldLighting = {Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient}
    local function SetFullbright(state)
        pcall(function()
            if state then
                OldLighting = {Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient}
                Lighting.Ambient = Color3.fromRGB(255, 255, 255); Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            else
                Lighting.Ambient = OldLighting.Ambient; Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient
            end
        end)
    end

    local function SetCustomSky(state)
        pcall(function()
            for _, v in ipairs(Lighting:GetChildren()) do if v:IsA("Sky") and v.Name:sub(1,4) == "Sky_" then v:Destroy() end end
            if state then
                local sky = Instance.new("Sky"); sky.Name = "Sky_" .. rnd()
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
    Workspace.DescendantAdded:Connect(safeCclosure(function(obj) CheckAndHide(obj) end))
    for _, obj in ipairs(Workspace:GetDescendants()) do CheckAndHide(obj) end

    -- ==========================================
    -- FOV CIRCLE (Frame + UICorner, без Drawing)
    -- ==========================================
    local FOV_GUI = Instance.new("ScreenGui"); FOV_GUI.Name = "sg_" .. rnd(); FOV_GUI.ResetOnSpawn = false; FOV_GUI.IgnoreGuiInset = true; FOV_GUI.Parent = GuiParent
    local FOV_Frame = Instance.new("Frame"); FOV_Frame.Name = "f_" .. rnd(); FOV_Frame.Size = UDim2.new(0, Config.FOV_Size * 2, 0, Config.FOV_Size * 2); FOV_Frame.Position = UDim2.new(0.5, -Config.FOV_Size, 0.5, -Config.FOV_Size); FOV_Frame.BackgroundTransparency = 1; FOV_Frame.Parent = FOV_GUI
    local FOV_Corner = Instance.new("UICorner"); FOV_Corner.CornerRadius = UDim.new(0.5, 0); FOV_Corner.Parent = FOV_Frame
    local FOV_Stroke = Instance.new("UIStroke"); FOV_Stroke.Color = Config.Color; FOV_Stroke.Thickness = 1; FOV_Stroke.Transparency = 0.3; FOV_Stroke.Parent = FOV_Frame

    -- ==========================================
    -- ESP (Полностью на BillboardGui - надежно на 50 человек)
    -- ==========================================
    local ESP = {}
    local function CreateESP(pl)
        if pl == LP or ESP[pl] then return end
        local e = {}
        
        e.billboard = Instance.new("BillboardGui")
        e.billboard.Name = "bb_" .. rnd()
        e.billboard.Size = UDim2.new(0, 150, 0, 60)
        e.billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        e.billboard.AlwaysOnTop = true
        e.billboard.Parent = GuiParent
        
        e.text = Instance.new("TextLabel")
        e.text.Size = UDim2.new(1, 0, 0.5, 0)
        e.text.BackgroundTransparency = 1
        e.text.TextColor3 = Color3.fromRGB(255, 255, 255)
        e.text.TextStrokeTransparency = 0
        e.text.Font = Enum.Font.GothamBold
        e.text.TextSize = 14
        e.text.Parent = e.billboard

        e.weapon = Instance.new("TextLabel")
        e.weapon.Size = UDim2.new(1, 0, 0.5, 0)
        e.weapon.Position = UDim2.new(0, 0, 0.5, 0)
        e.weapon.BackgroundTransparency = 1
        e.weapon.TextColor3 = Color3.fromRGB(255, 200, 0)
        e.weapon.TextStrokeTransparency = 0
        e.weapon.Font = Enum.Font.GothamBold
        e.weapon.TextSize = 12
        e.weapon.Visible = false
        e.weapon.Parent = e.billboard
        
        e.Cache = {Char = nil, Hum = nil, HRP = nil, Head = nil, Torso = nil, LArm = nil, RArm = nil, LLeg = nil, RLeg = nil}
        ESP[pl] = e
    end

    local function RemoveAll(pl)
        if ESP[pl] then
            pcall(function()
                if ESP[pl].billboard then ESP[pl].billboard:Destroy() end
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
                if e.billboard then e.billboard.Adornee = char.Head end
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do CreateESP(p); UpdateCache(p) end
    Players.PlayerAdded:Connect(safeCclosure(function(p)
        CreateESP(p)
        p.CharacterAdded:Connect(safeCclosure(function() task.wait(0.5); UpdateCache(p) end))
    end))
    Players.PlayerRemoving:Connect(safeCclosure(RemoveAll))

    -- Меню
    local MenuGui = Instance.new("ScreenGui"); MenuGui.Name = "sg_" .. rnd(); MenuGui.ResetOnSpawn = false; MenuGui.IgnoreGuiInset = true; MenuGui.Parent = GuiParent
    local BottomBar = Instance.new("TextButton"); BottomBar.Name = "b_" .. rnd(); BottomBar.Size = UDim2.new(0, 150, 0, 4); BottomBar.Position = UDim2.new(0.5, -75, 1, -20); BottomBar.BackgroundColor3 = Config.Color; BottomBar.Text = ""; BottomBar.Parent = MenuGui
    local barCorner = Instance.new("UICorner"); barCorner.CornerRadius = UDim.new(1, 0); barCorner.Parent = BottomBar

    local MainFrame = Instance.new("Frame"); MainFrame.Name = "f_" .. rnd(); MainFrame.Size = UDim2.new(0, 380, 0, 280); MainFrame.Position = UDim2.new(0.5, -190, 0.5, -140); MainFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 24); MainFrame.Visible = false; MainFrame.Parent = MenuGui
    local mCorner = Instance.new("UICorner"); mCorner.CornerRadius = UDim.new(0, 8); mCorner.Parent = MainFrame

    local Sidebar = Instance.new("Frame"); Sidebar.Name = "f_" .. rnd(); Sidebar.Size = UDim2.new(0, 100, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 8, 18); Sidebar.Parent = MainFrame
    local sCorner = Instance.new("UICorner"); sCorner.CornerRadius = UDim.new(0, 8); sCorner.Parent = Sidebar
    local Logo = Instance.new("TextLabel"); Logo.Name = "t_" .. rnd(); Logo.Size = UDim2.new(1, 0, 0, 30); Logo.Position = UDim2.new(0, 0, 0, 10); Logo.BackgroundTransparency = 1; Logo.Text = "FUST\nPREMIUM"; Logo.TextColor3 = Config.Color; Logo.Font = Enum.Font.GothamBlack; Logo.TextSize = 13; Logo.Parent = Sidebar

    local Content = Instance.new("Frame"); Content.Name = "f_" .. rnd(); Content.Size = UDim2.new(1, -100, 1, -10); Content.Position = UDim2.new(0, 100, 0, 5); Content.BackgroundTransparency = 1; Content.Parent = MainFrame

    local Tabs = {}
    local function CreateTab(name, icon)
        local btn = Instance.new("TextButton"); btn.Name = "b_" .. rnd(); btn.Size = UDim2.new(1, -10, 0, 25); btn.Position = UDim2.new(0, 5, 0, 50 + (#Tabs * 30)); btn.BackgroundTransparency = 1; btn.Text = " " .. icon .. " " .. name; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Parent = Sidebar
        table.insert(Tabs, {btn = btn, name = name})
        btn.MouseButton1Click:Connect(safeCclosure(function()
            for _, t in ipairs(Tabs) do t.btn.TextColor3 = Color3.fromRGB(150, 150, 150) end
            btn.TextColor3 = Config.Color
            for _, v in pairs(Content:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") or v:IsA("Frame") then v:Destroy() end end
            
            if name == "Combat" then
                local function AddToggle(tName, key, pos)
                    local b = Instance.new("TextButton"); b.Name = "b_" .. rnd(); b.Size = UDim2.new(1, -10, 0, 30); b.Position = UDim2.new(0, 5, 0, pos); b.BackgroundColor3 = Color3.fromRGB(25, 15, 35); b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.Parent = Content
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
                    b.MouseButton1Click:Connect(safeCclosure(function() Config[key] = not Config[key]; b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF") end))
                end
                AddToggle("Aim", "Aim_Enabled", 5)
                AddToggle("TeamCheck", "TeamCheck", 40)
                AddToggle("WallCheck", "WallCheck", 75)
                
                -- FOV SLIDER
                local fovFrame = Instance.new("Frame"); fovFrame.Name = "f_" .. rnd(); fovFrame.Size = UDim2.new(1, -10, 0, 45); fovFrame.Position = UDim2.new(0, 5, 0, 110); fovFrame.BackgroundColor3 = Color3.fromRGB(25, 15, 35); fovFrame.Parent = Content
                local fovCorner = Instance.new("UICorner"); fovCorner.CornerRadius = UDim.new(0, 4); fovCorner.Parent = fovFrame
                local fovText = Instance.new("TextLabel"); fovText.Name = "t_" .. rnd(); fovText.Size = UDim2.new(1, -20, 0, 15); fovText.Position = UDim2.new(0, 10, 0, 5); fovText.BackgroundTransparency = 1; fovText.Text = "FOV Radius: " .. Config.FOV_Size; fovText.TextColor3 = Color3.new(1,1,1); fovText.Font = Enum.Font.Gotham; fovText.TextSize = 12; fovText.TextXAlignment = Enum.TextXAlignment.Left; fovText.Parent = fovFrame
                local fovBar = Instance.new("Frame"); fovBar.Name = "f_" .. rnd(); fovBar.Size = UDim2.new(1, -20, 0, 4); fovBar.Position = UDim2.new(0, 10, 0, 25); fovBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60); fovBar.Parent = fovFrame
                local fovFill = Instance.new("Frame"); fovFill.Name = "f_" .. rnd(); fovFill.Size = UDim2.new((Config.FOV_Size - 20) / 180, 0, 1, 0); fovFill.BackgroundColor3 = Config.Color; fovFill.Parent = fovBar
                local fovInput = Instance.new("TextButton"); fovInput.Name = "b_" .. rnd(); fovInput.Size = UDim2.new(1, 20, 1, 20); fovInput.Position = UDim2.new(0, -10, 0, -10); fovInput.BackgroundTransparency = 1; fovInput.Text = ""; fovInput.Parent = fovBar
                local fovDragging = false
                fovInput.InputBegan:Connect(safeCclosure(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then fovDragging = true end end))
                UserInputService.InputEnded:Connect(safeCclosure(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then fovDragging = false end end))
                UserInputService.InputChanged:Connect(safeCclosure(function(i)
                    if fovDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        local p = math.clamp((i.Position.X - fovBar.AbsolutePosition.X) / fovBar.AbsoluteSize.X, 0, 1)
                        local v = math.floor(20 + 180 * p)
                        Config.FOV_Size = v
                        fovText.Text = "FOV Radius: " .. v
                        fovFill.Size = UDim2.new(p, 0, 1, 0)
                        FOV_Frame.Size = UDim2.new(0, v * 2, 0, v * 2)
                        FOV_Frame.Position = UDim2.new(0.5, -v, 0.5, -v)
                    end
                end))

                if UserRole == "moder" or UserRole == "premium" then
                    local partBtn = Instance.new("TextButton"); partBtn.Name = "b_" .. rnd(); partBtn.Size = UDim2.new(1, -10, 0, 30); partBtn.Position = UDim2.new(0, 5, 0, 165); partBtn.BackgroundColor3 = Config.Color; partBtn.Text = "Target: " .. Config.TargetPart; partBtn.TextColor3 = Color3.new(1,1,1); partBtn.Font = Enum.Font.GothamBold; partBtn.TextSize = 13; partBtn.Parent = Content
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = partBtn
                    partBtn.MouseButton1Click:Connect(safeCclosure(function()
                        if Config.TargetPart == "Head" then Config.TargetPart = "Torso"
                        elseif Config.TargetPart == "Torso" then Config.TargetPart = "Legs"
                        else Config.TargetPart = "Head" end
                        partBtn.Text = "Target: " .. Config.TargetPart
                    end))
                end
            elseif name == "Visuals" then
                local function AddToggle(tName, key, pos, callback)
                    local b = Instance.new("TextButton"); b.Name = "b_" .. rnd(); b.Size = UDim2.new(1, -10, 0, 30); b.Position = UDim2.new(0, 5, 0, pos); b.BackgroundColor3 = Color3.fromRGB(25, 15, 35); b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.Parent = Content
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
                    b.MouseButton1Click:Connect(safeCclosure(function() Config[key] = not Config[key]; b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); if callback then callback(Config[key]) end end))
                end
                AddToggle("ESP", "ESP_Enabled", 5)
                AddToggle("Fullbright", "Fullbright_Enabled", 40, SetFullbright)
                AddToggle("Custom Sky", "CustomSky_Enabled", 75, SetCustomSky)
                AddToggle("NoDeco", "NoDeco_Enabled", 110)
                
                if UserRole == "moder" or UserRole == "premium" then
                    AddToggle("Skeleton (Safe)", "SkeletonESP", 145)
                    AddToggle("WeaponESP", "WeaponESP", 180)
                end
            end
        end))
    end
    CreateTab("Combat", "🎯"); CreateTab("Visuals", "👁️")
    BottomBar.MouseButton1Click:Connect(safeCclosure(function() MainFrame.Visible = not MainFrame.Visible end))

    -- ==========================================
    -- ХЕЛПЕРЫ АИМА
    -- ==========================================
    local function GetVisible(part, pl, camPos)
        if not Config.WallCheck then return true end
        local origin = camPos
        if LP.Character then
            local h = LP.Character:FindFirstChild("Head")
            if h then origin = h.Position end
        end
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LP.Character, pl.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.IgnoreWater = true
        local ray = Workspace:Raycast(origin, part.Position - origin, rayParams)
        return not (ray and not ray.Instance:IsA("Terrain"))
    end

    local function GetAimPart(c)
        if Config.TargetPart == "Torso" then return c.Torso or c.HRP end
        if Config.TargetPart == "Legs" then return c.LLeg or c.HRP end
        return c.Head
    end

    -- ==========================================
    -- ГЛАВНЫЙ ЦИКЛ (Аим + ESP)
    -- ==========================================
    local stickyTarget = nil
    local stickyUntil = 0
    local acc = 0

    RunService.RenderStepped:Connect(safeCclosure(function(dt)
        acc = acc + dt; if acc < (1 / 60) then return end; acc = 0
        local cam = Workspace.CurrentCamera; if not cam then return end
        local camPos = cam.CFrame.Position

        -- Аим
        if Config.Aim_Enabled then
            local targetPart, targetPl = nil, nil
            local shortestDist = math.huge
            local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            local now = tick()

            if stickyTarget and now < stickyUntil and stickyTarget.Cache.Hum and stickyTarget.Cache.Hum.Health > 0 then
                local ap = GetAimPart(stickyTarget.Cache)
                if ap then
                    local sp, on = cam:WorldToViewportPoint(ap.Position)
                    if on and sp.Z > 0 then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d <= Config.FOV_Size * 1.15 then
                            targetPart, targetPl, shortestDist = ap, stickyTarget, d
                        end
                    end
                end
            end

            if not targetPart then
                for pl, e in pairs(ESP) do
                    if pl ~= LP and e.Cache.Hum and e.Cache.Hum.Health > 0 and e.Cache.Head then
                        if not (Config.TeamCheck and pl.Team == LP.Team) then
                            local ap = GetAimPart(e.Cache)
                            if ap then
                                local realDist = (ap.Position - camPos).Magnitude
                                if realDist <= Config.AIM_Range then
                                    local sp, on = cam:WorldToViewportPoint(ap.Position)
                                    if on and sp.Z > 0 then
                                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                                        if d < Config.FOV_Size and d < shortestDist then
                                            if GetVisible(ap, pl, camPos) then
                                                shortestDist, targetPart, targetPl = d, ap, e
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if targetPart and targetPl then
                stickyTarget = targetPl
                stickyUntil = now + 0.25
                local vel = targetPart.Velocity
                local predictTime = math.clamp((targetPart.Position - camPos).Magnitude / 1500, 0, 0.2)
                local targetPos = targetPart.Position + vel * predictTime
                -- SMOOTHNESS = 0.20 для дикой скорости (камера почти телепортируется)
                local smooth = 1 - (Config.SMOOTHNESS ^ (dt * 60))
                smooth = math.clamp(smooth, 0.05, 1)
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(camPos, targetPos), smooth)
            else
                stickyTarget = nil
            end
        end

        -- ESP
        if Config.ESP_Enabled then
            for pl, e in pairs(ESP) do
                local c = e.Cache
                if c.Char and c.Char.Parent and c.Hum and c.Hum.Health > 0 and c.Head and c.HRP then
                    local realDist = (c.HRP.Position - camPos).Magnitude
                    if realDist <= Config.ESP_MaxDist then
                        e.billboard.Enabled = true
                        
                        -- Форматируем текст
                        local nameStr = pl.Name
                        local distStr = math.floor(realDist) .. "m"
                        local hpStr = math.floor(c.Hum.Health) .. " HP"
                        
                        e.text.Text = string.format("%s\n[%s] [%s]", nameStr, distStr, hpStr)
                        
                        -- Оружие (из рюкзака/рук)
                        if (UserRole == "moder" or UserRole == "premium") and Config.WeaponESP then
                            local toolName = nil
                            local handTool = c.Char:FindFirstChildOfClass("Tool")
                            if handTool then toolName = handTool.Name
                            else
                                local backpack = pl:FindFirstChild("Backpack")
                                if backpack then local bpTool = backpack:FindFirstChildOfClass("Tool"); if bpTool then toolName = bpTool.Name end end
                            end
                            if toolName then
                                e.weapon.Visible = true
                                e.weapon.Text = "[" .. toolName .. "]"
                            else
                                e.weapon.Visible = false
                            end
                        else
                            e.weapon.Visible = false
                        end

                        -- Скелетон через Drawing убран для избежания бана
                    else
                        e.billboard.Enabled = false
                        e.weapon.Visible = false
                    end
                else
                    e.billboard.Enabled = false
                    e.weapon.Visible = false
                end
            end
        else
            for _, e in pairs(ESP) do
                e.billboard.Enabled = false
                e.weapon.Visible = false
            end
        end
    end))
end

-- ==========================================
-- ЗАПУСК
-- ==========================================
Submit.MouseButton1Click:Connect(safeCclosure(function()
    local enteredKey = Input.Text
    local keyData = KEY_DATABASE[enteredKey]
    if keyData then
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
end))
