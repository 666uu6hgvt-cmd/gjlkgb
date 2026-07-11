-- 🚀 سكربت جعفر الطيار - نسخة الموبايل V8.6 - المصلحة بالكامل 2026 🚀
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- بيئة الحقن الآمنة
local targetParent = nil
local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
if success and coreGui then
    targetParent = coreGui
else
    targetParent = localPlayer:WaitForChild("PlayerGui")
end

-- تنظيف النسخ القديمة
local guiName = "JaafarTikTok_ProShield_V8"
if targetParent:FindFirstChild(guiName) then
    targetParent[guiName]:Destroy()
end

-- الواجهة المحمية الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = targetParent

-------------------------------
-- [1] الواجهة المستطيلة (تم إصلاح خطأ الـ Parent هنا)
-------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 260)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = screenGui -- تم التعديل والإصلاح

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- العنوان الكروما
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🚀 من صنع جعفر الطيار 🚀"
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Active = true
titleLabel.Parent = mainFrame

-------------------------------
-- [2] زر الفتح والإغلاق العائم
-------------------------------
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 15, 0, 15)
toggleButton.Text = "⚡"
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Active = true
toggleButton.Parent = screenGui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = toggleButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Thickness = 3
buttonStroke.Parent = toggleButton

-------------------------------
-- نظام السحب والتحريك للموبايل
-------------------------------
local dragInput, dragStart
local dragButtonActive = false
local startPosButton

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragButtonActive = true
        dragStart = input.Position
        startPosButton = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragButtonActive = false end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

local dragMainActive = false
local startPosMain
titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragMainActive = true
        dragStart = input.Position
        startPosMain = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragMainActive = false end
        end)
    end
end)

titleLabel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then
        local delta = input.Position - dragStart
        if dragButtonActive then
            toggleButton.Position = UDim2.new(startPosButton.X.Scale, startPosButton.X.Offset + delta.X, startPosButton.Y.Scale, startPosButton.Y.Offset + delta.Y)
        elseif dragMainActive then
            mainFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
        end
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 0.003) % 1
    local rainbowColor = Color3.fromHSV(hue, 1, 1)
    titleLabel.TextColor3 = rainbowColor
    toggleButton.BackgroundColor3 = rainbowColor
    buttonStroke.Color = Color3.fromHSV((hue + 0.5) % 1, 1, 1)
end)

-------------------------------
-- [3] قائمة التمرير (Scrolling)
-------------------------------
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -55)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrollFrame

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 15)
end)

-------------------------------
-- [4] دالة صنع الخيارات
-------------------------------
local function createFeatureOption(name, order, minVal, maxVal, defaultVal, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -5, 0, 45)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.Parent = scrollFrame

    local checkBox = Instance.new("TextButton")
    checkBox.Size = UDim2.new(0, 35, 0, 35)
    checkBox.Position = UDim2.new(0, 5, 0, 5)
    checkBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    checkBox.Text = "⬜"
    checkBox.TextScaled = true
    checkBox.Parent = row
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = checkBox

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0.18, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSansBold
    label.Parent = row

    local currentVal = defaultVal
    local valueLabel
    
    if minVal and maxVal then
        local minusBtn = Instance.new("TextButton")
        minusBtn.Size = UDim2.new(0, 35, 0, 25)
        minusBtn.Position = UDim2.new(0.60, 0, 0.22, 0)
        minusBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        minusBtn.Text = "-"
        minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        minusBtn.TextScaled = true
        minusBtn.Parent = row
        Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 4)

        valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 40, 0, 25)
        valueLabel.Position = UDim2.new(0.72, 0, 0.22, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(currentVal)
        valueLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        valueLabel.TextScaled = true
        valueLabel.Font = Enum.Font.SourceSansBold
        valueLabel.Parent = row

        local plusBtn = Instance.new("TextButton")
        plusBtn.Size = UDim2.new(0, 35, 0, 25)
        plusBtn.Position = UDim2.new(0.86, 0, 0.22, 0)
        plusBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        plusBtn.Text = "+"
        plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        plusBtn.TextScaled = true
        plusBtn.Parent = row
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 4)

        minusBtn.MouseButton1Click:Connect(function()
            if currentVal > minVal then
                currentVal = currentVal - 5
                if currentVal < minVal then currentVal = minVal end
                valueLabel.Text = tostring(currentVal)
                callback(checkBox.Text == "✅", currentVal)
            end
        end)

        plusBtn.MouseButton1Click:Connect(function()
            if currentVal < maxVal then
                currentVal = currentVal + 5
                if currentVal > maxVal then currentVal = maxVal end
                valueLabel.Text = tostring(currentVal)
                callback(checkBox.Text == "✅", currentVal)
            end
        end)
    end

    local isActive = false
    checkBox.MouseButton1Click:Connect(function()
        isActive = not isActive
        checkBox.Text = isActive and "✅" or "⬜"
        callback(isActive, currentVal)
    end)

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    line.Parent = row
end

-------------------------------
-- [5] تفعيل الأوامر
-------------------------------

-- 1. الطيران
local flying = false
local flySpeed = 50
local flyBV = nil
local flyBG = nil

local function startFlying()
    local char = localPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = true
        flyBV = Instance.new("BodyVelocity")
        flyBV.Name = "JaafarFlyBV"
        flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = char.HumanoidRootPart
        
        flyBG = Instance.new("BodyGyro")
        flyBG.Name = "JaafarFlyBG"
        flyBG.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBG.CFrame = char.HumanoidRootPart.CFrame
        flyBG.Parent = char.HumanoidRootPart
    end
end

local function stopFlying()
    flying = false
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.PlatformStand = false
        localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

createFeatureOption("✈️ طيران عمودي مع الكاميرا", 1, 10, 250, 50, function(active, val)
    flySpeed = val
    if active then stopFlying() flying = true startFlying() else stopFlying() end
end)

RunService.RenderStepped:Connect(function()
    if flying then
        local char = localPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
            if not flyBV or not flyBG then startFlying() end
            local moveDir = char.Humanoid.MoveDirection
            flyBG.CFrame = camera.CFrame
            if moveDir.Magnitude > 0 then
                local cameraLook = camera.CFrame.LookVector
                local finalVelocity = (moveDir + Vector3.new(0, cameraLook.Y * 1.5, 0)).Unit * flySpeed
                flyBV.Velocity = finalVelocity
            else
                flyBV.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- 2. اختراق الجدران
local noclipActive = false
createFeatureOption("🧱 اختراق جدران (Noclip)", 2, nil, nil, nil, function(active)
    noclipActive = active
end)

RunService.Stepped:Connect(function()
    if noclipActive and localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- 3. سرعة الجري
local speedActive = false
local targetSpeed = 16
createFeatureOption("⚡ سرعة الجري", 3, 16, 300, 16, function(active, val)
    speedActive = active targetSpeed = val
    if not active and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then localPlayer.Character.Humanoid.WalkSpeed = 16 end
end)

RunService.RenderStepped:Connect(function()
    if speedActive and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then localPlayer.Character.Humanoid.WalkSpeed = targetSpeed end
end)

-- 4. قفز لا نهائي
local infiniteJumpActive = false
createFeatureOption("⬆️ قفز لا نهائي", 4, nil, nil, nil, function(active) infiniteJumpActive = active end)
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpActive and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- 5. مانع ضرب
local antiPunchActive = false
createFeatureOption("🛡️ مانع ضرب (حماية كاملة)", 5, nil, nil, nil, function(active)
    antiPunchActive = active
end)

RunService.Stepped:Connect(function()
    if antiPunchActive and localPlayer.Character then
        local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum:GetState() == Enum.HumanoidStateType.Physics or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        for _, part in pairs(localPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end)

-- 6. ميزة الفلينج (Fling) المحدثة بالكامل مع عداد السرعة
local touchFlingActive = false
local flingSpeed = 99999 -- سرعة الدوران الافتراضية للـ RotVelocity

-- تم تمرير القيم هنا لكي تظهر الأزرار الحمراء والخضراء تلقائياً (+ و -)
createFeatureOption("💥 بلمسة يطير اللاعب (Fling)", 99999, 20000, 1000, 6, function(active, val)
    touchFlingActive = active
    flingSpeed = val -- تحديث السرعة المتغيرة بناءً على العداد
end)

RunService.PostSimulation:Connect(function()
    if touchFlingActive and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = localPlayer.Character.HumanoidRootPart
        for _, part in pairs(localPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        root.TrackedVelocity = Vector3.new(0, 300, 0)
        
        -- تطبيق قيمة سرعة الدوران المتغيرة التي تختارها من العداد
        root.RotVelocity = Vector3.new(0, flingSpeed, 0)
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = p.Character.HumanoidRootPart
                local dist = (root.Position - targetRoot.Position).Magnitude
                if dist < 5 then
                    targetRoot.Velocity = Vector3.new(math.random(-500, 500), 40000, math.random(-500, 500))
                    targetRoot.RotVelocity = Vector3.new(5000, 5000, 5000)
                end
            end
        end
    end
end)

-- 7. أداة التنقل
local tpToolActive = false
local function giveTpTool()
    local backpack = localPlayer:WaitForChild("Backpack", 2)
    if tpToolActive and backpack then
        if backpack:FindFirstChild("Jaafar TP Tool") or (localPlayer.Character and localPlayer.Character:FindFirstChild("Jaafar TP Tool")) then return end
        local tool = Instance.new("Tool")
        tool.Name = "Jaafar TP Tool"
        tool.RequiresHandle = true
        local handle = Instance.new("Part")
        handle.Name = "Handle" handle.Size = Vector3.new(1, 2, 1) handle.BrickColor = BrickColor.new("Neon cyan") handle.Parent = tool
        tool.Activated:Connect(function()
            local mouse = localPlayer:GetMouse()
            if mouse.Target and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) end
        end)
        tool.Parent = backpack
    end
end

createFeatureOption("📍 أداة تنقل باليد", 7, nil, nil, nil, function(active)
    tpToolActive = active
    if active then giveTpTool() else
        if localPlayer.Backpack:FindFirstChild("Jaafar TP Tool") then localPlayer.Backpack["Jaafar TP Tool"]:Destroy() end
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Jaafar TP Tool") then localPlayer.Character["Jaafar TP Tool"]:Destroy() end
    end
end)

-- 8. كشف الاسماء
local espActive = false
createFeatureOption("👁️ كشف واسماء اللاعبين فوق الرأس", 8, nil, nil, nil, function(active)
    espActive = active
    if not active then
        for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("JaafarESP") then p.Character.JaafarESP:Destroy() end end
    end
end)

RunService.RenderStepped:Connect(function()
    if not espActive then return end
    local myChar = localPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local distance = math.floor((myChar.HumanoidRootPart.Position - p.Character.Head.Position).Magnitude)
            local folder = p.Character:FindFirstChild("JaafarESP")
            if not folder then
                folder = Instance.new("Folder", p.Character)
                folder.Name = "JaafarESP"
                local box = Instance.new("BoxHandleAdornment", folder)
                box.Name = "Box" box.Size = Vector3.new(4, 6, 4) box.Color3 = Color3.fromRGB(0, 255, 255) box.AlwaysOnTop = true box.ZIndex = 5 box.Adornee = p.Character box.Transparency = 0.7
                local bb = Instance.new("BillboardGui", folder)
                bb.Name = "NameGui" bb.Size = UDim2.new(0, 160, 0, 40) bb.AlwaysOnTop = true bb.Adornee = p.Character:FindFirstChild("Head") bb.ExtentsOffset = Vector3.new(0, 3, 0)
                local text = Instance.new("TextLabel", bb)
                text.Name = "EspText" text.Size = UDim2.new(1, 0, 1, 0) text.BackgroundTransparency = 1 text.Text = p.Name .. " [" .. tostring(distance) .. "m]" text.TextColor3 = Color3.fromRGB(255, 255, 0) text.TextScaled = true text.Font = Enum.Font.SourceSansBold
            else
                if folder:FindFirstChild("NameGui") and folder.NameGui:FindFirstChild("EspText") then
                    folder.NameGui.EspText.Text = p.Name .. " [" .. tostring(distance) .. "m]"
                end
            end
        end
    end
end)

-- 9. نظام الأيم بوت المطور للموبايل (تم إصلاح خطأ الـ Drawing الحصري للكمبيوتر)
local aimbotActive = false
local aimbotFOV = 150
local selectedTargetPlayer = nil

-- استخدام واجهة موبايل عادية بدلاً من Drawing المكتبية المحظورة
local mobileFovFrame = Instance.new("Frame")
mobileFovFrame.Size = UDim2.new(0, aimbotFOV * 2, 0, aimbotFOV * 2)
mobileFovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mobileFovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mobileFovFrame.BackgroundTransparency = 1
mobileFovFrame.Visible = false
mobileFovFrame.Parent = screenGui

local fovUiCorner = Instance.new("UICorner")
fovUiCorner.CornerRadius = UDim.new(1, 0)
fovUiCorner.Parent = mobileFovFrame

local fovStroke = Instance.new("UIStroke")
fovStroke.Thickness = 2
fovStroke.Color = Color3.fromRGB(255, 0, 128)
fovStroke.Parent = mobileFovFrame

createFeatureOption("🎯 أيم بوت (دائرة منتصف الشاشة)", 9, 50, 400, 150, function(active, val)
    aimbotActive = active 
    aimbotFOV = val 
    mobileFovFrame.Size = UDim2.new(0, val * 2, 0, val * 2)
    mobileFovFrame.Visible = active
end)

local function getClosestPlayerToCenter()
    local closestPlayer = nil local shortestDistance = aimbotFOV local centerScreen = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
                if distance < shortestDistance then shortestDistance = distance closestPlayer = p end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if not aimbotActive then return end
    local target = selectedTargetPlayer
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") or target.Character.Humanoid.Health <= 0 then target = getClosestPlayerToCenter() end
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position) end
end)


-------------------------------
-- [6] قائمة استهداف لاعب معين
-------------------------------
local playerListLabel = Instance.new("TextLabel")
playerListLabel.Size = UDim2.new(1, -10, 0, 25) playerListLabel.BackgroundTransparency = 1 playerListLabel.Text = "🎯 استهداف لاعب معين:" playerListLabel.TextColor3 = Color3.fromRGB(0, 255, 100) playerListLabel.TextScaled = true playerListLabel.Font = Enum.Font.SourceSansBold playerListLabel.LayoutOrder = 11 playerListLabel.Parent = scrollFrame

local pListFrame = Instance.new("Frame")
pListFrame.Size = UDim2.new(1, -10, 0, 80) pListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) pListFrame.LayoutOrder = 12 pListFrame.Parent = scrollFrame

local pScroll = Instance.new("ScrollingFrame")
pScroll.Size = UDim2.new(1, 0, 1, 0) pScroll.BackgroundTransparency = 1 pScroll.ScrollBarThickness = 4 pScroll.Parent = pListFrame

local pListLayout = Instance.new("UIListLayout")
pListLayout.SortOrder = Enum.SortOrder.LayoutOrder pListLayout.Parent = pScroll

local function updatePlayerList()
    for _, child in pairs(pScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    local allBtn = Instance.new("TextButton", pScroll)
    allBtn.Size = UDim2.new(1, 0, 0, 22) allBtn.BackgroundColor3 = selectedTargetPlayer == nil and Color3.fromRGB(128, 0, 128) or Color3.fromRGB(35, 35, 35) allBtn.Text = "🎯 استهداف تلقائي" allBtn.TextColor3 = Color3.fromRGB(255, 255, 255) allBtn.TextScaled = true
    allBtn.MouseButton1Click:Connect(function() selectedTargetPlayer = nil updatePlayerList() end)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            local pBtn = Instance.new("TextButton", pScroll)
            pBtn.Size = UDim2.new(1, 0, 0, 22) pBtn.BackgroundColor3 = selectedTargetPlayer == p and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 45) pBtn.Text = p.Name pBtn.TextColor3 = Color3.fromRGB(255, 255, 255) pBtn.TextScaled = true
            pBtn.MouseButton1Click:Connect(function() selectedTargetPlayer = p updatePlayerList() end)
        end
    end
    pScroll.CanvasSize = UDim2.new(0, 0, 0, pListLayout.AbsoluteContentSize.Y + 10)
end

Players.PlayerAdded:Connect(updatePlayerList) Players.PlayerRemoving:Connect(updatePlayerList) updatePlayerList()
localPlayer.CharacterAdded:Connect(function(char) stopFlying() end)
localPlayer.CharacterAdded:Connect(function() if tpToolActive then task.wait(0.4) giveTpTool() end end)
local TeleportService = game:GetService("TeleportService")

-- [10] نظام التنقل بين السيرفرات
local serverCode = ""

local function addServerTools()
    -- زر نسخ الكود الحالي
    local copyBtn = Instance.new("TextButton", scrollFrame)
    copyBtn.Size = UDim2.new(1, -10, 0, 40)
    copyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    copyBtn.Text = "📋 نسخ كود السيرفر الحالي"
    copyBtn.TextColor3 = Color3.new(1, 1, 1)
    copyBtn.Font = Enum.Font.SourceSansBold
    
    copyBtn.MouseButton1Click:Connect(function()
        local jobId = game.JobId
        if jobId ~= "" then
            setclipboard(jobId) -- استخدام دالة النسخ
            copyBtn.Text = "✅ تم النسخ!"
            task.wait(2)
            copyBtn.Text = "📋 نسخ كود السيرفر الحالي"
        end
    end)

    -- خانة إدخال الكود
    local codeInput = Instance.new("TextBox", scrollFrame)
    codeInput.Size = UDim2.new(1, -10, 0, 40)
    codeInput.PlaceholderText = "ضع كود السيرفر هنا..."
    codeInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    codeInput.TextColor3 = Color3.new(1, 1, 1)
    codeInput.Text = ""

    -- زر الدخول للسيرفر
    local joinBtn = Instance.new("TextButton", scrollFrame)
    joinBtn.Size = UDim2.new(1, -10, 0, 40)
    joinBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    joinBtn.Text = "🚀 الدخول للسيرفر"
    joinBtn.TextColor3 = Color3.new(1, 1, 1)
    joinBtn.Font = Enum.Font.SourceSansBold
    
    joinBtn.MouseButton1Click:Connect(function()
        local inputCode = codeInput.Text
        if inputCode ~= "" then
            -- التنقل للسيرفر باستخدام الـ JobId
            TeleportService:TeleportToPlaceInstance(game.PlaceId, inputCode, localPlayer)
        end
    end)
end

-- استدعاء الدالة داخل السكربت الخاص بك
addServerTools()
