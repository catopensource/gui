-- catopensource

local library = {}

function library.window(title)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")

    local lp = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CatOS_GUI"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = lp:WaitForChild("PlayerGui")

    local win = Instance.new("Frame")
    win.Size = UDim2.new(0, 300, 0, 400)
    win.Position = UDim2.new(0.5, -150, 0.5, -200)
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    win.Active = true
    win.Draggable = true
    win.Parent = screenGui

    local titleBar = Instance.new("TextLabel", win)
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.TextColor3 = Color3.new(1, 1, 1)
    titleBar.Text = title or "Window"
    titleBar.TextScaled = true
    titleBar.Font = Enum.Font.SourceSansSemibold
    titleBar.TextStrokeTransparency = 0.8

    local tabButtons = Instance.new("Frame", win)
    tabButtons.Size = UDim2.new(1, 0, 0, 20)
    tabButtons.Position = UDim2.new(0, 0, 0, 30)
    tabButtons.BackgroundTransparency = 1
    local buttonLayout = Instance.new("UIListLayout", tabButtons)
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonLayout.Padding = UDim.new(0, 2)

    local content = Instance.new("Frame", win)
    content.Size = UDim2.new(1, 0, 1, -50)
    content.Position = UDim2.new(0, 0, 0, 50)
    content.BackgroundTransparency = 1

    local tabs = {}
    local firstTab = true

    local window = {}

    function window:tab(name)
        local tabFrame = Instance.new("Frame", content)
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabs[name] = tabFrame

        local btn = Instance.new("TextButton", tabButtons)
        btn.Size = UDim2.new(0, 100, 1, 0)
        btn.AutoButtonColor = true
        btn.Text = name
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextScaled = true
        btn.LayoutOrder = #tabButtons:GetChildren()

        btn.MouseButton1Click:Connect(function()
            for _, f in pairs(tabs) do
                f.Visible = false
            end
            tabFrame.Visible = true
        end)

        if firstTab then
            firstTab = false
            tabFrame.Visible = true
        end

        local tabObj = {}

        function tabObj:button(label, callback)
            local b = Instance.new("TextButton", tabFrame)
            b.Size = UDim2.new(1, -10, 0, 30)
            b.Position = UDim2.new(0, 5, 0, #tabFrame:GetChildren() * 35)
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Text = label
            b.Font = Enum.Font.SourceSans
            b.MouseButton1Click:Connect(callback or function() end)
            return b
        end

        function tabObj:toggle(label, default, callback)
            local idx = #tabFrame:GetChildren()
            local frame = Instance.new("Frame", tabFrame)
            frame.Size = UDim2.new(1, -10, 0, 30)
            frame.Position = UDim2.new(0, 5, 0, idx * 35)
            frame.BackgroundTransparency = 1

            local txt = Instance.new("TextLabel", frame)
            txt.Size = UDim2.new(0.7, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.TextColor3 = Color3.new(1, 1, 1)
            txt.Text = label
            txt.TextXAlignment = Enum.TextXAlignment.Left
            txt.Font = Enum.Font.SourceSans

            local tog = Instance.new("TextButton", frame)
            tog.Size = UDim2.new(0.3, -5, 1, 0)
            tog.Position = UDim2.new(0.7, 5, 0, 0)
            tog.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            tog.TextColor3 = Color3.new(1, 1, 1)
            tog.Text = default and "ON" or "OFF"
            tog.Font = Enum.Font.SourceSans
            local state = default
            tog.MouseButton1Click:Connect(function()
                state = not state
                tog.Text = state and "ON" or "OFF"
                if callback then
                    callback(state)
                end
            end)
            return tog
        end

        function tabObj:slider(label, min, max, default, callback)
            local idx = #tabFrame:GetChildren()
            local frame = Instance.new("Frame", tabFrame)
            frame.Size = UDim2.new(1, -10, 0, 40)
            frame.Position = UDim2.new(0, 5, 0, idx * 45)
            frame.BackgroundTransparency = 1

            local txt = Instance.new("TextLabel", frame)
            txt.Size = UDim2.new(1, 0, 0, 20)
            txt.BackgroundTransparency = 1
            txt.TextColor3 = Color3.new(1, 1, 1)
            txt.Text = label
            txt.TextXAlignment = Enum.TextXAlignment.Left
            txt.Font = Enum.Font.SourceSans

            local slider = Instance.new("TextButton", frame)
            slider.Size = UDim2.new(1, 0, 0, 20)
            slider.Position = UDim2.new(0, 0, 0, 20)
            slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            slider.AutoButtonColor = false

            local fill = Instance.new("Frame", slider)
            local frac = (default - min) / (max - min)
            fill.Size = UDim2.new(frac, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

            local dragging = false
            slider.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or
                   inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            slider.InputChanged:Connect(function(inp)
                if dragging and
                   (inp.UserInputType == Enum.UserInputType.MouseMovement or
                    inp.UserInputType == Enum.UserInputType.Touch) then
                    local x = inp.Position.X - slider.AbsolutePosition.X
                    local f = math.clamp(x / slider.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(f, 0, 1, 0)
                    local val = min + f * (max - min)
                    if callback then callback(val) end
                end
            end)
            slider.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or
                   inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            return slider
        end

        return tabObj
    end

    return window
end

return library
