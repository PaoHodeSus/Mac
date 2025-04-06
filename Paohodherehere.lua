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
local flying = false
local flySpeed = 50
local bodyVelocity

-- การควบคุม Aim Lock
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
        headLock = true
        print("Aim Lock Enabled")
    else
        headLock = false
        print("Aim Lock Disabled")
    end
end

-- การควบคุมการบิน (สามารถควบคุมทิศทางได้)
game:GetService("RunService").Heartbeat:Connect(function()
    if flyEnabled and flying then
        local direction = Vector3.new()

        -- ควบคุมทิศทางการบินด้วยปุ่มต่าง ๆ
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            direction = direction + character.HumanoidRootPart.CFrame.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            direction = direction - character.HumanoidRootPart.CFrame.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            direction = direction - character.HumanoidRootPart.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            direction = direction + character.HumanoidRootPart.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)  -- ขึ้น
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)  -- ลง
        end

        -- อัปเดต BodyVelocity ตามทิศทางที่ผู้เล่นควบคุม
        bodyVelocity.Velocity = direction.Unit * flySpeed
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
