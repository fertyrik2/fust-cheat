--[[ FUST Visuals | Clean UI + ESP ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

-- ЦВЕТА (Черно-фиолетовая тема)
local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 28),
    Accent = Color3.fromRGB(150, 80, 255), -- Фиолетовый
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 160),
    Card = Color3.fromRGB(28, 28, 38),
    Border = Color3.fromRGB(45, 45, 60)
}

-- НАСТРОЙКИ ESP
local Config = {
    ESP = true,
    Box = true,
    Name = true,
    Health = true,
    Distance = true,
    MaxDist = 1000,
    Color = Color3.fromRGB(150, 80, 255) -- Цвет ESP под стать меню
}

-- ОБЕРТКИ
if not newcclosure then getgenv().newcclosure = function(f) return f end end
local function N(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do pcall(function() o[k] = v end) end
    if parent then o.Parent = parent end
    return o
end

-- ================= UI =================
local SG = N("ScreenGui", {Name="FustVisuals", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling}, CoreGui)
local Main = N("Frame", {Size=UDim2.new(0, 550, 0, 350), Position=UDim2.new(0.5, -275, 0.5, -175), BackgroundColor3=Theme.Background, BorderSizePixel=0, Visible=true}, SG)
N("UICorner", {CornerRadius=UDim.new(0, 8)}, Main)
N("UIStroke", {Color=Theme.Border, Thickness=1}, Main)

-- Заголовок (Drag)
local TopBar = N("Frame", {Size=UDim2.new(1, 0, 0, 40), BackgroundColor3=Theme.Sidebar, BorderSizePixel=0}, Main)
N("UICorner", {CornerRadius=UDim.new(0, 8)}, TopBar)
N("TextLabel", {Size=UDim2.new(1, -20, 1, 0), Position=UDim2.new(0, 15, 0, 0), BackgroundTransparency=1, Text="FUST | Visuals", TextColor3=Theme.Text, Font=Enum.Font.GothamBold, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left}, TopBar)
local CloseBtn = N("TextButton", {Size=UDim2.new(0, 30, 0, 30), Position=UDim2.new(1, -35, 0.5, -15), BackgroundTransparency=1, Text="✕", TextColor3=Theme.TextDim, Font=Enum.Font.GothamBold, TextSize=14}, TopBar)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- Панель контента (Слева)
local Content = N("Frame", {Size=UDim2.new(1, -120, 1, -50), Position=UDim2.new(0, 10, 0, 50), BackgroundTransparency=1}, Main)

-- Вкладки (Справа)
local Sidebar = N("Frame", {Size=UDim2.new(0, 100, 1, -50), Position=UDim2.new(1, -110, 0, 50), BackgroundColor3=Theme.Sidebar, BorderSizePixel=0}, Main)
N("UICorner", {CornerRadius=UDim.new(0, 6)}, Sidebar)
N("UIListLayout", {Padding=UDim.new(0, 5), HorizontalAlignment=Enum.HorizontalAlignment.Center}, Sidebar)
N("UIPadding", {PaddingTop=UDim.new(0, 10)}, Sidebar)

local function CreateTabBtn(text)
    local btn = N("TextButton", {Size=UDim2.new(0, 85, 0, 30), BackgroundColor3=Theme.Card, Text=text, TextColor3=Theme.Text, Font=Enum.Font.GothamMedium, TextSize=13}, Sidebar)
    N("UICorner", {CornerRadius=UDim.new(0, 4)}, btn)
    return btn
end

local visualTab = CreateTabBtn("Visuals")
-- Тут можно добавить другие вкладки позже
N("UIListLayout", {Padding=UDim.new(0, 8)}, Content)

-- Функция создания свитча
local function CreateToggle(name, stateKey)
    local f = N("Frame", {Size=UDim2.new(1, -20, 0, 35), BackgroundColor3=Theme.Card}, Content)
    N("UICorner", {CornerRadius=UDim.new(0, 6)}, f)
    N("TextLabel", {Size=UDim2.new(1, -60, 1, 0), Position=UDim2.new(0, 10, 0, 0), BackgroundTransparency=1, Text=name, TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left}, f)
    
    local bg = N("Frame", {Size=UDim2.new(0, 36, 0, 18), Position=UDim2.new(1, -46, 0.5, -9), BackgroundColor3=Config[stateKey] and Theme.Accent or Theme.Border}, f)
    N("UICorner", {CornerRadius=UDim.new(0, 9)}, bg)
    local knob = N("Frame", {Size=UDim2.new(0, 14, 0, 14), Position=Config[stateKey] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3=Theme.Text}, bg)
    N("UICorner", {CornerRadius=UDim.new(0, 7)}, knob)
    
    local btn = N("TextButton", {Size=UDim2.new(1, 0, 1, 0), BackgroundTransparency=1, Text=""}, f)
    btn.MouseButton1Click:Connect(function()
        Config[stateKey] = not Config[stateKey]
        bg.BackgroundColor3 = Config[stateKey] and Theme.Accent or Theme.Border
        knob.Position = Config[stateKey] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    end)
    return f
end

-- Слайдер дистанции
local function CreateSlider(name, stateKey, min, max)
    local f = N("Frame", {Size=UDim2.new(1, -20, 0, 50), BackgroundColor3=Theme.Card}, Content)
    N("UICorner", {CornerRadius=UDim.new(0, 6)}, f)
    local lbl = N("TextLabel", {Size=UDim2.new(1, -20, 0, 20), Position=UDim2.new(0, 10, 0, 5), BackgroundTransparency=1, Text=name..": "..Config[stateKey], TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left}, f)
    
    local bar = N("Frame", {Size=UDim2.new(1, -20, 0, 4), Position=UDim2.new(0, 10, 0, 30), BackgroundColor3=Theme.Border}, f)
    N("UICorner", {CornerRadius=UDim.new(0, 2)}, bar)
    local fill = N("Frame", {Size=UDim2.new((Config[stateKey]-min)/(max-min), 0, 1, 0), BackgroundColor3=Theme.Accent}, bar)
    N("UICorner", {CornerRadius=UDim.new(0, 2)}, fill)
    
    local inp = N("TextButton", {Size=UDim2.new(1, 20, 1, 20), Position=UDim2.new(0, -10, 0, -10), BackgroundTransparency=1, Text=""}, bar)
    local dragging = false
    
    inp.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max - min) * p)
            Config[stateKey] = v
            lbl.Text = name..": "..v
            fill.Size = UDim2.new(p, 0, 1, 0)
        end
    end)
end

-- Добавляем элементы в меню
CreateToggle("ESP Включить", "ESP")
CreateToggle("Боксы (Box)", "Box")
CreateToggle("Имена (Name)", "Name")
CreateToggle("Здоровье (HP)", "Health")
CreateToggle("Дистанция (Dist)", "Distance")
CreateSlider("Макс. Дистанция", "MaxDist", 100, 3000)

-- Перетаскивание меню
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ================= ESP LOGIC =================
local PlayerCache = {}
local function UpdateCache(pl)
    if pl ~= LP then
        PlayerCache[pl] = {Char = pl.Character}
        pl.CharacterAdded:Connect(function(char) PlayerCache[pl].Char = char end)
    end
end
for _, p in ipairs(Players:GetPlayers()) do UpdateCache(p) end
Players.PlayerAdded:Connect(UpdateCache)
Players.PlayerRemoving:Connect(function(p) PlayerCache[p] = nil end)

local Drawings = {}
local function CreateESP(pl)
    if pl == LP or Drawings[pl] then return end
    local d = {}
    d.Box = Drawing.new("Square")
    d.Box.Thickness = 1; d.Box.Filled = false; d.Box.Color = Config.Color
    d.Name = Drawing.new("Text")
    d.Name.Size = 13; d.Name.Center = true; d.Name.Outline = true; d.Name.Font = 2; d.Name.Color = Color3.new(1,1,1)
    d.Dist = Drawing.new("Text")
    d.Dist.Size = 12; d.Dist.Center = true; d.Dist.Outline = true; d.Dist.Font = 2; d.Dist.Color = Color3.fromRGB(200,200,200)
    d.Health = Drawing.new("Line")
    d.Health.Thickness = 2; d.Health.Color = Color3.fromRGB(0,255,0)
    Drawings[pl] = d
end
for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(function(p) task.wait(1); CreateESP(p) end)
Players.PlayerRemoving:Connect(function(p)
    if Drawings[p] then
        for _, obj in pairs(Drawings[p]) do obj:Remove() end
        Drawings[p] = nil
    end
end)

-- Рендер
RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    for pl, d in pairs(Drawings) do
        local char = pl.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        
        if Config.ESP and hum and hum.Health > 0 and hrp and head then
            local headPos, headOn = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local rootPos, rootOn = cam:WorldToViewportPoint(hrp.Position)
            
            if headOn and rootOn and rootPos.Z < Config.MaxDist then
                local height = math.abs(headPos.Y - rootPos.Y) * 1.5
                local width = height / 2
                local x = rootPos.X - width / 2
                local y = headPos.Y - (height * 0.2)
                
                -- Бокс
                d.Box.Visible = Config.Box
                d.Box.Size = Vector2.new(width, height)
                d.Box.Position = Vector2.new(x, y)
                
                -- Имя
                d.Name.Visible = Config.Name
                d.Name.Text = pl.DisplayName
                d.Name.Position = Vector2.new(rootPos.X, y - 16)
                
                -- Дистанция
                d.Dist.Visible = Config.Distance
                d.Dist.Text = "[" .. math.floor(rootPos.Z) .. "m]"
                d.Dist.Position = Vector2.new(rootPos.X, y + height + 2)
                
                -- ХП
                d.Health.Visible = Config.Health
                local hpP = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                d.Health.From = Vector2.new(x - 4, y + height)
                d.Health.To = Vector2.new(x - 4, y + height - (height * hpP))
                d.Health.Color = Color3.fromRGB(255 * (1 - hpP), 255 * hpP, 0)
            else
                for _, obj in pairs(d) do obj.Visible = false end
            end
        else
            for _, obj in pairs(d) do obj.Visible = false end
        end
    end
end)
