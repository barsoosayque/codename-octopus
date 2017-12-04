function love.conf(t)
	t.title = "A Tale about tail"			-- The title of the window the game is in (string)
	-- t.author = "Leibee and his team"	-- The author of the game (string)
	-- t.identity = "Gspot"				-- The name of the save directory (string)
	t.console = true					-- Attach a console (boolean, Windows only)
	t.window.width = 640				-- The window width (number)
	t.window.height = 640				-- The window height (number)
	t.window.fullscreen = false			-- Enable fullscreen (boolean)
	t.window.vsync = false				-- Enable vertical sync (boolean)
	t.window.resizable = false
	-- t.window.fsaa = 4					-- The number of MSAA-samples (number)
	-- t.window.msaa = 4					-- The number of MSAA-samples (number) (for 0.10)
	t.modules.joystick = false			-- Enable the joystick module (boolean)
	t.modules.audio = true				-- Enable the audio module (boolean)
	t.modules.keyboard = true			-- Enable the keyboard module (boolean)
	t.modules.event = true				-- Enable the event module (boolean)
	t.modules.image = true				-- Enable the image module (boolean)
	t.modules.graphics = true			-- Enable the graphics module (boolean)
	t.modules.timer = true				-- Enable the timer module (boolean)
	t.modules.mouse = true				-- Enable the mouse module (boolean)
	t.modules.sound = true				-- Enable the sound module (boolean)
	t.modules.physics = false			-- Enable the physics module (boolean)
end