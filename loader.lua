--[[ FUST | PREMIUM EDITION | Neokcep Style Menu ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

-- ==========================================
-- ЗАГРУЗКА КЛЮЧЕЙ
-- ==========================================
local KEY_DATABASE = {}
local KeysUrl = "https://raw.githubusercontent.com/fertyrik2/fust-cheat/main/keys.lua"
local success, result = pcall(function() return loadstring(game:HttpGet(KeysUrl))() end)
if success and type(result) == "table" then KEY_DATABASE = result
else KEY_DATABASE = { ["moder778467526"] = {role = "moder", user = "fust8898"} } end

-- ==========================================
-- KEY SYSTEM UI
-- ==========================================
local UserRole = "free"
local MyUsername = LP.Name

local KeyGui = Instance.new("ScreenGui"); KeyGui.Name = "KeySystemGui"; KeyGui.ResetOnSpawn = false; KeyGui.Parent = CoreGui
local KeyFrame = Instance.new("Frame"); KeyFrame.Size = UDim2.new(0, 250, 0, 120); KeyFrame.Position = UDim2.new(0.5, -125, 0.5, -60); KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 20); KeyFrame.Parent = KeyGui
local kCorner = Instance.new("UICorner"); kCorner.CornerRadius = UDim.new(0, 8); kCorner.Parent = KeyFrame
local kStroke = Instance.new("UIStroke"); kStroke.Color = Color3.fromRGB(150, 80, 255); kStroke.Thickness = 1.5; kStroke.Parent = KeyFrame
local Title = Instance.new("TextLabel"); Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1; Title.Text = "Введите ключ"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.Parent = KeyFrame
local Input = Instance.new("TextBox"); Input.Size = UDim2.new(1, -20, 0, 30); Input.Position = UDim2.new(0, 10, 0, 40); Input.BackgroundColor3 = Color3.fromRGB(30, 20, 40); Input.TextColor3 = Color3.new(1,1,1); Input.PlaceholderText = "Ключ..."; Input.Font = Enum.Font.Gotham; Input.TextSize = 14; Input.Parent = KeyFrame
local Submit = Instance.new("TextButton"); Submit.Size = UDim2.new(1, -20, 0, 30); Submit.Position = UDim2.new(0, 10, 0, 80); Submit.BackgroundColor3 = Color3.fromRGB(150, 80, 255); Submit.Text = "Активировать"; Submit.TextColor3 = Color3.new(1,1,1); Submit.Font = Enum.Font.GothamBold; Submit.TextSize = 14; Submit.Parent = KeyFrame

-- ==========================================
-- ОСНОВНОЙ СКРИПТ
-- ==========================================
local function StartCheat()
    pcall(function() for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "FustMenu" or v.Name == "FOVCircle_New" or v.Name == "FustWatermark" then v:Destroy() end end end)

    local Config = {
        ESP_Enabled = true, Aim_Enabled = true, NoDeco_Enabled = true, Fullbright_Enabled = false,
        TeamCheck = true, WallCheck = true, ESP_MaxDist = 1600, AIM_Range = 500,
        FOV_Size = 50, PREDICTION = 0.148,
        Color = Color3.fromRGB(150, 80, 255),
        SkeletonESP = false, WeaponESP = false, CurrentFOV = 70,
        TargetPart = "Head"
    }

    -- WATERMARK
    local WM_Gui = Instance.new("ScreenGui"); WM_Gui.Name = "FustWatermark"; WM_Gui.ResetOnSpawn = false; WM_Gui.IgnoreGuiInset = true; WM_Gui.Parent = CoreGui
    local WM_Frame = Instance.new("Frame"); WM_Frame.Size = UDim2.new(0, 200, 0, 65); WM_Frame.Position = UDim2.new(1, -210, 1, -80); WM_Frame.BackgroundColor3 = Color3.fromRGB(15, 10, 20); WM_Frame.BackgroundTransparency = 0.2; WM_Frame.Parent = WM_Gui
    local wmCorner = Instance.new("UICorner"); wmCorner.CornerRadius = UDim.new(0, 6); wmCorner.Parent = WM_Frame
    local wmStroke = Instance.new("UIStroke"); wmStroke.Color = Config.Color; wmStroke.Thickness = 1; wmStroke.Parent = WM_Frame
    local TitleLbl = Instance.new("TextLabel"); TitleLbl.Size = UDim2.new(1, 0, 0, 20); TitleLbl.Position = UDim2.new(0, 0, 0, 5); TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "FUST | PREMIUM"; TitleLbl.TextColor3 = Config.Color; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 14; TitleLbl.Parent = WM_Frame
    local FpsLbl = Instance.new("TextLabel"); FpsLbl.Size = UDim2.new(1, 0, 0, 15); FpsLbl.Position = UDim2.new(0, 0, 0, 25); FpsLbl.BackgroundTransparency = 1; FpsLbl.Text = "FPS: 60 | Players: 1"; FpsLbl.TextColor3 = Color3.new(1,1,1); FpsLbl.Font = Enum.Font.Gotham; FpsLbl.TextSize = 12; FpsLbl.Parent = WM_Frame
    local UserLbl = Instance.new("TextLabel"); UserLbl.Size = UDim2.new(1, 0, 0, 15); UserLbl.Position = UDim2.new(0, 0, 0, 45); UserLbl.BackgroundTransparency = 1; UserLbl.Text = "Role: " .. UserRole; UserLbl.TextColor3 = Color3.fromRGB(200, 200, 200); UserLbl.Font = Enum.Font.Gotham; UserLbl.TextSize = 11; UserLbl.Parent = WM_Frame

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

    -- FULLBRIGHT
    local function SetFullbright(state)
        pcall(function()
            if state then
                Lighting.Ambient = Color3.fromRGB(255, 255, 255); Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                local atm = Lighting:FindFirstChild("Fust_Atm") or Instance.new("Atmosphere", Lighting)
                atm.Name = "Fust_Atm"; atm.Density = 0; atm.Haze = 0
                local cc = Lighting:FindFirstChild("Fust_CC") or Instance.new("ColorCorrectionEffect", Lighting)
                cc.Name = "Fust_CC"; cc.Brightness = 0.1
            else
                local atm = Lighting:FindFirstChild("Fust_Atm"); if atm then atm.Density = 0.3 end
                local cc = Lighting:FindFirstChild("Fust_CC"); if cc then cc.Brightness = 0 end
            end
        end)
    end

    -- NO DECO
    local function HidePart(part) if part:IsA("BasePart") then part.Transparency = 1; part.CanCollide = false end end
    local function CheckAndHide(part)
        if not part:IsA("BasePart") then return end
        if (part.Material == Enum.Material.Grass or part.Material == Enum.Material.LeafyGrass) and math.max(part.Size.X, part.Size.Y, part.Size.Z) <= 15 then HidePart(part) end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do CheckAndHide(obj) end
    Workspace.DescendantAdded:Connect(CheckAndHide)

    -- FOV CIRCLE
    local FOV_GUI = Instance.new("ScreenGui"); FOV_GUI.Name = "FOVCircle_New"; FOV_GUI.ResetOnSpawn = false; FOV_GUI.IgnoreGuiInset = true; FOV_GUI.Parent = CoreGui
    local FOV_Frame = Instance.new("Frame"); FOV_Frame.Size = UDim2.new(0, Config.FOV_Size * 2, 0, Config.FOV_Size * 2); FOV_Frame.Position = UDim2.new(0.5, -Config.FOV_Size, 0.5, -Config.FOV_Size); FOV_Frame.BackgroundTransparency = 1; FOV_Frame.Parent = FOV_GUI
    local FOV_Stroke = Instance.new("UIStroke"); FOV_Stroke.Color = Config.Color; FOV_Stroke.Thickness = 1; FOV_Stroke.Parent = FOV_Frame
    local FOV_Corner = Instance.new("UICorner"); FOV_Corner.CornerRadius = UDim.new(0.5, 0); FOV_Corner.Parent = FOV_Frame

    -- ESP
    local ESP = {}; local Cache = {}
    local function CreateESP(pl)
        if pl == LP or ESP[pl] then return end
        local e = {}
        e.b1 = Drawing.new("Line"); e.b2 = Drawing.new("Line"); e.b3 = Drawing.new("Line"); e.b4 = Drawing.new("Line")
        e.b1.Thickness = 1; e.b2.Thickness = 1; e.b3.Thickness = 1; e.b4.Thickness = 1
        e.b1.Color = Config.Color; e.b2.Color = Config.Color; e.b3.Color = Config.Color; e.b4.Color = Config.Color
        e.dist = Drawing.new("Text"); e.dist.Size = 12; e.dist.Center = true; e.dist.Outline = true; e.dist.Color = Color3.new(1,1,1)
        e.weapon = Drawing.new("Text"); e.weapon.Size = 11; e.weapon.Center = true; e.weapon.Outline = true; e.weapon.Color = Color3.fromRGB(255, 200, 0); e.weapon.Visible = false
        e.hpBg = Drawing.new("Line"); e.hpBg.Thickness = 2; e.hpBg.Color = Color3.new(0,0,0)
        e.hpFill = Drawing.new("Line"); e.hpFill.Thickness = 2
        e.bones = { Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line") }
        for _, b in ipairs(e.bones) do b.Thickness = 1; b.Color = Color3.fromRGB(255, 100, 100); b.Visible = false end
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
        Cache[pl] = nil
    end

    local function UpdateCache(pl)
        local char = pl.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid"); local head = char:FindFirstChild("Head"); local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and head and hrp then Cache[pl] = { Char = char, Hum = hum, HRP = hrp, Head = head } else Cache[pl] = nil end
        else Cache[pl] = nil end
    end

    for _, p in ipairs(Players:GetPlayers()) do UpdateCache(p); CreateESP(p) end
    Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(0.5); UpdateCache(p) end); UpdateCache(p); CreateESP(p) end)
    Players.PlayerRemoving:Connect(RemoveAll)
    task.spawn(function() while task.wait(1) do for _, pl in ipairs(Players:GetPlayers()) do if pl ~= LP then local data = Cache[pl]; if not data or not data.Head.Parent or not data.HRP.Parent then UpdateCache(pl) end end end end end)

    -- AIM
    local Target = nil
    local function GetClosestTarget()
        if not Camera then return nil end
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2); local closest = nil; local shortestDist = Config.FOV_Size
        for pl, data in pairs(Cache) do
            if pl ~= LP and data.Hum and data.Hum.Health > 0 then
                local aimPart = data.Head
                if Config.TargetPart == "Torso" then aimPart = data.Char:FindFirstChild("UpperTorso") or data.Char:FindFirstChild("Torso") or data.HRP
                elseif Config.TargetPart == "Legs" then aimPart = data.Char:FindFirstChild("LeftUpperLeg") or data.Char:FindFirstChild("RightUpperLeg") or data.HRP end
                if aimPart and not (Config.TeamCheck and pl.Team == LP.Team) then
                    local realDist = (aimPart.Position - Camera.CFrame.Position).Magnitude
                    if realDist <= Config.AIM_Range then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                            if dist < shortestDist then
                                local visible = true
                                if Config.WallCheck then
                                    local points = { aimPart.Position, aimPart.Position + Vector3.new(0, 0.5, 0), aimPart.Position - Vector3.new(0, 0.5, 0) }
                                    visible = false
                                    for _, pt in ipairs(points) do
                                        local rayParams = RaycastParams.new(); rayParams.FilterDescendantsInstances = {LP.Character, pl.Character}; rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                        if not Workspace:Raycast(Camera.CFrame.Position, pt - Camera.CFrame.Position, rayParams) then visible = true; break end
                                    end
                                end
                                if visible then shortestDist = dist; closest = aimPart end
                            end
                        end
                    end
                end
            end
        end
        return closest
    end

    -- ==========================================
    -- МЕНЮ (Стиль Neokcep)
    -- ==========================================
    local MenuGui = Instance.new("ScreenGui"); MenuGui.Name = "FustMenu"; MenuGui.ResetOnSpawn = false; MenuGui.IgnoreGuiInset = true; MenuGui.Parent = CoreGui
    
    -- Кнопка открытия (внизу справа, маленькая)
    local ToggleBtn = Instance.new("TextButton"); ToggleBtn.Size = UDim2.new(0, 120, 0, 30); ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0); ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 10, 20); ToggleBtn.Text = "МЕНЮ"; ToggleBtn.TextColor3 = Config.Color; ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 14; ToggleBtn.Parent = MenuGui
    local toggleCorner = Instance.new("UICorner"); toggleCorner.CornerRadius = UDim.new(0, 6); toggleCorner.Parent = ToggleBtn
    local toggleStroke = Instance.new("UIStroke"); toggleStroke.Color = Config.Color; toggleStroke.Thickness = 1; toggleStroke.Parent = ToggleBtn

    -- Основное окно
    local MainFrame = Instance.new("Frame"); MainFrame.Size = UDim2.new(0, 500, 0, 300); MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150); MainFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 24); MainFrame.Visible = false; MainFrame.Parent = MenuGui
    local mCorner = Instance.new("UICorner"); mCorner.CornerRadius = UDim.new(0, 8); mCorner.Parent = MainFrame
    local mStroke = Instance.new("UIStroke"); mStroke.Color = Config.Color; mStroke.Thickness = 1.5; mStroke.Parent = MainFrame

    -- Левая панель (Вкладки)
    local Sidebar = Instance.new("Frame"); Sidebar.Size = UDim2.new(0, 120, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 8, 18); Sidebar.Parent = MainFrame
    local sCorner = Instance.new("UICorner"); sCorner.CornerRadius = UDim.new(0, 8); sCorner.Parent = Sidebar
    
    -- Название в сайдбаре
    local Logo = Instance.new("TextLabel"); Logo.Size = UDim2.new(1, 0, 0, 40); Logo.Position = UDim2.new(0, 0, 0, 10); Logo.BackgroundTransparency = 1; Logo.Text = "FUST\nPREMIUM"; Logo.TextColor3 = Config.Color; Logo.Font = Enum.Font.GothamBlack; Logo.TextSize = 16; Logo.Parent = Sidebar

    -- Контентная часть
    local Content = Instance.new("Frame"); Content.Size = UDim2.new(1, -120, 1, -20); Content.Position = UDim2.new(0, 120, 0, 10); Content.BackgroundTransparency = 1; Content.Parent = MainFrame

    -- Функция переключения вкладок
    local Tabs = {}
    local function CreateTab(name, icon)
        local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, -10, 0, 30); btn.Position = UDim2.new(0, 5, 0, 60 + (#Tabs * 35)); btn.BackgroundTransparency = 1; btn.Text = " " .. icon .. " " .. name; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Parent = Sidebar
        table.insert(Tabs, {btn = btn, name = name})
        
        btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(Tabs) do
                t.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            btn.TextColor3 = Config.Color
            
            -- Очищаем контент и создаем новые кнопки
            for _, v in pairs(Content:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end end
            
            if name == "Combat" then
                -- Кнопки для Combat
                local function AddToggle(tName, key, pos)
                    local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -10, 0, 35); b.Position = UDim2.new(0, 5, 0, pos); b.BackgroundColor3 = Color3.fromRGB(25, 15, 35); b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 14; b.Parent = Content
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
                    b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF") end)
                end
                AddToggle("Aim", "Aim_Enabled", 5)
                AddToggle("TeamCheck", "TeamCheck", 45)
                AddToggle("WallCheck", "WallCheck", 85)
                
            elseif name == "Visuals" then
                -- Кнопки для Visuals
                local function AddToggle(tName, key, pos)
                    local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -10, 0, 35); b.Position = UDim2.new(0, 5, 0, pos); b.BackgroundColor3 = Color3.fromRGB(25, 15, 35); b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 14; b.Parent = Content
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
                    b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF") end)
                end
                AddToggle("ESP", "ESP_Enabled", 5)
                AddToggle("Fullbright", "Fullbright_Enabled", 45)
                AddToggle("NoDeco", "NoDeco_Enabled", 85)
                
            elseif name == "Player" and UserRole == "moder" then
                -- Кнопки для Player
                local function AddToggle(tName, key, pos)
                    local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -10, 0, 35); b.Position = UDim2.new(0, 5, 0, pos); b.BackgroundColor3 = Color3.fromRGB(25, 15, 35); b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 14; b.Parent = Content
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
                    b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF") end)
                end
                AddToggle("Skeleton", "SkeletonESP", 5)
                AddToggle("WeaponESP", "WeaponESP", 45)
            end
        end)
    end

    CreateTab("Combat", "🎯")
    CreateTab("Visuals", "👁️")
    if UserRole == "moder" then CreateTab("Player", "👤") end

    -- Кнопка открытия/закрытия
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    -- Перетаскивание меню
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

    -- Главный цикл
    local acc = 0
    RunService.RenderStepped:Connect(function(dt)
        acc = acc + dt; if acc < (1 / 30) then return end; acc = 0
        local cam = Camera; if not cam then return end; local camPos = cam.CFrame.Position
        if Config.Aim_Enabled then
            Target = GetClosestTarget()
            if Target then
                FOV_Stroke.Color = Color3.fromRGB(0, 255, 0)
                local targetCFrame = CFrame.new(cam.CFrame.Position, Target.Position + (Target.Velocity * Config.PREDICTION))
                cam.CFrame = targetCFrame
            else FOV_Stroke.Color = Config.Color end
        end
        if Config.ESP_Enabled then
            for pl, e in pairs(ESP) do
                local data = Cache[pl]
                if data and data.Hum and data.Hum.Health > 0 and data.Char and data.Char.Parent and data.Head.Parent and data.HRP.Parent then
                    local realDist = (data.HRP.Position - camPos).Magnitude
                    if realDist <= Config.ESP_MaxDist then
                        local headPos, _ = cam:WorldToViewportPoint(data.Head.Position); local rootPos, _ = cam:WorldToViewportPoint(data.HRP.Position)
                        if headPos.Z > 0 then
                            local height = math.abs(headPos.Y - rootPos.Y) * 1.5; local width = height / 2; local x, y = rootPos.X - width / 2, rootPos.Y - height / 2
                            e.b1.Visible = true; e.b1.From = Vector2.new(x, y); e.b1.To = Vector2.new(x + width, y)
                            e.b2.Visible = true; e.b2.From = Vector2.new(x + width, y); e.b2.To = Vector2.new(x + width, y + height)
                            e.b3.Visible = true; e.b3.From = Vector2.new(x + width, y + height); e.b3.To = Vector2.new(x, y + height)
                            e.b4.Visible = true; e.b4.From = Vector2.new(x, y + height); e.b4.To = Vector2.new(x, y)
                            e.dist.Visible = true; e.dist.Text = "[" .. math.floor(realDist) .. "m]"; e.dist.Position = Vector2.new(x + width / 2, y + height + 2)
                            local hpPercent = math.clamp(data.Hum.Health / data.Hum.MaxHealth, 0, 1)
                            e.hpBg.Visible = true; e.hpBg.From = Vector2.new(x - 6, y); e.hpBg.To = Vector2.new(x - 6, y + height)
                            e.hpFill.Visible = true; e.hpFill.From = Vector2.new(x - 6, y + height); e.hpFill.To = Vector2.new(x - 6, y + height - (height * hpPercent)); e.hpFill.Color = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0)
                            
                            if UserRole == "moder" and Config.WeaponESP then
                                local toolName = nil
                                local handTool = data.Char:FindFirstChildOfClass("Tool")
                                if handTool then toolName = handTool.Name
                                else
                                    local backpack = pl:FindFirstChild("Backpack")
                                    if backpack then local backpackTool = backpack:FindFirstChildOfClass("Tool"); if backpackTool then toolName = backpackTool.Name .. " (рюкзак)" end end
                                end
                                if toolName then e.weapon.Visible = true; e.weapon.Text = "[" .. toolName .. "]"; e.weapon.Position = Vector2.new(x + width / 2, y - 16) else e.weapon.Visible = false end
                            else e.weapon.Visible = false end
                            
                            if UserRole == "moder" and Config.SkeletonESP then
                                local function to2d(p) if not p then return nil end local sp, on = cam:WorldToViewportPoint(p.Position) if on then return Vector2.new(sp.X, sp.Y) end return nil end
                                local h2d, r2d = to2d(data.Head), to2d(data.HRP); local t2d = to2d(data.Char:FindFirstChild("UpperTorso"))
                                local la, ra = to2d(data.Char:FindFirstChild("LeftUpperArm")), to2d(data.Char:FindFirstChild("RightUpperArm"))
                                local ll, rl = to2d(data.Char:FindFirstChild("LeftUpperLeg")), to2d(data.Char:FindFirstChild("RightUpperLeg"))
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
                    else
                        for _, obj in ipairs({e.b1, e.b2, e.b3, e.b4, e.dist, e.hpBg, e.hpFill, e.weapon}) do obj.Visible = false end
                        for _, b in ipairs(e.bones) do b.Visible = false end
                    end
                else
                    if e.b1 then
                        for _, obj in ipairs({e.b1, e.b2, e.b3, e.b4, e.dist, e.hpBg, e.hpFill, e.weapon}) do obj.Visible = false end
                        for _, b in ipairs(e.bones) do b.Visible = false end
                    end
                end
            end
        end
    end)
end

Submit.MouseButton1Click:Connect(function()
    local enteredKey = Input.Text
    local keyData = KEY_DATABASE[enteredKey]
    if keyData then
        if keyData.user == MyUsername then
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
