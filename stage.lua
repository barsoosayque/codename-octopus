Stage = {}

local bump = require('lib/bump')
local world = bump.newWorld(16)

local textures = {}
local tiles = {}

local entities = {}

local bMap = {}
local fMap = {}

function Stage.load(bImgFileName, fImgFileName, description)
	local bImg = love.graphics.newImage(bImgFileName)
	local fImg = love.graphics.newImage(fImgFileName)

	Stage.width, Stage.height = bImg:getDimensions()
	local x, y = Stage.buildMap(bImg, fImg)

	entities['player'] = require('player')
	entities['player'].load(x, y, Stage.width)
	world:add(entities['player'], x, y, entities['player'].width, entities['player'].height)

	Stage.newTexture('dat/gph/tiles_bg.png', 'background')
	Stage.newTexture('dat/gph/tiles_fg.png', 'foreground')

	Stage.newTile('foreground', 'block_a', 48, 0, 16, 16)
	Stage.newTile('foreground', 'block_l', 64, 16, 16, 16)
	Stage.newTile('foreground', 'block_r', 48, 16, 16, 16)
	Stage.newTile('foreground', 'block_c', 64, 0, 16, 16)
	Stage.newTile('foreground', 'box', 80, 16, 16, 16)
	Stage.newTile('foreground', 'empty', 80, 0, 16, 16)




end

function Stage.update(dt)
	for _, entitie in pairs(entities) do
		entitie.update(dt)

		entitie.speedY = entitie.speedY + 300*dt

		local goalX = entitie.x + entitie.speedX*dt
		local goalY = entitie.y + entitie.speedY*dt
		local actualX, actualY, cols, len = world:move(entitie, goalX, goalY, entitie.filter)

		if actualY == entitie.y then
			entitie.speedY = 0
			entitie.land()
		end


		-- print('name:'..entitie.name)
		-- print('gx:'..tostring(goalX)..' gy:'..tostring(goalY))
		-- print('ax:'..tostring(actualX)..' ay:'..tostring(actualY))
		-- print('speedX:'..tostring(entitie.speedX)..' speedY:'..tostring(entitie.speedY))
		
		entitie.x = actualX
		entitie.y = actualY
	end
end

function Stage.draw(x, y)
	Stage.drawMap(x, y)

	for _, entitie in pairs(entities) do
		entitie.draw(x, y)
	end
end

function Stage.newTexture(fileName, textureName)
	textures[textureName] = love.graphics.newImage(fileName)
end

function Stage.newTile(textureName, tileName, x, y, w, h)
	tiles[tileName] = {}
	tiles[tileName].tile = love.graphics.newQuad(x, y, w, h, textures[textureName]:getDimensions())
	tiles[tileName].texture = textureName
end

function Stage.drawMap(X, Y)

	-- print('drawTile '..name)
	-- for k, v in pairs(tiles) do
	-- 	print('key:'..tostring(k)..' value:'..tostring(v))
	-- 	if type(v) == 'table' then
	-- 		for kk, vv in pairs(v) do
	-- 			print('\tkey:'..tostring(kk)..' value:'..tostring(vv))
	-- 		end
	-- 	end
	-- end
	-- love.timer.sleep(1)

	local l = entities['player'].x + entities['player'].width/2	
	-- if entities['player'].x < 640/2 - entities['player'].width/2 then
	-- 	l = entities['player'].x
	-- end
	local dl = 0
	-- print('l:'..tostring(l))
	if l < 640/2 then
		dl = 0
	elseif l > Stage.width*16*2 - 320 then
		dl = Stage.width*16*2 - 640   -->??????
	else
		dl = l - 320
	end

	for x = 0, Stage.width - 1 do
		for y = 0, Stage.height - 1 do
			local nx = x*16*2
			local ny = y*16*2
			-- print('x:'..tostring(x)..' y:'..tostring(y))
			-- print('bmap['..tostring(x)..']['..tostring(y)..']:'..tostring(bMap[x][y]))
			Stage.drawTile(fMap[x][y].name, X + nx - dl, Y + ny)
		end
	end
end

function Stage.drawTile(name, x, y)
	-- local scaleX, scaleY = getImageScaleForNewDimensions(textures[name], 2*16, 2*16 )
	-- love.graphics.draw(textures[name], x, y, 0, scaleX, scaleY)
	local tile = tiles[name]
	-- print('drawTile:'..name..'\n\ttexture:'..tile.texture..' tile:'..tostring(tile.tile))
	-- print('\t'..tostring(textures[tile.texture]))
	local nw, nh = textures[tile.texture]:getDimensions()
	
	-- print(tostring(nw)..'|'..tostring(nh))
	nw, nh = 2*nw, 2*nh
	-- print(tostring(nw)..'|'..tostring(nh))

	local scaleX, scaleY = getImageScaleForNewDimensions(textures[tile.texture], nw, nh)
	love.graphics.draw(textures[tile.texture], tile.tile, x, y, 0, scaleX, scaleY)

end



function chekColor(r, g, b)
	if r == 0 and g == 0 and b == 0 then
		return 'block_a'
	elseif r == 255 and g == 255 and b == 255 then
		return 'empty'
	elseif r == 255 and g == 0 and b == 0 then
		return 'fox'
	elseif r == 50 and g == 0 and b == 0 then
		return 'block_l'
	elseif r == 0 and g == 50 and b == 0 then
		return 'block_c'
	elseif r == 0 and g == 0 and b == 50 then
		return 'block_r'
	elseif r == 255 and g == 255 and b == 0 then
		return 'box'
	end 
end


function Stage.buildMap(bImg, fImg)
	local bData = bImg:getData()
	local fData = fImg:getData()

	local pX, pY

	for x = 0, Stage.width - 1 do
		bMap[x] = {}
		fMap[x] = {}
		for y = 0, Stage.height - 1 do
			-->bMap
			r, g, b, a = bData:getPixel(x, y)
			color = chekColor(r, g, b)
			-- print('x:'..tostring(x)..' y:'..tostring(y))
			-- print('color:'..color)
			
			-- print('bmap['..tostring(x)..']['..tostring(y)..']:'..tostring(bMap[x][y]))
			-->fMap
			r, g, b = fData:getPixel(x, y)
			color = chekColor(r, g, b)
			if color == 'block_a' or color == 'block_c' or color == 'block_l' or color == 'block_r' or color == 'box' then
				fMap[x][y] = {name = color}
				world:add(fMap[x][y], x*16*2, y*16*2, 16*2, 16*2)
			elseif color == 'empty' then
				fMap[x][y] = {name = color}
			end
			if color == 'fox' then
				fMap[x][y] = {name = 'empty'}
				pX, pY = x*16*2, y*16*2
			end

		end
	end
	return pX, pY
end

function getImageScaleForNewDimensions(image, newWidth, newHeight )
    local currentWidth, currentHeight = image:getDimensions()
    return ( newWidth / currentWidth ), ( newHeight / currentHeight )
end

function Stage.keypressed(key, scancode, isrepeat)
	entities['player'].keypressed(key, scancode, isrepeat)
end

return Stage