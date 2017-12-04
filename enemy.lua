local Enemy = {}

Enemy.name = 'enemy'
-- Enemy.x = 0
-- Enemy.y = 0
-- Enemy.width = 0
-- Enemy.height = 0
-- Enemy.speedX = 0
-- Enemy.speedY = 0
-- Enemy.stepTick = 0
Enemy.STEP_LIMIT = 1600

local anim8 = require('lib/anim8')
-- local img

-- local imgD = { w = 30, h = 30 } -- dimenson texture

-- local scale = 1
-- local animations = {}


-- local run = 1 -- 0 stand 1 - run
-- local side = -1 -- -1 left 1 rigth
-- local jump = false

-- local width = 0
local speed = 55


local t = 0

-- function Enemy.load()
--     img = love.graphics.newImage('dat/gph/grandpa.png')
--     Enemy.addAnim('standL', 30, 30, 0, 0, 4, 0.1)
--     Enemy.addAnim('standR', 30, 30, 0, 30, 4, 0.1)
--     Enemy.addAnim('runL', 30, 30, 0, 60, 4, 0.1)
--     Enemy.addAnim('runR', 30, 30, 0, 90, 4, 0.1)
-- end

function Enemy.newEnemy(x, y, w)
    local enemy = {
        name = 'enemy',
        x = x,
        y = y,
        width = 30,
        height = 30,
        speedX = speed,
        speedY = 0,
        stepTick = 0,
        spawnX = x,
        spawnY = y,
        -- stepLimit = limit, ???
        run = 1, -- 0 stand 1 - run
        side = -1, -- -1 left 1 rigth

        img = nil,
        animations = {},
        reset = function(self) 
            self.x = self.spawnX
            self.y = self.spawnY
        end,
        animationUpdate = function(self, dt)
            if self.side == -1 then
                self.speedX = -speed
                self.animations['runL']:update(dt)
            else
                self.speedX = speed
                self.animations['runR']:update(dt)
            end
        end,
        addAnim = function(self, name, w, h, left, top, n, time)
            -- print('name:'..name)
            local g = anim8.newGrid(w, h, self.img:getWidth(), self.img:getHeight(), left, top)
            local str = '1-' .. tostring(n)
            self.animations[name] = anim8.newAnimation(g(str, 1), time)
        end,
        load = function(self)
            self.img = love.graphics.newImage('dat/gph/grandpa.png')
            self:addAnim('standL', 30, 30, 0, 0, 4, 0.1)
            self:addAnim('standR', 30, 30, 0, 30, 4, 0.1)
            self:addAnim('runL', 30, 30, 0, 60, 4, 0.1)
            self:addAnim('runR', 30, 30, 0, 90, 4, 0.1)

        end,
        draw = function(self, x, y)
            local anim
            -- print('run:'..tostring(self.run)..' side:'..tostring(self.side))
            if self.run == 0 and self.side == 1 then
                anim = self.animations['standR']
            elseif self.run == 0 and self.side == -1 then
                anim = self.animations['standL']
            elseif self.run == 1 and self.side == 1 then
                anim = self.animations['runR']
            elseif self.run == 1 and self.side == -1 then
                anim = self.animations['runL']
            end
            -- local dtx = imgD.w * scale / 2 - math.floor(Enemy.width / 2)
            -- local dty = imgD.h * scale - Enemy.height
            anim:draw(self.img, x, y)
        end,
        update = function(self, dt)
            if self.stepTick == Enemy.STEP_LIMIT then
                self.side = -self.side
                self.stepTick = 0
            end
            self.stepTick = self.stepTick + 1
            self:animationUpdate(dt)
        end,
        land = function()
            -- jump = false

        end,
        turnBack = function(self)
            self.side = -self.side
            self.stepTick = 0  
        end,
        filter = function(item, other)
            if other.name == 'stone' or other.name == 'dirt' or other.name == 'wood' then
                return 'slide'
            end
        end,
        fly = function() end

    }
    return enemy
    
end

-- function Enemy.draw(x, y)
--     local anim

--     if run == 0 and side == 1 then
--         anim = animations['standR']
--     elseif run == 0 and side == -1 then
--         anim = animations['standL']
--     elseif run == 1 and side == 1 then
--         anim = animations['runR']
--     elseif run == 1 and side == -1 then
--         anim = animations['runL']
--     end

--     local dtx = imgD.w * scale / 2 - math.floor(Enemy.width / 2)
--     local dty = imgD.h * scale - Enemy.height

--     anim:draw(img, x - dtx, y - dty, 0, scale, scale)
-- end

-- function Enemy.land()
--     jump = false
-- end

-- function Enemy.fly()
-- end

-- function Enemy.addAnim(name, w, h, left, top, n, time)
--     local g = anim8.newGrid(w, h, img:getWidth(), img:getHeight(), left, top)
--     local str = '1-' .. tostring(n)

--     animations[name] = anim8.newAnimation(g(str, 1), time)
-- end

-- function Enemy.update(dt)
--     -- print(side)
--     if Enemy.stepTick == Enemy.STEP_LIMIT then
--         side = -side
--         Enemy.stepTick = 0
--     end
--     Enemy.stepTick = Enemy.stepTick + 1
--     Enemy.animationUpdate(dt)
-- end

-- function Enemy.turnBack()
--     side = -side
--     Enemy.stepTick = 0
-- end

-- function Enemy.animationUpdate(dt)
--     if side == -1 then
--         Enemy.speedX = -speed
--         animations['runL']:update(dt)
--     else
--         Enemy.speedX = speed
--         animations['runR']:update(dt)
--     end
-- end

-- function Enemy.filter(intem, other)
--     if other.name == 'stone' or other.name == 'dirt' or other.name == 'wood' then
--         return 'slide'
--     end
-- end

return Enemy