-- ตัวแปรสำหรับควบคุมฟังก์ชัน
local flyEnabled = false

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local mouse = player:GetMouse()

-- การควบคุม Fly
local flying = false
local flySpeed = 50
local bodyVelocity

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

-- คำสั่งเปิด/ปิด Fly โดยการกดปุ่ม
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.G then
        toggleFly()
    end
end)
