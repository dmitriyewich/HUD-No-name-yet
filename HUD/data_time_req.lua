local module = {}

module.tMain = {'data_time'}

function module.load_Textures()
	if module.main_sprite == nil then
    	module.main_sprite = get_Textures(getGameDirectory()..'\\moonloader\\resource\\hudWoW\\hudWoW', module.tMain)
    	if module.main_sprite == nil then return false end
  	end
  	return true
end

function get_Textures(txd, names)
  	if not loadTextureDictionary(txd) then return nil end
	local t = {}
	for i = 1, #names do
		local id = loadSprite(names[i])
		t[names[i]] = id
	end
	return t
end


function module.data_time()
	setSpritesDrawBeforeFade(true)
	if getActiveInterior() ~= 0 then
		drawSprite(module.main_sprite['data_time'], 567.5, 30, 30.0, 15.0, 255, 255, 255, 255)
	else
		drawSprite(module.main_sprite['data_time'], 567.5, 125, 30.0, 15.0, 255, 255, 255, 255)
	end
end

return module