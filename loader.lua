local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

local Config = {
    MaxDist = 1000,
    Color = Color3.fromRGB(150, 80, 255)
}

local ESP = {}

local function CreateESP(pl)
    if pl == LP or ESP[pl] then return end
    local e = {}
    
    -- Рисуем бокс 4 линиями (самый совместимый метод для Delta)
    e.b1 = Drawing.new("Line")
    e.b2 = Drawing.new("Line")
    e.b3 = Drawing.new("Line")
    e.b4 = Drawing.new("Line")
    
    e.dist = Drawing.new("Text")
    e.dist.Size = 14
    e.dist.Center = true
    e.dist.Outline = true
    e.dist.Color = Color3.new(1,1,1)

    e.hpBg = Drawing.new("Line")
    e.hpBg.Thickness = 3
    e.hpBg.Color = Color3.new(0,0,0)
    
    e.hpFill = Drawing.new("Line")
    e.hpFill.Thickness = 3
    
    ESP[pl] = e
end

local function RemoveESP(pl)
    if ESP[pl] then
        local e = ESP[pl]
        if e.b1 then e.b1:Remove() end
        if e.b2 then e.b2:Remove() end
        if e.b3 then e.b3:Remove() end
        if e.b4 then e.b4:Remove() end
        if e.dist then e.dist:Remove() end
        if e.hpBg then e.hpBg:Remove() end
        if e.hpFill then e.hpFill:Remove() end
        ESP[pl] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(function(p) task.wait(1); CreateESP(p) end)
Players.PlayerRemoving:Connect(RemoveESP)

local renderAccumulator = 0
RunService.RenderStepped:Connect(function(dt)
    renderAccumulator = renderAccumulator + dt
    if renderAccumulator < (1 / 30) then return end
    renderAccumulator = 0

    local cam = Workspace.CurrentCamera
    if not cam then return end

    for pl, e in pairs(ESP) do
        local char = pl.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")

        if hum and hum.Health > 0 and hrp and head then
            local headPos, onScreen = cam:WorldToViewportPoint(head.Position)
            local rootPos = cam:WorldToViewportPoint(hrp.Position)
            local dist = (rootPos - cam.CFrame.Position).Magnitude
            
            if onScreen and dist <= Config.MaxDist then
                local height = math.abs(headPos.Y - rootPos.Y) * 1.5
                local width = height / 2
                local x, y = rootPos.X - width / 2, rootPos.Y - height / 2
                
                -- Линии бокса (Левый верх, Правый верх, Правый низ, Левый низ)
                e.b1.Visible = true
                e.b1.From = Vector2.new(x, y)
                e.b1.To = Vector2.new(x + width, y)
                e.b1.Color = Config.Color
                
                e.b2.Visible = true
                e.b2.From = Vector2.new(x + width, y)
                e.b2.To = Vector2.new(x + width, y + height)
                e.b2.Color = Config.Color
                
                e.b3.Visible = true
                e.b3.From = Vector2.new(x + width, y + height)
                e.b3.To = Vector2.new(x, y + height)
                e.b3.Color = Config.Color
                
                e.b4.Visible = true
                e.b4.From = Vector2.new(x, y + height)
                e.b4.To = Vector2.new(x, y)
                e.b4.Color = Config.Color

                -- Дистанция
                e.dist.Visible = true
                e.dist.Text = "[" .. math.floor(dist) .. "m]"
                e.dist.Position = Vector2.new(rootPos.X, y + height + 2)

                -- Здоровье (ХП)
                local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                
                e.hpBg.Visible = true
                e.hpBg.From = Vector2.new(x - 6, y)
                e.hpBg.To = Vector2.new(x - 6, y + height)
                
                e.hpFill.Visible = true
                e.hpFill.From = Vector2.new(x - 6, y + height)
                e.hpFill.To = Vector2.new(x - 6, y + height - (height * hpPercent))
                e.hpFill.Color = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0)
            else
                e.b1.Visible = false
                e.b2.Visible = false
                e.b3.Visible = false
                e.b4.Visible = false
                e.dist.Visible = false
                e.hpBg.Visible = false
                e.hpFill.Visible = false
            end
        else
            if e.b1 then
                e.b1.Visible = false
                e.b2.Visible = false
                e.b3.Visible = false
                e.b4.Visible = false
                e.dist.Visible = false
                e.hpBg.Visible = false
                e.hpFill.Visible = false
            end
        end
    end
end)
