-- catopensource
-- Modern Dark Smooth GUI Library (Desktop & Mobile)
-- Usage: local lib = require(path_to_this_file); local win = lib.window("Title")

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local lib = {}
lib.__index = lib

-- Utility: Create UI objects
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

-- Animation helper
local function tween(obj, props, time, style)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- Main window
function lib.window(title)
    local self = setmetatable({}, lib)
    self._tabs = {}

    -- ScreenGui
    local gui = create("ScreenGui", {
        Name = "CatOpenSourceUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game:GetService("Players").LocalPlayer.PlayerGui
    })

    -- Main Frame
    local main = create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 420, 0, 320),
        Position = UDim2.new(0.5, -210, 0.5, -160),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = gui
    })
    main.Active = true
    main.Draggable = true

    -- Title
    local titleLbl = create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextColor3 = Color3.fromRGB(230, 230, 230),
        Parent = main
    })

    -- Tab bar
    local tabBar = create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Parent = main
    })

    local tabLayout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = tabBar
    })

    -- Tab container
    local tabContainer = create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(1, 0, 1, -76),
        Position = UDim2.new(0, 0, 0, 76),
        BackgroundTransparency = 1,
        Parent = main
    })

    -- Tabs API
    function self:tab(tabName)
        local tabBtn = create("TextButton", {
            Name = tabName,
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Text = tabName,
            Font = Enum.Font.Gotham,
            TextSize = 18,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            AutoButtonColor = false,
            Parent = tabBar
        })

        local tabFrame = create("Frame", {
            Name = tabName .. "Frame",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = tabContainer
        })

        local tabLayout = create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabFrame
        })

        -- Tab switching
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(self._tabs) do
                t.frame.Visible = false
                tween(t.button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
            end
            tabFrame.Visible = true
            tween(tabBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
        end)

        -- First tab auto-select
        if #self._tabs == 0 then
            tabFrame.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end

        local tabApi = {}

        -- Button
        function tabApi:button(text, callback)
            local btn = create("TextButton", {
                Size = UDim2.new(1, -20, 0, 38),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 18,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                AutoButtonColor = false,
                Parent = tabFrame
            })
            btn.MouseButton1Click:Connect(function()
                tween(btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.1)
                callback()
                tween(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
            end)
        end

        -- Toggle
        function tabApi:toggle(text, default, callback)
            local frame = create("Frame", {
                Size = UDim2.new(1, -20, 0, 38),
                BackgroundTransparency = 1,
                Parent = tabFrame
            })
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, -50, 1, 0),
                BackgroundTransparency = 1,
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 18,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            local toggleBtn = create("TextButton", {
                Size = UDim2.new(0, 36, 0, 24),
                Position = UDim2.new(1, -40, 0.5, -12),
                BackgroundColor3 = default and Color3.fromRGB(255,255,255) or Color3.fromRGB(120,120,120),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = frame
            })
            toggleBtn.AnchorPoint = Vector2.new(0,0)
            toggleBtn.BackgroundTransparency = 0.1
            toggleBtn.ClipsDescendants = true

            local state = default or false
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                local color = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(120,120,120)
                tween(toggleBtn, {BackgroundColor3 = color}, 0.2)
                callback(state)
            end)
        end

        -- Slider
        function tabApi:slider(text, min, max, default, callback)
            local frame = create("Frame", {
                Size = UDim2.new(1, -20, 0, 38),
                BackgroundTransparency = 1,
                Parent = tabFrame
            })
            local lbl = create("TextLabel", {
                Size = UDim2.new(0.5, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 18,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            local sliderBar = create("Frame", {
                Size = UDim2.new(0, 120, 0, 6),
                Position = UDim2.new(1, -130, 0.5, -3),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0,
                Parent = frame
            })
            local sliderFill = create("Frame", {
                Size = UDim2.new((default-min)/(max-min), 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel = 0,
                Parent = sliderBar
            })
            local sliderBtn = create("TextButton", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(200,200,200),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = sliderBar
            })
            local value = default
            local dragging = false

            local function setSlider(x)
                local rel = math.clamp((x-sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor((min + (max-min)*rel) + 0.5)
                sliderFill.Size = UDim2.new(rel, 0, 1, 0)
                sliderBtn.Position = UDim2.new(rel, -8, 0.5, -8)
                callback(value)
            end

            sliderBtn.MouseButton1Down:Connect(function()
                dragging = true
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    setSlider(input.Position.X)
                end
            end)
        end

        table.insert(self._tabs, {button = tabBtn, frame = tabFrame})
        return tabApi
    end

    return self
end

return lib