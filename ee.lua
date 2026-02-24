-- catopensource

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local library = {}
library.__index = library

local function tween(obj, props, time)
    local info = TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function make(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

function library.window(title)
    local self = setmetatable({}, library)
    self.ScreenGui = make("ScreenGui", {ResetOnSpawn=false, Name="DarkLib"})
    self.Main = make("Frame", {
        Size=UDim2.new(0.4,0,0.6,0),
        Position=UDim2.new(0.3,0,0.2,0),
        BackgroundColor3=Color3.fromRGB(30,30,30),
        Parent=self.ScreenGui,
        Active=true,
        ZIndex=1,
    })
    self.Main.ClipsDescendants = true

    -- drag
    local dragging, dragInput, dragStart, startPos
    self.Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    self.Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local header = make("Frame", {
        Size=UDim2.new(1,0,0,30),
        BackgroundColor3=Color3.fromRGB(20,20,20),
        Parent=self.Main,
    })
    local titleLabel = make("TextLabel", {
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text=title or "Window",
        TextColor3=Color3.fromRGB(220,220,220),
        Font=Enum.Font.GothamBold,
        TextSize=14,
        Parent=header,
    })

    local tabContainer = make("Frame", {
        Size=UDim2.new(1,0,1,-30),
        Position=UDim2.new(0,0,0,30),
        BackgroundTransparency=1,
        Parent=self.Main,
    })
    local tabsFrame = make("Frame", {
        Size=UDim2.new(1,0,0,25),
        BackgroundTransparency=1,
        Parent=tabContainer,
    })
    local tabsLayout = make("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Parent=tabsFrame, Padding=UDim.new(0,5)})

    self.pages = {}
    local function selectPage(name)
        for k,page in pairs(self.pages) do
            page.Frame.Visible = (k==name)
        end
    end

    function self:tab(name)
        local btn = make("TextButton", {
            Size=UDim2.new(0,0,1,0),
            BackgroundColor3=Color3.fromRGB(40,40,40),
            Text=name,
            TextColor3=Color3.fromRGB(200,200,200),
            Font=Enum.Font.Gotham,
            TextSize=12,
            AutoButtonColor=false,
            Parent=tabsFrame,
        })
        local pageFrame = make("Frame", {
            Size=UDim2.new(1,0,1,-25),
            Position=UDim2.new(0,0,0,25),
            BackgroundColor3=Color3.fromRGB(30,30,30),
            Parent=tabContainer,
            Visible=false,
        })
        pageFrame.ClipsDescendants = true
        local layout = make("UIListLayout", {Parent=pageFrame, Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder})
        self.pages[name] = {Button=btn,Frame=pageFrame,Layout=layout}
        btn.MouseButton1Click:Connect(function()
            selectPage(name)
        end)
        if #self.pages == 1 then
            selectPage(name)
        end
        local tabObj = {}
        function tabObj:button(text, callback)
            local b = make("TextButton", {
                Size=UDim2.new(1,-10,0,25),
                BackgroundColor3=Color3.fromRGB(50,50,50),
                Text=text,
                TextColor3=Color3.fromRGB(220,220,220),
                Font=Enum.Font.Gotham,
                TextSize=14,
                Parent=pageFrame,
            })
            b.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            return b
        end
        function tabObj:toggle(text, callback, default)
            local container = make("Frame", {
                Size=UDim2.new(1,-10,0,25),
                BackgroundTransparency=1,
                Parent=pageFrame,
            })
            local lbl = make("TextLabel", {
                Size=UDim2.new(0.8,0,1,0),
                BackgroundTransparency=1,
                Text=text,
                TextColor3=Color3.fromRGB(220,220,220),
                Font=Enum.Font.Gotham,
                TextSize=14,
                TextXAlignment=Enum.TextXAlignment.Left,
                Parent=container,
            })
            local togg = make("Frame", {
                Size=UDim2.new(0.2,0,0.6,0),
                Position=UDim2.new(0.8,0,0.2,0),
                BackgroundColor3=Color3.fromRGB(100,100,100),
                Parent=container,
            })
            local circle = make("Frame", {
                Size=UDim2.new(0.4,0,1,0),
                Position=UDim2.new(0,0,0,0),
                BackgroundColor3=Color3.fromRGB(200,200,200),
                Parent=togg,
            })
            circle.AnchorPoint = Vector2.new(0,0.5)
            circle.Position = UDim2.new(0,0,0.5,0)
            local state = default and true or false
            local function update()
                if state then
                    tween(circle, {Position=UDim2.new(0.6,0,0.5,0)},0.2)
                    togg.BackgroundColor3 = Color3.fromRGB(255,255,255)
                else
                    tween(circle, {Position=UDim2.new(0,0,0.5,0)},0.2)
                    togg.BackgroundColor3 = Color3.fromRGB(100,100,100)
                end
                pcall(callback, state)
            end
            container.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then
                    state = not state
                    update()
                end
            end)
            update()
            return container
        end
        function tabObj:slider(text, min, max, default, callback)
            local cont = make("Frame", {
                Size=UDim2.new(1,-10,0,40),
                BackgroundTransparency=1,
                Parent=pageFrame,
            })
            local lbl = make("TextLabel", {
                Size=UDim2.new(1,0,0,15),
                BackgroundTransparency=1,
                Text=text,
                TextColor3=Color3.fromRGB(220,220,220),
                Font=Enum.Font.Gotham,
                TextSize=14,
                Parent=cont,
            })
            local bar = make("Frame", {
                Size=UDim2.new(1,0,0,10),
                Position=UDim2.new(0,0,0,20),
                BackgroundColor3=Color3.fromRGB(60,60,60),
                Parent=cont,
            })
            local fill = make("Frame", {
                Size=UDim2.new(0,0,1,0),
                BackgroundColor3=Color3.fromRGB(180,180,180),
                Parent=bar,
            })
            local dragging = false
            local value = default or min
            local function update(pos)
                local pct = math.clamp((pos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                value = min + (max-min)*pct
                fill.Size = UDim2.new(pct,0,1,0)
                pcall(callback, value)
            end
            bar.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input.Position.X)
                end
            end)
            bar.InputChanged:Connect(function(input)
                if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
                    update(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            return cont
        end
        return tabObj
    end

    self.ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    return self
end

return library
