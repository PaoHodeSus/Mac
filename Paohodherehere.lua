-- ตัวแปรสำหรับควบคุมฟังก์ชัน
local autoFarmEnabled = false
local flyEnabled = false
local walkSpeedEnabled = false
local aimLockEnabled = false

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local mouse = player:GetMouse()

-- การควบคุม Walk Speed
local defaultWalkSpeed = humanoid.WalkSpeed
local walkSpeedValue = 100 -- เปลี่ยนเป็นความเร็วที่ต้องการ

-- การควบคุม Fly
local flyingPart
local flying = false
local flySpeed = 50
local bodyVelocity

-- การควบคุม Aim Lock
local aimLockPart
local headLock = false

-- ฟังก์ชันเปิด/ปิด Auto Farm
local function toggleAutoFarm()
    autoFarmEnabled = not autoFarmEnabled
    print("Auto Farm: " .. tostring(autoFarmEnabled))
end

-- ฟังก์ชันเปิด/ปิด Fly
local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        -- เริ่มการบิน
        flyingPart = Instance.new("Part")
        flyingPart.Size = Vector3.new(2, 2, 2)
        flyingPart.Position = character.HumanoidRootPart.Position
        flyingPart.Anchored = false
        flyingPart.CanCollide = false
        flyingPart.Parent = game.Workspace
        flyingPart.CFrame = character.HumanoidRootPart.CFrame
        
        -- เพิ่ม BodyVelocity เพื่อควบคุมการบิน
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
        bodyVelocity.Parent = character.HumanoidRootPart
        
        humanoid.PlatformStand = true
        flying = true
        print("Fly Enabled")
    else
        -- ยกเลิกการบิน
        if flyingPart then
            flyingPart:Destroy()
        end
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        humanoid.PlatformStand = false
        flying = false
        print("Fly Disabled")
    end
end

-- ฟังก์ชันเปิด/ปิด Walk Speed
local function toggleWalkSpeed()
    walkSpeedEnabled = not walkSpeedEnabled
    if walkSpeedEnabled then
        humanoid.WalkSpeed = walkSpeedValue
        print("Walk Speed: " .. walkSpeedValue)
    else
        humanoid.WalkSpeed = defaultWalkSpeed
        print("Walk Speed Reset")
    end
end

-- ฟังก์ชันเปิด/ปิด Aim Lock (Head Lock)
local function toggleAimLock()
    aimLockEnabled = not aimLockEnabled
    if aimLockEnabled then
        aimLockPart = Instance.new("Part")
        aimLockPart.Size = Vector3.new(1, 1, 1)
        aimLockPart.Position = character.Head.Position
        aimLockPart.Anchored = true
        aimLockPart.CanCollide = false
        aimLockPart.Parent = game.Workspace
        headLock = true
        print("Aim Lock Enabled")
    else
        if aimLockPart then
            aimLockPart:Destroy()
        end
        headLock = false
        print("Aim Lock Disabled")
    end
end

-- การควบคุมการบิน
game:GetService("RunService").Heartbeat:Connect(function()
    if flyEnabled and flying then
        -- เคลื่อนที่บิน
        bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
    end
end)

-- การล็อคหัว
game:GetService("RunService").Heartbeat:Connect(function()
    if aimLockEnabled and headLock then
        -- ล็อคมุมมองที่หัว
        local headPosition = character.Head.Position
        local targetPosition = mouse.Hit.p
        local direction = (targetPosition - headPosition).unit
        character:SetPrimaryPartCFrame(CFrame.new(headPosition, headPosition + direction))
    end
end)

-- คำสั่งเปิด/ปิดฟังก์ชันต่าง ๆ โดยการกดปุ่ม
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.F then
        toggleAutoFarm()
    elseif input.KeyCode == Enum.KeyCode.G then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.H then
        toggleWalkSpeed()
    elseif input.KeyCode == Enum.KeyCode.J then
        toggleAimLock()
    end
end)
