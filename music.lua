local Music = {}

local songs = {}
local effects = {}
local playing_song = nil

-- Загружает аудио-файлы в соответствии с их типом
-- Типы могут быть: song (для песен в фоне) и sfx (для эффектов)
function Music.load(type, name, path)
	if type == "song" then
		songs[name] = love.audio.newSource(path, "static")
		songs[name]:setLooping(true)
	end

	if type == "sfx" then
		effects[name] = love.audio.newSource(path, "static")
	end
end

-- Включает песню по параметру song (название песни), а уже
-- играющая песня останавливается
function Music.play(song)
	if songs[song] ~= nil then
		Music.stop()
		songs[song]:play()
		playing_song = song
	end
end

-- Выключает играющую песню
function Music.stop()
	if songs[playing_song] ~= nil then
		songs[playing_song]:stop()
	end
end

-- Воспроизводит  указанный эффект по параметру effecy (название)
-- Если этот эффект уже играл, он остановится и сыграется снова
function Music.effect(effect)
	if effects[effect] ~= nil then
		effects[effect]:play()
	end
end

return Music