-- catopensource

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local library = {}

function library.window(title)
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "CatOS_GUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 350, 0, 400)
    main.Position = UDim2.new(0.5, -175, 0.5, -200)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.Active = true
    main.Draggable = true
    main.Parent = gui

    local mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, 8)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(40, 40, 40)
    mainStroke.Thickness = 1

    -- fade in
    main.BackgroundTransparency = 1
    TweenService:Create(main, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

    local titleLabel = Instance.new("TextLabel", main)
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Window"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Position = UDim2.new(0, 10, 0, 0)

    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(1, 0, 0, 25)
    tabBar.Position = UDim2.new(0, 0, 0, 30)
    tabBar.BackgroundTransparency = 1
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, 0, 1, -55)
    content.Position = UDim2.new(0, 0, 0, 55)
    content.BackgroundTransparency = 1

    local tabs = {}
    local first = true

    local window = {}

    function window:tab(name)
        local frame = Instance.new("ScrollingFrame", content)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.CanvasSize = UDim2.new(0, 0, 1, 0)
        frame.ScrollBarThickness = 4
        frame.Visible = false
        frame.BorderSizePixel = 0

        local layout = Instance.new("UIListLayout", frame)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        tabs[name] = frame

        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0, 100, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = name
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 5)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(tabs) do
                v.Visible = false
            end
            frame.Visible = true
        end)

        if first then
            first = false
            frame.Visible = true
        end

        local tabObj = {}

        function tabObj:button(text, onClick)
            local b = Instance.new("TextButton", frame)
            b.Size = UDim2.new(1, -20, 0, 30)
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            b.Text = text
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.AutoButtonColor = false
            local corner = Instance.new("UICorner", b)
            corner.CornerRadius = UDim.new(0, 4)
            b.MouseEnter:Connect(function()
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}):Play()
            end)
            b.MouseLeave:Connect(function()
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end)
            b.MouseButton1Click:Connect(function()
                if onClick then
                    onClick()
                end
            end)
            return b
        end

        function tabObj:toggle(text, initial, callback)
            local holder = Instance.new("Frame", frame)
            holder.Size = UDim2.new(1, -20, 0, 30)
            holder.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", holder)
            label.Size = UDim2.new(0.6, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left

            local switch = Instance.new("Frame", holder)
            switch.Size = UDim2.new(0.3, -4, 0, 20)
            switch.Position = UDim2.new(0.7, 0, 0.5, -10)
            switch.BackgroundColor3 = initial and Color3.new(1, 1, 1) or Color3.fromRGB(100, 100, 100)
            local swCorner = Instance.new("UICorner", switch)
            swCorner.CornerRadius = UDim.new(1, 0)
            local circle = Instance.new("Frame", switch)
            circle.Size = UDim2.new(0, 16, 0, 16)
            circle.Position = UDim2.new(initial and 1 or 0, 2, 0.5, -8)
            circle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            local cCorner = Instance.new("UICorner", circle)
            cCorner.CornerRadius = UDim.new(1, 0)

            local state = initial
            local function flip()
                state = not state
                local targetColor = state and Color3.new(1, 1, 1) or Color3.fromRGB(100, 100, 100)
                local targetPos = state and UDim2.new(1, 0, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
                if callback then
                    callback(state)
                end
            end

            switch.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    flip()
                end
            end)
            return switch
        end

        function tabObj:slider(text, min, max, default, callback)
            local holder = Instance.new("Frame", frame)
            holder.Size = UDim2.new(1, -20, 0, 50)
            holder.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", holder)
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left

            local bar = Instance.new("Frame", holder)
            bar.Size = UDim2.new(1, 0, 0, 10)
            bar.Position = UDim2.new(0, 0, 0, 30)
            bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            local bCorner = Instance.new("UICorner", bar)
            bCorner.CornerRadius = UDim.new(0, 5)

            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            local fCorner = Instance.new("UICorner", fill)
            fCorner.CornerRadius = UDim.new(0, 5)

            local dragging = false
            local function update(x)
                local rel = (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                rel = math.clamp(rel, 0, 1)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                local val = min + rel*(max - min)
                if callback then
                    callback(val)
                end
            end
            bar.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(inp.Position.X)
                end
            end)
            bar.InputChanged:Connect(function(inp)
                if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                    update(inp.Position.X)
                end
            end)
            bar.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            return bar
        end

        return tabObj
    end

    return window
end

return library
