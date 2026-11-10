--[[ FerClient v25.0 | FUST Edition | Full Visual + Aim ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled
local function GetCamera() local cam = workspace.CurrentCamera; if cam and cam.Parent then return cam end; return nil end

-- ОБЕРТКИ
if not newcclosure then getgenv().newcclosure = function(f) return f end end
if not checkcaller then getgenv().checkcaller = function() return false end end
if not hookmetamethod then getgenv().hookmetamethod = function() end end
if not getnamecallmethod then getgenv().getnamecallmethod = function() return "" end end

-- ЦВЕТА
local Colors = {
    Accent = Color3.fromRGB(150, 80, 255), Background = Color3.fromRGB(12, 12, 16), Sidebar = Color3.fromRGB(18, 18, 24),
    Panel = Color3.fromRGB(22, 22, 30), Card = Color3.fromRGB(28, 28, 38), CardHover = Color3.fromRGB(38, 38, 50),
    Text = Color3.fromRGB(240, 240, 248), TextDim = Color3.fromRGB(150, 150, 165), Border = Color3.fromRGB(38, 38, 50), BorderLight = Color3.fromRGB(50, 50, 66)
}

-- СОСТОЯНИЕ
local C = {
    SilentAim=false, AimPart="Head", FOV=150, TeamCheck=false, WallCheck=false, AutoShoot=false, AutoShootDelay=0.05,
    ESP=false, ESPBox=true, ESPName=true, ESPDist=true, ESPSkeleton=false, ESPHP=false, ESPHPNum=false, ESPTracers=false, ESPHead=false, ESPMaxDist=1000,
    ESPColor=Color3.fromRGB(0,200,255), ShowFOV=false, Fullbright=false, XRay=false, NoDeco=false,
    NoFallDamage=false, InfJump=false, AntiAFK=false, ThirdPerson=false, ThirdPersonDist=15, HeadExpander=false, HitboxSize=5,
    NoBulletDrop=false, OptLowGFX=false, AdminList=false,
    Hitmarker=false, HitSound=false, KillSound=false
}
local CurrentAimTarget = nil

-- Сохраняем свет
local OldLighting = {
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows
}

-- CACHE
local PlayerCache = {}
local function UpdatePlayerCache(pl)
    if pl == LP then return end
    local char = pl.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    PlayerCache[pl] = {Char=char, Hum=hum, HRP=hrp}
end
local function RegisterPlayer(pl)
    if pl == LP then return end
    UpdatePlayerCache(pl)
    pl.CharacterAdded:Connect(function() UpdatePlayerCache(pl) end)
    pl.CharacterRemoving:Connect(function() PlayerCache[pl] = nil end)
end
for _, pl in ipairs(Players:GetPlayers()) do RegisterPlayer(pl) end
Players.PlayerAdded:Connect(RegisterPlayer)
Players.PlayerRemoving:Connect(function(pl) PlayerCache[pl] = nil end)

-- UI HELPERS
local function N(class, props, parent)
    local o = Instance.new(class); for k, v in pairs(props or {}) do pcall(function() o[k] = v end) end; if parent then o.Parent = parent end; return o
end
local function corner(p, r) return N("UICorner", {CornerRadius=UDim.new(0,r or 8)}, p) end
local function stroke(p, c, t, tr) return N("UIStroke", {Color=c or Colors.Border, Thickness=t or 1, Transparency=tr or 0.3, ApplyStrokeMode=Enum.ApplyStrokeMode.Border}, p) end
local function padding(p, px, py) local u=N("UIPadding",{},p); local ux,uy=UDim.new(0,px or 0),UDim.new(0,py or px or 0); u.PaddingLeft=ux; u.PaddingRight=ux; u.PaddingTop=uy; u.PaddingBottom=uy; return u end

-- GUI
local SG = N("ScreenGui", {Name="FerUI", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling}, CoreGui)
local M = N("Frame", {Size=UDim2.new(0,600,0,400), Position=UDim2.new(0.5,-300,0.5,-200), BackgroundColor3=Colors.Background, BorderSizePixel=0, Visible=false}, SG)
if isMobile then M.Size=UDim2.new(0,450,0,320) M.Position=UDim2.new(0.5,-225,0.5,-160) end
corner(M,10); stroke(M, Colors.BorderLight, 1, 0.3)

local TitleBar = N("Frame", {Size=UDim2.new(1,0,0,40), BackgroundColor3=Colors.Sidebar, BorderSizePixel=0}, M)
corner(TitleBar,10)
N("TextLabel", {Size=UDim2.new(1,-50,1,0), Position=UDim2.new(0,16,0,0), BackgroundTransparency=1, Text="FerClient FUST", TextColor3=Colors.Text, Font=Enum.Font.GothamBold, TextSize=15, TextXAlignment=Enum.TextXAlignment.Left}, TitleBar)
local closeClick = N("TextButton", {Size=UDim2.new(0,26,0,26), Position=UDim2.new(1,-32,0.5,-13), BackgroundColor3=Color3.fromRGB(220,50,70), Text="✕", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=13}, TitleBar)
corner(closeClick,6); closeClick.MouseButton1Click:Connect(function() M.Visible=false end)

local Sidebar = N("Frame", {Size=UDim2.new(0,130,1,-50), Position=UDim2.new(0,10,0,50), BackgroundColor3=Colors.Sidebar, BorderSizePixel=0}, M)
corner(Sidebar,10); N("UIListLayout", {Padding=UDim.new(0,4)}, Sidebar); padding(Sidebar,8,10)

local Container = N("ScrollingFrame", {Position=UDim2.new(0,150,0,50), Size=UDim2.new(1,-160,1,-60), BackgroundColor3=Colors.Panel, BorderSizePixel=0, ScrollBarThickness=0, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y}, M)
corner(Container,10); N("UIListLayout", {Padding=UDim.new(0,6)}, Container); padding(Container,12)

local Tabs = {AIM={}, VISUALS={}, PLAYER={}, WORLD={}}
local tabButtons = {}
local function showTab(name)
    for t, objs in pairs(Tabs) do for _, o in ipairs(objs) do o.Visible=(t==name) end end
    for k, b in pairs(tabButtons) do b.TextColor3 = (k==name) and Colors.Accent or Colors.TextDim end
end

local function createTabBtn(name, label, order)
    local b = N("TextButton", {Size=UDim2.new(1,0,0,32), BackgroundColor3=Colors.Sidebar, Text=label, TextColor3=Colors.TextDim, Font=Enum.Font.GothamMedium, TextSize=13, AutoButtonColor=false, LayoutOrder=order}, Sidebar)
    corner(b,6); tabButtons[name]=b; b.MouseButton1Click:Connect(function() showTab(name) end)
end

local function createCategory(title, order)
    return N("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text=title, TextColor3=Colors.TextDim, Font=Enum.Font.GothamBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=order}, Container)
end

local function createToggle(label, prop, order, callback)
    local b = N("TextButton", {Size=UDim2.new(1,0,0,35), BackgroundColor3=Colors.Card, Text="", AutoButtonColor=false, LayoutOrder=order}, Container)
    corner(b,6); N("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text=label, TextColor3=Colors.Text, Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left}, b)
    local sw = N("Frame", {Size=UDim2.new(0,30,0,16), Position=UDim2.new(1,-40,0.5,-8), BackgroundColor3=C[prop] and Colors.Accent or Colors.BorderLight}, b)
    corner(sw,8); local kn = N("Frame", {Size=UDim2.new(0,12,0,12), Position=C[prop] and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6), BackgroundColor3=Color3.new(1,1,1)}, sw)
    corner(kn,6); b.MouseButton1Click:Connect(function() C[prop]=not C[prop]; sw.BackgroundColor3=C[prop] and Colors.Accent or Colors.BorderLight; kn.Position=C[prop] and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6); if callback then callback(C[prop]) end end)
    return b
end

local function createSlider(label, prop, min, max, order)
    local f = N("Frame", {Size=UDim2.new(1,0,0,42), BackgroundColor3=Colors.Card, LayoutOrder=order}, Container)
    corner(f,6); N("TextLabel", {Size=UDim2.new(1,-100,0,16), Position=UDim2.new(0,10,0,4), BackgroundTransparency=1, Text=label, TextColor3=Colors.Text, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left}, f)
    local vl = N("TextLabel", {Size=UDim2.new(0,50,0,16), Position=UDim2.new(1,-60,0,4), BackgroundTransparency=1, Text=tostring(C[prop]), TextColor3=Colors.Accent, Font=Enum.Font.GothamBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Right}, f)
    local bar = N("Frame", {Size=UDim2.new(1,-20,0,4), Position=UDim2.new(0,10,0,26), BackgroundColor3=Colors.BorderLight}, f)
    corner(bar,2); local fill = N("Frame", {Size=UDim2.new((C[prop]-min)/(max-min),0,1,0), BackgroundColor3=Colors.Accent}, bar)
    corner(fill,2); local inp = N("TextButton", {Size=UDim2.new(1,0,1,20), Position=UDim2.new(0,0,0,-10), BackgroundTransparency=1, Text=""}, bar); local drag=false
    inp.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
    UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local p=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1); local v=math.floor(min+(max-min)*p+0.5); C[prop]=v; vl.Text=tostring(v); fill.Size=UDim2.new(p,0,1,0) end end)
    return f
end

local O=0; local function nextO() O=O+1; return O end
local function addTo(t,o) if o then table.insert(Tabs[t],o); o.Visible=false end end

createTabBtn("AIM","Aimbot",1); createTabBtn("VISUALS","Visuals",2); createTabBtn("PLAYER","Player",3); createTabBtn("WORLD","World",4)

-- НАПОЛНЕНИЕ
addTo("AIM", createCategory("AIMBOT", nextO()))
addTo("AIM", createToggle("Silent Aim", "SilentAim", nextO()))
addTo("AIM", createToggle("Team Check", "TeamCheck", nextO()))
addTo("AIM", createToggle("Auto Shoot", "AutoShoot", nextO()))
addTo("AIM", createSlider("FOV", "FOV", 20, 800, nextO()))
addTo("AIM", createToggle("Show FOV", "ShowFOV", nextO()))

addTo("VISUALS", createCategory("PLAYER ESP", nextO()))
addTo("VISUALS", createToggle("ESP", "ESP", nextO()))
addTo("VISUALS", createToggle("Box", "ESPBox", nextO()))
addTo("VISUALS", createToggle("Name", "ESPName", nextO()))
addTo("VISUALS", createToggle("Distance", "ESPDist", nextO()))
addTo("VISUALS", createToggle("Health", "ESPHP", nextO()))
addTo("VISUALS", createSlider("Max Dist", "ESPMaxDist", 50, 5000, nextO()))

addTo("VISUALS", createCategory("WORLD", nextO()))
addTo("VISUALS", createToggle("Fullbright", "Fullbright", nextO(), function(state)
    if state then
        Lighting.Ambient = Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
    else
        Lighting.Ambient = OldLighting.Ambient; Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient
        Lighting.Brightness = OldLighting.Brightness; Lighting.ClockTime = OldLighting.ClockTime
        Lighting.FogEnd = OldLighting.FogEnd; Lighting.GlobalShadows = OldLighting.GlobalShadows
    end
end))
addTo("VISUALS", createToggle("X-Ray", "XRay", nextO()))
addTo("VISUALS", createToggle("No Deco", "NoDeco", nextO()))

addTo("PLAYER", createCategory("PLAYER", nextO()))
addTo("PLAYER", createToggle("Inf Jump", "InfJump", nextO()))
addTo("PLAYER", createToggle("Anti AFK", "AntiAFK", nextO()))
addTo("PLAYER", createToggle("No Fall Damage", "NoFallDamage", nextO()))

addTo("WORLD", createCategory("WORLD", nextO()))
addTo("WORLD", createToggle("No Bullet Drop", "NoBulletDrop", nextO()))
addTo("WORLD", createToggle("Low GFX", "OptLowGFX", nextO()))

-- SILENT AIM CORE
local ignoreFolderNames = {"Viewmodel","ViewModel","Ignore","Debris","BulletTraces","Effects","GunEffects","Arms","FPSArms","Particles","Bullets","Camera"}
local wallRayP = RaycastParams.new(); wallRayP.FilterType = Enum.RaycastFilterType.Exclude; wallRayP.IgnoreWater = true

local function isPartVisible(origin, targetPos, targetChar)
    local il = {}; if LP.Character then il[#il+1] = LP.Character end
    local cam = GetCamera(); if cam then il[#il+1] = cam end
    for i = 1, #ignoreFolderNames do local f = Workspace:FindFirstChild(ignoreFolderNames[i]); if f then il[#il+1] = f end end
    wallRayP.FilterDescendantsInstances = il
    for _ = 1, 4 do
        local dir = targetPos - origin; if dir.Magnitude < 0.5 then return true end
        local r = Workspace:Raycast(origin, dir, wallRayP); if not r then return true end
        if r.Instance:IsDescendantOf(targetChar) then return true end
        if r.Instance:IsA("BasePart") and r.Instance.Transparency >= 0.9 then il[#il+1] = r.Instance; wallRayP.FilterDescendantsInstances = il; continue end
        local hitO = false; for plr in pairs(PlayerCache) do if plr.Character and r.Instance:IsDescendantOf(plr.Character) then il[#il+1] = plr.Character; wallRayP.FilterDescendantsInstances = il; hitO = true; break end end
        if hitO then continue end; return false
    end; return false
end

local function getClosestTarget()
    local cam = GetCamera(); if not cam then return nil end
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); local myPos = myRoot and myRoot.Position
    local center = Vector2.new(cam.ViewportSize.X*0.5, cam.ViewportSize.Y*0.5 + 20)
    local best, bestD = nil, nil
    for pl, data in pairs(PlayerCache) do
        if pl ~= LP then
            local ch = data.Char
            local part = ch and (ch:FindFirstChild(C.AimPart) or ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Head"))
            if part and part.Parent then
                local hum = ch:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 and not (C.TeamCheck and pl.Team == LP.Team) then
                    local pp = part.Position
                    if not myPos or (myPos - pp).Magnitude <= 1000 then
                        local sp, vis = cam:WorldToViewportPoint(pp)
                        if vis then
                            local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if d < C.FOV then
                                if not C.WallCheck or isPartVisible(cam.CFrame.Position, pp, ch) then
                                    if not bestD or d < bestD then best = {part = part, char = ch}; bestD = d end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

-- ХУК RAYCAST
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Raycast" and self == Workspace then
        if not checkcaller() then
            local args = table.pack(...)
            if typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" and C.SilentAim and CurrentAimTarget and CurrentAimTarget.part then
                local mag = args[2].Magnitude
                args[2] = (CurrentAimTarget.part.Position - args[1]).Unit * mag
                return oldNamecall(self, table.unpack(args, 1, args.n))
            end
        end
    end
    return oldNamecall(self, ...)
end))

-- ХУК REMOTE (FUST)
local shootRemotes = {}
local function scanForShootRemotes()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = obj.Name:lower()
            if n:find("fire") or n:find("shoot") or n:find("attack") or n:find("hit") then shootRemotes[obj] = true end
        end
    end
end
scanForShootRemotes()
ReplicatedStorage.DescendantAdded:Connect(function(obj)
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        local n = obj.Name:lower()
        if n:find("fire") or n:find("shoot") or n:find("attack") or n:find("hit") then shootRemotes[obj] = true end
    end
end)

local function hookRemote(remote)
    if remote.ClassName == "RemoteEvent" then
        local oldFire = remote.FireServer
        remote.FireServer = newcclosure(function(self, ...)
            if C.SilentAim and CurrentAimTarget and CurrentAimTarget.part then
                local args = table.pack(...)
                local pos = CurrentAimTarget.part.Position
                local patched = false
                for i = 1, args.n do
                    local v = args[i]
                    if typeof(v) == "Vector3" then args[i] = pos; patched = true
                    elseif typeof(v) == "CFrame" then args[i] = CFrame.new(pos); patched = true
                    elseif typeof(v) == "table" and v.Position then v.Position = pos; patched = true end
                end
                if patched then return oldFire(self, table.unpack(args, 1, args.n)) end
            end
            return oldFire(self, ...)
        end)
    end
end
for remote in pairs(shootRemotes) do pcall(function() hookRemote(remote) end) end

-- ESP
local hasDrawing = pcall(function() local t=Drawing.new("Line"); t:Remove(); return true end)
local ESP = {}
local function removeESP(p) local e=ESP[p]; if e then for _,d in pairs(e) do if d and d.Remove then pcall(function() d:Remove() end) end end; ESP[p]=nil end end
local function createESP(p)
    if p==LP or ESP[p] or not hasDrawing then return end
    local e={}
    local ok=pcall(function()
        e.box={Drawing.new("Line"),Drawing.new("Line"),Drawing.new("Line"),Drawing.new("Line")}
        e.name=Drawing.new("Text"); e.dist=Drawing.new("Text"); e.hpBg=Drawing.new("Line"); e.hpFill=Drawing.new("Line")
    end)
    if not ok then removeESP(p); return end
    for _,l in ipairs(e.box) do l.Thickness=1; l.Color=C.ESPColor; l.Visible=false end
    e.name.Size=13; e.name.Center=true; e.name.Outline=true; e.name.Font=2; e.name.Color=C.ESPColor
    e.dist.Size=11; e.dist.Center=true; e.dist.Outline=true; e.dist.Font=2; e.dist.Color=C.ESPColor
    e.hpBg.Thickness=2; e.hpBg.Visible=false; e.hpFill.Thickness=2; e.hpFill.Visible=false
    ESP[p]=e
end
for _,p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(function(p) task.wait(1); createESP(p) end)
Players.PlayerRemoving:Connect(function(p) removeESP(p) end)

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    local cam = GetCamera(); if not cam then return end
    
    -- ESP
    if hasDrawing then
        for pl, e in pairs(ESP) do
            local char=pl.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
            local draw=false
            if C.ESP and hrp and hum and hum.Health>0 then
                local ps,on=cam:WorldToViewportPoint(hrp.Position)
                local dist = (hrp.Position - cam.CFrame.Position).Magnitude
                if on and dist <= C.ESPMaxDist then
                    draw=true; local sy=4500/ps.Z; local sx=2800/ps.Z; local x,y=ps.X-sx/2,ps.Y-sy/2
                    for i,l in ipairs(e.box) do
                        l.Visible=C.ESPBox; l.Color=C.ESPColor
                        if i==1 then l.From,l.To=Vector2.new(x,y),Vector2.new(x+sx,y)
                        elseif i==2 then l.From,l.To=Vector2.new(x+sx,y),Vector2.new(x+sx,y+sy)
                        elseif i==3 then l.From,l.To=Vector2.new(x+sx,y+sy),Vector2.new(x,y+sy)
                        else l.From,l.To=Vector2.new(x,y+sy),Vector2.new(x,y) end
                    end
                    local hpR=math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
                    e.hpBg.Visible=C.ESPHP; e.hpFill.Visible=C.ESPHP
                    if C.ESPHP then
                        e.hpBg.From,e.hpBg.To=Vector2.new(x-6,y),Vector2.new(x-6,y+sy); e.hpBg.Color=Color3.new(0,0,0)
                        e.hpFill.From,e.hpFill.To=Vector2.new(x-6,y+sy),Vector2.new(x-6,y+sy-sy*hpR); e.hpFill.Color=Color3.fromRGB(255*(1-hpR),255*hpR,60)
                    end
                    e.name.Visible=C.ESPName; if C.ESPName then e.name.Text=pl.DisplayName; e.name.Position=Vector2.new(ps.X,y-16); e.name.Color=C.ESPColor end
                    e.dist.Visible=C.ESPDist; if C.ESPDist then e.dist.Text="["..math.floor(dist).."m]"; e.dist.Position=Vector2.new(ps.X,y+sy+2) end
                end
            end
            if not draw then for _,l in ipairs(e.box) do l.Visible=false end; e.name.Visible=false; e.dist.Visible=false; e.hpBg.Visible=false; e.hpFill.Visible=false end
        end
    end

    -- X-Ray & No Deco (Применяются к Workspace)
    if C.XRay then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and not v:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                v.LocalTransparencyModifier = 0.7
            end
        end
    end
    if C.NoDeco then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:find("Grass") or v.Name:find("Bush") or v.Name:find("Tree") or v.Name:find("Deco")) then
                v.Transparency = 1
            end
        end
    end

    -- Aim
    if C.SilentAim then CurrentAimTarget = getClosestTarget() else CurrentAimTarget = nil end
    if C.OptLowGFX then pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end) end
end)

-- PLAYER LOGIC
UserInputService.JumpRequest:Connect(function() if C.InfJump and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)
task.spawn(function() while true do task.wait(0.2) if C.AntiAFK then pcall(function() local v=game:GetService("VirtualUser"); v:CaptureController(); v:ClickButton2(Vector2.new()) end) end end end)

-- F-BUTTON (Открытие меню)
local OpenBtn = N("TextButton", {Size=UDim2.new(0,36,0,36), Position=UDim2.new(0,12,0.5,-18), BackgroundColor3=Colors.Accent, Text="F", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=16, AutoButtonColor=false, ZIndex=50}, SG)
corner(OpenBtn,18); stroke(OpenBtn, Color3.new(1,1,1), 1, 0.5)
local dragBtn, btnStart, posStart, moved = false, nil, nil, false
OpenBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragBtn=true; moved=false; btnStart=i.Position; posStart=OpenBtn.Position end end)
OpenBtn.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragBtn=false end end)
UserInputService.InputChanged:Connect(function(i) if dragBtn and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-btnStart; if math.abs(d.X)>4 or math.abs(d.Y)>4 then moved=true end; OpenBtn.Position=UDim2.new(posStart.X.Scale,posStart.X.Offset+d.X,posStart.Y.Scale,posStart.Y.Offset+d.Y) end end)
OpenBtn.MouseButton1Click:Connect(function() if moved then moved=false; return end; M.Visible=not M.Visible end)

local mdrag, mds, mdp = false, nil, nil
TitleBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then mdrag=true; mds=i.Position; mdp=M.Position end end)
TitleBar.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then mdrag=false end end)
UserInputService.InputChanged:Connect(function(i) if mdrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-mds; M.Position=UDim2.new(mdp.X.Scale,mdp.X.Offset+d.X,mdp.Y.Scale,mdp.Y.Offset+d.Y) end end)

showTab("AIM")
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title="FerClient v25.0", Text="FUST Edition Loaded", Duration=4}) end)
