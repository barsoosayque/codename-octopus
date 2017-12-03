Player = {}
Player.name = 'player'

Player.x = 0
Player.y = 0
Player.width = 0
Player.height = 0
Player.speedX = 0
Player.speedY = 0

local anim8 = require('lib/anim8')
local img
local imgD = 18
local scale = 2
local animations = {}

local state = 0
local fly = false
local dj = false

local width = 0
local speed = 200

local g = 98

function Player.load(x, y, length)
	Player.x = x
	Player.y = y
	Player.width = 36 - 10
	Player.height = 36 - 5 
	width = length

	img = love.graphics.newImage('dat/gph/fox.png')
	Player.addAnim('stand', 18, 18, 0, 0, 4, 0.1)
	Player.addAnim('runL', 18, 18, 0, 18, 4, 0.1)
	Player.addAnim('runR', 18, 18, 0, 36, 4, 0.1)

end

function Player.update(dt)
	if love.keyboard.isDown('left') then
		Player.speedX = -speed
		state = -1
	elseif love.keyboard.isDown('right') then
		Player.speedX = speed
		state = 1
	else
		Player.speedX = 0
		state = 0
	end
	if fly == true and Player.speedX ~= 0 then
		Player.speedX = Player.speedX/1.5
	end

	
	print('fly:'..tostring(fly)..' dj:'..tostring(dj))
	Player.animationUpdate(dt)
end

function Player.draw(x, y)
	local anim = nil
	if state == 0 then
		anim = animations['stand']
	elseif state == 1 then
		anim = animations['runR']
	elseif state == -1 then
		anim = animations['runL']
	end

	if Player.x < 640/2 - Player.width/2 then
		anim:draw(img, x + Player.x - ((imgD/2)*scale - (Player.width/2)*scale), y + Player.y - (imgD*scale - Player.height), 
			0, scale, scale)
	elseif Player.x > width*16*2 - 640/2 - Player.width/2 then
		anim:draw(img, x + Player.x - (width*16*2 - 640) - ((imgD/2)*scale - (Player.width/2)*scale),y + Player.y - (imgD*scale - Player.height), 0, scale, scale)
	else
		anim:draw(img, 640/2 - imgD*scale/2, y + Player.y - (imgD*scale - Player.height), 0, scale, scale)
	end
end

function Player.land()
	fly = false
	dj = false
end

function Player.addAnim(name, w, h, left, top, n, time)
	local g = anim8.newGrid(w, h, img:getWidth(), img:getHeight(), left, top)
    local str = '1-' .. tostring(n)
    animations[name] = anim8.newAnimation(g(str, 1), time)
end

function Player.animationUpdate(dt)
	if state == 0 then
		animations['stand']:update(dt)
	elseif state == 1 then
		animations['runR']:update(dt)
	elseif state == -1 then
		animations['runL']:update(dt)
	end
end

function Player.filter(intem, other)
	if other.name == 'block_a' or other.name == 'block_c' or other.name == 'block_l' or other.name == 'block_r' or other.name == 'box' then
		return 'slide'
	end
end

function Player.keypressed(key, scancode, isrepeat)
	if key == 'up' and (fly == false or dj == false)  then
		Player.speedY = -175
		dj = fly
		fly = true
	end
end

return Player