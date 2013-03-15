
local buildings = {}
local function getKey(x, y)
    return x*1000+y
end
local function getXY(key)
    return math.floor(key/1000), key%1000
end

local function drawBackground()
    love.graphics.setBackgroundColor(128, 128, 128)
    --love.graphics.print("hello world", 400, 300)

    love.graphics.setColor(0, 0, 0)
    for i = 0, cellNum+1, 1 do
        love.graphics.line(i*cellSize, 0, i*cellSize, (cellNum+2)*cellSize )
        love.graphics.line(0, i*cellSize, (cellNum+2)*cellSize, i*cellSize )
    end
end

function love.update(dt)
    local xIndex, yIndex = love.mouse.getPosition()
    xIndex = math.floor(xIndex/cellSize)
    yIndex = math.floor(yIndex/cellSize)

    local leftClicked = love.mouse.isDown("l")
    local rightClicked = love.mouse.isDown("r")
    local ctrl = love.keyboard.isDown("lctrl") or love.keyboard.isDown("lctrl");
    local shift = love.keyboard.isDown("lshift") or love.keyboard.isDown("lshift");
    local enter = love.keyboard.isDown("return")
    local escape = love.keyboard.isDown("escape")
    local space = love.keyboard.isDown(" ")
    local alt = love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt")
    local z = love.keyboard.isDown("z")
    local but1 = love.keyboard.isDown("1")
    local but2 = love.keyboard.isDown("2")
    
    --print("but", but1, but2, leftClicked)
    if xIndex >= 1 and xIndex <= cellNum and yIndex >= 1 and yIndex <= cellNum then
        if leftClicked then
            local key = getKey(xIndex, yIndex)
            --print("buildings", buildings[key])
            if buildings[key] == nil then
                if but1 then
                    buildings[key] = {1, 1}
                elseif but2 then
                    buildings[key] = {2, 2}
                end
            end
        end
    end
end

--网格编号 key 网格 大小
-- 转化成 自由唯一网格
-- 经营页面 需要一个 mapGridController 的模块来处理 updateMap clearMap 的操作
-- 传入 x y 位置  sx sy 大小
local function getBlocks(b)
    local temp = {}
    for k, v in pairs(b) do
        local x, y = getXY(k)
        for i = 0, v[1]-1, 1 do
            for j = 0, v[2]-1, 1 do
                temp[getKey(x+i, y+j)] = true
            end
        end
    end
    return temp
end

local function drawBlocks(block)
    love.graphics.setColor(204, 10, 10)
    for k, v in pairs(block) do
        local x, y = getXY(k)

        local left = x*cellSize
        local top = y*cellSize
        love.graphics.rectangle("fill", left, top, cellSize, cellSize)
    end
end

local function getLine(block)
    local temp = {} --x,y-->x,y line direction
    for k, v in pairs(block) do
        local x, y = getXY(k)
        local line0 = {x, y, x+1, y}
        if not block[getKey(x, y-1)] then
            table.insert(temp, line0)
        end
        local line1 = {x, y, x, y+1}
        if not block[getKey(x-1, y)] then
            table.insert(temp, line1)
        end
        local line2 = {x+1, y, x+1, y+1}
        if not block[getKey(x+1, y)] then
            table.insert(temp, line2)
        end
        local line3 = {x, y+1, x+1, y+1}
        if not block[getKey(x, y+1)] then
            table.insert(temp, line3)
        end
    end
    return temp
end

local function drawLine(lines)
    love.graphics.setColor(20, 200, 10)
    for k, v in ipairs(lines) do
        love.graphics.line(v[1]*cellSize, v[2]*cellSize, v[3]*cellSize, v[4]*cellSize )
    end
end

local function drawBuilding()
    
    for k, v in pairs(buildings) do
        local x, y = getXY(k)
        local left = x*cellSize+cellSize/3
        local top = y*cellSize+cellSize/3
        
        --print("drawBuilding", left, top+cellSize/3)
        love.graphics.setColor(0, 204, 102)
        love.graphics.rectangle("fill", left, top, cellSize*v[1]-cellSize*2/3, cellSize*v[2]-cellSize*2/3)
    end

end

function love.draw(dt)
    drawBackground()
    local temp = getBlocks(buildings)
    drawBlocks(temp)
    drawLine(getLine(temp))
    drawBuilding()
end
