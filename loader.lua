--[[ FUST | Ultra-Light ESP (Box, HP, Dist) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- НАСТРОЙКИ
local Config = {
    MaxDist = 1000,
    Color = Color3.fromRGB(150, 80, 255) -- Фиолетовый
}

local hasDrawing = pcall(function() local t = Drawing.new("Text"); t:Remove(); return true end)
if not hasDrawing then return print("[-] Drawing API не поддерживается") end

local ESP = {}

local function CreateESP(pl)
    if pl == LP or ESP[pl] then return end
    local e = {}
    
    e.Box = Drawing.new("Square")
    e.Box.Thickness = 1
    e.Box.Color = Config.Color
    e.Box.Filled = false
    
    e.Dist = Drawing.new("Text")
    e.Dist.Size = 12
    e.Dist.Center = true
    e.Dist.Outline = true
    e.Dist.Color = Color3.new(1,1,1)

    e.HP = Drawing.new("Line")
    e.HP.Thickness = 2
    
    ESP[pl] = e
end

local function RemoveESP(pl)
    if ESP[pl] then
        for _, obj in pairs(ESP[pl]) do
            if obj and obj.Remove then pcall(function() obj:Remove() end) end
        end
        ESP[pl] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(function(p) task.wait(1); CreateESP(p) end)
Players.PlayerRemoving:Connect(RemoveESP)

-- Отрисовка (Ограничено 30 FPS для мобилок)
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
                -- Размеры бокса
                local height = math.abs(headPos.Y - rootPos.Y) * 1.5
                local width = height / 2
                local x, y = rootPos.X - width / 2, rootPos.Y - height / 2

                e.Box.Visible = true
                e.Box.Size = Vector2.new(width, height)
                e.Box.Position = Vector2.new(x, y)

                e.Dist.Visible = true
                e.Dist.Text = "[" .. math.floor(dist) .. "m]"
                e.Dist.Position = Vector2.new(rootPos.X, y + height + 2)

                e.HP.Visible = true
                local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                e.HP.From = Vector2.new(x - 5, y + height)
                e.HP.To = Vector2.new(x - 5, y + height - (height * hpPercent))
                e.HP.Color = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0)
            else
                e.Box.Visible = false
                e.Dist.Visible = false
                e.HP.Visible = false
            end
        else
            if e.Box then
                e.Box.Visible = false
                e.Dist.Visible = false
                e.HP.Visible = false
            end
        end
    end
end)
