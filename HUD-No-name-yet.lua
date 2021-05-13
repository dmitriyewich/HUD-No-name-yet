-- TODO 
-- Разобраться с отображением времени и фоном времени.
-- Разобраться со специальными актерами.
-- Закончить баффы.
-- Закончить педы в группе.
-- Починить смену педа при таргете.
-- Режим бездействия.
-- После смерти труп остается на месте, 50% денег и оружие.
-- ...


script_name('HUD-No-name-yet')
script_author('dmitriyewich, https://vk.com/dmitriyewichmods')
script_version('0.0.1-pre-release')

local memory = require 'memory'
local mad = require 'MoonAdditions'
local ffi = require('ffi')
local inicfg = require 'inicfg'

local glob = require "lib.game.globals"
local lualzw = require("lualzw")
directIni = "moonloader\\HUD\\hudcolors.ini"
local mainIni = inicfg.load(nil, 'moonloader/HUD/names.ini')
local lencoding, encoding = pcall(require, 'encoding')
encoding.default = 'CP1251'
u8 = encoding.UTF8
CP1251 = encoding.CP1251

ffi.cdef[[
    void *malloc(size_t size);
    void free(void *ptr);
]]

tMain = {'hud_main', 'hp_boarded', 'hp', 'hp_blick', 'boarded', 'armour', 'sprint', 'body_armour', 'body_stamina', 'o2_icon', 'hp_plus', 'hud_maininvert', 'data_time', 'location_main', 'help_parchment', 'cj', 'guns_jetpackicon', 'armour_blick', 'mouse_hud', 'hud_friend'}

sprites = {}

help_gxt = {}
help_gxt_main = false
help_gxt_time = os.clock() + (1*4.2)
-- local change = 
if doesFileExist("moonloader/HUD/help_gxt.json") then
    local f = io.open("moonloader/HUD/help_gxt.json")
    help_gxt = decodeJson(f:read("*a"))
    f:close()
else
-- print()
printString('"help_gxt.json" ~r~not found! Script stopped working!!', 3000)
end
 -- print(memory.getint8(0xBA82E0))
 
 -- function removeBodyPart(handle, boneId, localDir)
-- local pedEn = getCharPointer(handle)
-- -- local pedEn = handle
-- if pedEn ~= nil then
-- ffi.cast("void (__thiscall *)(uint32_t, int, char)", 0x5F0140)(pedEn, boneId, localDir)
-- end
-- end
-- -- print(PLAYER_PED)
-- -- print(PLAYER_HANDLE)
-- -- removeBodyPart(PLAYER_PED, 4, 0)
-- -- for i = 1, 30 do
-- -- removeBodyPart(getGroupMember(getPlayerGroup(PLAYER_HANDLE), 0), 1, false)
-- -- removeBodyPart(PLAYER_HANDLE, i, i)
-- -- end
function main()
	Radar_Disc_Color_Fix()
	while wait(100) and isPlayerPlaying(PLAYER_PED) do wait(0) end -- Так надо
	changeRadarSize(95, 95)
	changeRadarPos(520, 420)
	patches()

	txd = mad.load_txd(getWorkingDirectory() .. '/HUD/hudWoW.txd')
	
	while txd == nil do wait(100) end -- Так надо
		-- loadTextureDictionary(getWorkingDirectory() .. '/HUD/hudWoW.txd')
		-- -- while not loadTextureDictionary(getWorkingDirectory() .. '/HUD/hudWoW.txd') do wait(100) end
		-- data_time_sprite = loadSprite('data_time')
	local data_time_req = require 'HUD.data_time_req'
	data_time_req.load_Textures()
	for i = 0, 299 do
		texture_from_txd = txd:get_texture('skin_'..i)
		sprites['skin_'..i] = texture_from_txd
	end
		for _, name in pairs(tMain) do
			texture_from_txd = txd:get_texture(''..name)
			sprites[''..name] = texture_from_txd
		end
	for i = 0, 46 do
		if i == 19 or i == 20 or i == 21 then goto continue end
			texture_from_txd = txd:get_texture('guns_'..i)
			sprites['guns_'..i] = texture_from_txd
		::continue::
	end

	-- taskPause(PLAYER_PED, 10000)
	-- pauseCurrentBeatTrack(true)
-- ffi.fill(0x57BA57, 6, 0x90)
-- local d = ffi.cast ("void*", 0x57BA57)
-- ffi.fill(d, 6, 0x90)

	Gxt_othBullets = getFreeGxtKey()
	Gxt_bullets = getFreeGxtKey()
	Gxt_TimeOfDay = getFreeGxtKey()
	Gxt_location = getFreeGxtKey()
	Gxt_money_minus = getFreeGxtKey()
	Gxt_money_plus = getFreeGxtKey()
	Gxt_random_name = getFreeGxtKey()

	Gxt_random_name_group0 = getFreeGxtKey()
	Gxt_random_name_group1 = getFreeGxtKey()
	Gxt_random_name_group2 = getFreeGxtKey()
	Gxt_random_name_group3 = getFreeGxtKey()
	Gxt_random_name_group4 = getFreeGxtKey()
	Gxt_random_name_group5 = getFreeGxtKey()
	Gxt_random_name_group6 = getFreeGxtKey()
testdad = {Gxt_random_name_group0, Gxt_random_name_group1, Gxt_random_name_group2, Gxt_random_name_group3, Gxt_random_name_group4, Gxt_random_name_group5, Gxt_random_name_group6}
	-- print(unpack(testdad))
	-- print(getGroupMember(getPlayerGroup(PLAYER_HANDLE), 3))
	-- giveWeaponToChar(getGroupMember(getPlayerGroup(PLAYER_HANDLE), 0), 25, 1000)
	-- setCurrentCharWeapon(getGroupMember(getPlayerGroup(PLAYER_HANDLE), 0), 25)
	-- setCharWeaponSkill(getGroupMember(getPlayerGroup(PLAYER_HANDLE), 0), 2)
	 -- printBigQ('M_FAIL', 1000, 1)
	-- callFunction(0x69F0B0, 4, 4, 0, 0, 3000, "Hellow World")
	-- callFunction(getCharPointer(PLAYER_PED)+0x5F0140, 2, 2, 5, true)

	-- ptr = getCharPointer(PLAYER_PED)
	-- callFunction(ptr+0x5F0140, 2, 2, 5, ptr)
-- local CModelInfo__GetModelInfo = ffi.cast('struct CBaseModelInfo* (__cdecl *)(char * modelName, uint16_t * pIndex)', 0x4C5940)
-- local mdlinfo = CModelInfo__GetModelInfo(arg1, arg2)

-- ffi.cast("void (__thiscall *)(CPed*, int, char" , 0x5F0140)ffi.cast(this, "int", localDir)

	-- ffi.cast("void(__thiscall*)(void*)", 0x59F180)(ffi.cast("void*", pPed))
	Group_Health_Damage = {}
	
	while true do wait(0)
	X, Y, Z = getCharCoordinates(PLAYER_PED)
	-- drawShadow(3, X, Y ,Z, 0.0, 1, 1, 255, 255, 255)
	drawLightWithRange(X, Y, Z+1, 255, 255, 255, 5,0)
	-- drawRect(X, Y ,Z, 100, 200, 255, 255, 255, 255)
	-- drawSphere(X, Y ,Z, 0.7)
			-- for i = 1, 15, 1 do
	-- testaw = setFreeGxtEntry('sda'..-i)
	-- -- printWithNumber(testaw, i, 1000, 1)
	-- -- wait(1000)
	-- -- printString('dadaw', 1000)
	-- printWithNumber(testaw, -i, 1000, 1)
	-- -- printWithNumberBig(testaw, i, 1000, 1)
		-- -- printStringNow('testaw', 1000)
	-- -- wait(1000)
	-- -- break
	-- end
	-- print(getCameraFov())
	-- print(getFadingStatus())
	-- print(getBeatTrackStatus())
	-- print(cameraIsVectorMoveRunning())
	-- print(cameraIsVectorTrackRunning())
	-- displayHud(false)
	-- setCinemaCamera(false)
	-- print(isCharUsingMapAttractor(PLAYER_PED))
	-- print(isCharUsingMapAttractor(PLAYER_HANDLE))
	-- print(readMemory(0x522C80, 1, true))
	-- print(memory.getint16(0xBA6769))
	-- print(memory.getint32(0xBA676C))
	-- print(memory.getint8(0xBA6769))
	-- print(isSkipWaitingForScriptToFadeIn())
	-- print(string.format("%s", getGameGlobal(glob.Recall_Time)))
		-- print(string.format("%s", getGameGlobal(glob.Actor_Cesar)))
		-- print(getCharModel(298))
		-- print(getActiveCamMode())

-- print(readMemory(0xC8A7C1, 1, false))
-- r, g, b, a = getHudColour(int interface)
-- print(getHudColour(8))
-- print(getCharHighestPriorityEvent(PLAYER_PED))
-- print(memory.read(0xBAA464, 1, true)) 
 -- print(memory.getint8(0x69EFC0))
 -- print(memory.read(0xB7CB49, 1, true)) 
 -- print(memory.getfloat(0xBAB328))
 -- mdlinfoaddr = callFunction(0x4C5940, 2, 2, 'fam1', 0)
 -- print(mdlinfoaddr)
		if getActiveInterior() ~= 0 or getActiveCamMode() == 7 or getActiveCamMode() == 8 or getActiveCamMode() == 46 or getActiveCamMode() == 51 then
			memory.setint8(0xBA676C, 2)
		else
			memory.setint8(0xBA676C, 0)
		end
		
		-- print(isGamePaused())
		setHelpMessageBoxSize(0)
		-- displayNonMinigameHelpMessages(false)
		
		if isHelpMessageBeingDisplayed() then
			for i = 1, #help_gxt.gxt do
				if isThisHelpMessageBeingDisplayed(help_gxt.gxt[i]) then
					clearHelp()
					Gxt_Window_test = help_gxt.gxt[i]
					help_gxt_main = true
					break
				end
			end
			-- clearHelp()
			
			if getGxtText(Gxt_Window_test):len() <= 59 then
				help_gxt_time = os.clock() + (1*1.2)
			elseif getGxtText(Gxt_Window_test):len() >= 60 then
				help_gxt_time = os.clock() + (1*5.2)
			end
		end
-- print(Gxt_Window_test)
		if help_gxt_main then
			setTextScale(0.23, 0.77)
			setTextFont(1)
			setTextEdge(1.0, 0, 0, 0, 50)
			setTextColour(255, 255, 255, 225)
			setTextProportional(true)
			setTextDropshadow(1, 20, 20, 20, 50)
			setTextCentre(true)
			setTextDrawBeforeFade(true)
			setTextCentreSize(174.0)
			-- Gxt_Window_test = setFreeGxtEntry(u8:decode(lualzw.decompress('€љec© co—pa®Ё ўce cyЎec¦ўy«Ўњe')))
			-- display_texture(sprites['help_parchment'], convert_x(215), convert_y(4), convert_x(425.0), convert_y(39))
			if getGxtText(Gxt_Window_test):len() <= 41 then
				displayText(320, 19, Gxt_Window_test)						
			elseif getGxtText(Gxt_Window_test):len() <= 76 then
				displayText(320, 16, Gxt_Window_test)
			elseif getGxtText(Gxt_Window_test):len() >= 77 then
				displayText(320, 10, Gxt_Window_test)
			end
			if help_gxt_time < os.clock() then
				help_gxt_time = os.clock() + (1*0)
				help_gxt_main = false
			end
		end
			-- setMessageFormatting(true, 0, 0)
		
		if not isPauseMenuActive() and memory.getint8(0xB6F065) == 0 and getActiveCamMode() ~= 7 and getActiveCamMode() ~= 8 and getActiveCamMode() ~= 46 and getActiveCamMode() ~= 51 and not isCharRespondingToEvent(PLAYER_PED, 10)--[[and not getFadingStatus()]] then
						
			displayHud(false)
			setPlayerDisplayVitalStatsButton(PLAYER_HANDLE, false)
			local weapon = getCurrentCharWeapon(PLAYER_PED)
			local slot_weapon = getWeapontypeSlot(weapon)
			local bullets = myAmmo()
			local othBullets = getAmmoInCharWeapon(PLAYER_PED, weapon) - myAmmo()
			-- -- local wanted = memory.getuint8(0x58DB60)
			result_wanted, wanted = storeWantedLevel(PLAYER_HANDLE)
			local oxygen = math.floor(memory.getfloat(0xB7CDE0) / 39.97000244)
		
			display_texture(sprites['hp_boarded'], convert_x(34.8), convert_y(11.0), convert_x(82.0), convert_y(22))

			display_texture(sprites['boarded'], convert_x(35), convert_y(20.5), convert_x(82.0), convert_y(24.8))
			
			display_texture(sprites['skin_'..getCharModel(PLAYER_PED)], convert_x(9.6), convert_y(9.0), convert_x(32.6), convert_y(34.0))
			-- ---------------------Health---------------------
			if Health_Damage == nil then Health_Damage = { getCharHealth(PLAYER_PED), nil, nil, nil } end
			math.randomseed(tonumber(tostring(os.clock()):match('%.(%d)')) or 0)
			if Health_Damage[1] ~= getCharHealth(PLAYER_PED) then
				local GiveHP = getCharHealth(PLAYER_PED) - Health_Damage[1]
				Health_Damage = { getCharHealth(PLAYER_PED), getCharHealth(PLAYER_PED) - GiveHP, GiveHP, GiveHP > 0 and os.clock() - 0.5 or os.clock() }
			end

			
			if Health_Damage[4] == nil or (os.clock() - Health_Damage[4] > 1.0) then
				if getCharHealth(PLAYER_PED) <= 100 then
					display_texture(sprites['hp'], convert_x(34.8), convert_y(11.0), convert_x(82-(47-((47/100)*getCharHealth(PLAYER_PED)))), convert_y(20.5))
				else
					display_texture(sprites['hp'], convert_x(34.8), convert_y(11.0), convert_x(82), convert_y(20.5))
				end
			else
				if not blicking_Health then
					blicking_Health = lua_thread.create(function()
						blick_Health = not blick_Health
						wait(125)
					blicking_Health = nil
					end)
				end
				if blick_Health then
					if getCharHealth(PLAYER_PED) <= 100 then
						display_texture(sprites['hp_blick'], convert_x(34.8), convert_y(11.0), convert_x(82-(47-((47/100)*getCharHealth(PLAYER_PED)))), convert_y(20.5))
					else
						display_texture(sprites['hp_blick'], convert_x(34.8), convert_y(11.0), convert_x(82), convert_y(20.5))
					end
				else
					if getCharHealth(PLAYER_PED) <= 100 then
						display_texture(sprites['hp'], convert_x(34.8), convert_y(11.0), convert_x(82-(47-((47/100)*getCharHealth(PLAYER_PED)))), convert_y(20.5))
					else
						display_texture(sprites['hp'], convert_x(34.8), convert_y(11.0), convert_x(82), convert_y(20.5))
					end
				end
			end
		---------------------Health---------------------
		---------------------Armour and Sprint---------------------
			if Armour_Damage == nil then Armour_Damage = { getCharArmour(PLAYER_PED), nil, nil, nil } end
			math.randomseed(tonumber(tostring(os.clock()):match('%.(%d)')) or 0)
			if Armour_Damage[1] ~= getCharArmour(PLAYER_PED) then
				local GiveHP = getCharArmour(PLAYER_PED) - Armour_Damage[1]
				Armour_Damage = { getCharArmour(PLAYER_PED), getCharArmour(PLAYER_PED) - GiveHP, GiveHP, GiveHP > 0 and os.clock() - 0.5 or os.clock() }
			end
			if getCharArmour(PLAYER_PED) > 0 then
				if Armour_Damage[4] == nil or (os.clock() - Armour_Damage[4] > 1.0) then
					if getCharArmour(PLAYER_PED) <= 100 then
						display_texture(sprites['armour'], convert_x(35), convert_y(21.0), convert_x(82-(47-((47/100)*getCharArmour(PLAYER_PED)))), convert_y(25.0))
					else
						display_texture(sprites['armour'], convert_x(35), convert_y(21.0), convert_x(82), convert_y(25.0))
					end
				else
					if not blicking_armour then
						blicking_armour = lua_thread.create(function()
							blick_armour = not blick_armour
							wait(125)
						blicking_armour = nil
						end)
					end
					
					if blick_armour then
						if getCharArmour(PLAYER_PED) <= 100 then
							display_texture(sprites['armour_blick'], convert_x(35), convert_y(21.0), convert_x(82-(47-((47/100)*getCharArmour(PLAYER_PED)))), convert_y(25.0))
						else
							display_texture(sprites['armour_blick'], convert_x(35), convert_y(21.0), convert_x(82), convert_y(25.0))
						end
					else
						if getCharArmour(PLAYER_PED) <= 100 then
							display_texture(sprites['armour'], convert_x(35), convert_y(21.0), convert_x(82-(47-((47/100)*getCharArmour(PLAYER_PED)))), convert_y(25.0))
						else
							display_texture(sprites['armour'], convert_x(35), convert_y(21.0), convert_x(82), convert_y(25.0))
						end
					end
				end
			else
					display_texture(sprites['sprint'], convert_x(35), convert_y(21.0), convert_x(82-(47-((47/100)*getSprintLocalPlayer()))), convert_y(25.0))
			end
		---------------------Armour and Sprint---------------------
			display_texture(sprites['hud_main'], convert_x(4.3), convert_y(4), convert_x(85.1), convert_y(38.5))
			
			display_texture(sprites['guns_'..getCurrentCharWeapon(PLAYER_PED)], convert_x(7), convert_y(25), convert_x(17), convert_y(36.0))

			if bullets > 0 and othBullets > 0 and slot_weapon ~= 1 then
			
				setTextCentre(true)
				setTextScale(0.16, 0.86)
				setTextColour(255--[[r]], 255--[[g]], 255--[[b]], 155--[[a]])
				setTextEdge(1.0--[[outline size]], 0--[[r]], 0--[[g]], 0--[[b]], 25--[[a]])
				setTextFont(1)
				setTextProportional(true)
				setTextDropshadow(1, 20, 20, 20, 50)
				setGxtEntry(Gxt_othBullets, othBullets)
				setTextDrawBeforeFade(true)
				displayText(11.5, 35.5, Gxt_othBullets)
				
				setTextCentre(true)
				setTextScale(0.16, 0.86)
				setTextColour(255, 255, 255, 255)
				setTextEdge(1.0, 0, 0, 0, 25)
				setTextFont(1)
				setTextProportional(true)
				setTextDropshadow(1, 20, 20, 20, 50)
				setGxtEntry(Gxt_bullets, bullets)
				setTextDrawBeforeFade(true)
				displayText(16.5, 31.0, Gxt_bullets)
			elseif bullets == 0 and othBullets > 0 and slot_weapon ~= 1 then
				setTextCentre(true)
				setTextScale(0.16, 0.86)
				setTextColour(255, 255, 255, 155)
				setTextEdge(1.0, 0, 0, 0, 25)
				setTextFont(1)
				setTextProportional(true)
				setTextDropshadow(1, 20, 20, 20, 50)
				setGxtEntry(Gxt_othBullets, othBullets)
				setTextDrawBeforeFade(true)
				displayText(11.5, 35.5, Gxt_othBullets)

				setTextCentre(true)
				setTextScale(0.16, 0.86)
				setTextColour(255, 255, 255, 255)
				setTextEdge(1.0, 0, 0, 0, 25)
				setTextFont(1)
				setTextProportional(true)
				setTextDropshadow(1, 20, 20, 20, 50)
				setGxtEntry(Gxt_bullets, bullets)
				setTextDrawBeforeFade(true)
				displayText(16.5, 31.0, Gxt_bullets)
				
			elseif bullets > 0 and othBullets == 0 and slot_weapon ~= 1 then
				setTextCentre(true)
				setTextScale(0.16, 0.86)
				setTextColour(255, 255, 255, 155)
				setTextEdge(1.0, 0, 0, 0, 25)
				setTextFont(1)
				setTextProportional(true)
				setTextDropshadow(1, 20, 20, 20, 50)
				setGxtEntry(Gxt_othBullets, othBullets)
				setTextDrawBeforeFade(true)
				displayText(11.5, 35.5, Gxt_othBullets)
				setTextCentre(true)
				setTextScale(0.16, 0.86)
				setTextColour(255, 255, 255, 255)
				setTextEdge(1.0, 0, 0, 0, 25)
				setTextFont(1)
				setTextProportional(true)
				setTextDropshadow(1, 20, 20, 20, 50)
				setGxtEntry(Gxt_bullets, bullets)
				setTextDrawBeforeFade(true)
				displayText(16.5, 31.0, Gxt_bullets)
			end		
		
			--------------------------TIME-------------------------------
			data_time_req.data_time()

			hours, mins = getTimeOfDay()
			setGxtEntry(Gxt_TimeOfDay, (hours <= 9 and '0'..hours or hours)..":"..(mins <= 9 and '0'..mins or mins))
			setTextCentre(true)
			setTextColour(255, 255, 255, 230)
			setTextScale(0.26, 1.0)
			setTextFont(3)
			setTextEdge(1.0, 0, 0, 0, 50)
			setTextProportional(true)
			setTextDropshadow(1, 74, 74, 74, 50)
			setTextDrawBeforeFade(true)
			if getActiveInterior() ~= 0 then
				displayText(567.7, 25.5, Gxt_TimeOfDay)
			else
				displayText(567.7, 120.5, Gxt_TimeOfDay)
			end
			--------------------------TIME-------------------------------
			--------------------------location----------------------------------
			setGxtEntry(Gxt_location, calculateZoneEN(getCharCoordinates(PLAYER_PED)))
			setTextCentre(true)
			-- setTextScale(0.26, 1.0)
				if getGxtText(Gxt_location):len() <= 13 then
					setTextScale(0.26, 1.8)
				elseif getGxtText(Gxt_location):len() <= 15 then
					setTextScale(0.20, 1.8)
				elseif getGxtText(Gxt_location):len() <= 20 then
					setTextScale(0.18, 1.8)
				elseif getGxtText(Gxt_location):len() <= 25 then
					setTextScale(0.16, 1.8)
				elseif getGxtText(Gxt_location):len() >= 26 then
					setTextScale(0.125, 1.8)
				end
			setTextFont(2)
			setTextColour(255, 255, 255, 230)
			setTextEdge(1.0, 0, 0, 0, 50)
			setTextProportional(true)
			setTextDropshadow(1, 74, 74, 74, 50)
			setTextDrawBeforeFade(true)
			displayText(567.7, 2.5, Gxt_location)
			-- mad.draw_text(location_text, convert_x(567.0), convert_y(4.5), 2, _, _, 3, _, true, false, 235, 235, 235, 235, _, _, _, _, _, _, _, _, _, _, _)
			--draw_text(string text, float x, float y, [uint style, float width, float height, uint align, float wrap, bool proportional, bool justify, int text_r, int text_g, int text_b, int text_a, uint outline, uint shadow, int shadow_r, int shadow_g, int shadow_b, int shadow_a, bool background, int background_r, int background_g, int background_b, int background_a])
			display_texture(sprites['location_main'], convert_x(517.7), convert_y(2.0), convert_x(617.0), convert_y(22.5))
			

			-- fafawfaw = readMemory(0xB6F3B8, 4, false)
			-- print(fafawfaw + 0x79C)
			--------------------------location----------------------------------

			-- if separator(getPlayerMoney(PLAYER_HANDLE)):find('%-') then
				-- mad.draw_text('-$'..separator(getPlayerMoney(PLAYER_HANDLE)):gsub('%-', ''), convert_x(56.5), convert_y(22.1), 1, 0.6, 1.0, 0, 10, true, false, 248, 0, 0, 245, 1, false, 0, 0, 0, 150, false, 0, 0, 0, 0)
			-- else
				-- mad.draw_text('$'..separator(getPlayerMoney(PLAYER_HANDLE)), convert_x(56.5), convert_y(22.1), 1, 0.6, 1.0, 0, 10, true, false, 54, 104, 44, 255, 1, false, 0, 0, 0, 150, false, 0, 0, 0, 0)
			-- end
			if separator(getPlayerMoney(PLAYER_HANDLE)):find('%-') then
				setTextCentre(true)
				setTextScale(0.2, 0.85)
				setTextColour(227, 0, 0, 245)
				setTextEdge(1.0, 0, 0, 0, 150)
				setGxtEntry(Gxt_money_minus, '-$'..separator(getPlayerMoney(PLAYER_HANDLE)):gsub('%-', ''))
				setTextDrawBeforeFade(true)
				displayText(56.5, 27.0, Gxt_money_minus)
			else
				setTextCentre(true)
				setTextScale(0.2, 0.85)
				setTextColour(54, 104, 44, 255)
				setTextEdge(1.0, 0, 0, 0, 150)
				setGxtEntry(Gxt_money_plus, '$'..separator(getPlayerMoney(PLAYER_HANDLE)))
				setTextDrawBeforeFade(true)
				displayText(56.5, 27.0, Gxt_money_plus)
			end
			
			
			result, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if targeting_skin and result and isButtonPressed(PLAYER_HANDLE, 6) then
				targeting_skin = false
				targeting_skin_func()
			end
			-- if ped ~= ped_last then
-- targeting_skin = true
-- targeting_skin_func()
-- end
if isButtonPressed(PLAYER_HANDLE, 6) then 
car = getNearCarToCenter(150)
end

if car and isButtonPressed(PLAYER_HANDLE, 6) and not isPlayerTargettingChar(PLAYER_HANDLE, ped) then
	local stored_chars = store_chars_in_vehicle(car)
	local busy_place = 0
	for i, v in pairs(stored_chars) do
	  if v[2] == -1 then
		-- print((u8:decode("мМесто %s не занято никем")):format(v[1]))
	  elseif v[1] == 0 then
		-- print((u8:decode("мМесто %s занято: PED %s")):format(v[1], v[2]))
		-- busy_place = busy_place + 1
		
		ped = v[2]
		ped_last = ped
		result = true
	  end
	end
	-- if busy_place == 0 then
	  -- print(u8:decode("Все места в машине свободны!"))
	-- end
	
	-- end
end


			-- if result and check_aiming_ped() and ped == ped_last then
			if result and isPlayerTargettingChar(PLAYER_HANDLE, ped) and not isPlayerTargettingAnything(PLAYER_HANDLE) and ped == ped_last and isButtonPressed(PLAYER_HANDLE, 6) or result and not isPlayerTargettingChar(PLAYER_HANDLE, ped) and not isPlayerTargettingAnything(PLAYER_HANDLE) and ped == ped_last and isButtonPressed(PLAYER_HANDLE, 6) then
			-- if result and isButtonPressed(PLAYER_HANDLE, 6) and ped == ped_last and not isPlayerTargettingAnything(PLAYER_HANDLE) then
			-- print(getGroupMember(getPlayerGroup(PLAYER_HANDLE), 0))
			-- print(ped)
				display_texture(sprites['hp_boarded'], convert_x(94.0), convert_y(11.0), convert_x(141.8), convert_y(22))
	
				display_texture(sprites['boarded'], convert_x(94.0), convert_y(20.5), convert_x(141.8), convert_y(24.8))
				
				---------------------Targeting health---------------------
				if Targeting_Health_Damage == nil then Targeting_Health_Damage = { getCharHealth(ped), nil, nil, nil } end
				math.randomseed(tonumber(tostring(os.clock()):match('%.(%d)')) or 0)
				if Targeting_Health_Damage[1] ~= getCharHealth(ped) then
					local GiveHP = getCharHealth(ped) - Targeting_Health_Damage[1]
					Targeting_Health_Damage = { getCharHealth(ped), getCharHealth(ped) - GiveHP, GiveHP, GiveHP > 0 and os.clock() - 0.5 or os.clock() }
				end

					if Targeting_Health_Damage[4] == nil or (os.clock() - Targeting_Health_Damage[4] > 1.0) then
						if getCharHealth(ped) <= 100 then
							display_texture(sprites['hp'], convert_x(94.0), convert_y(11.0), convert_x(141.8-(47.8-((48.3/100)*getCharHealth(ped)))), convert_y(20.5))
						else
							display_texture(sprites['hp'], convert_x(94.0), convert_y(11.0), convert_x(141.8), convert_y(20.5))
						end
					else
						if not Targeting_blicking_Health then
							Targeting_blicking_Health = lua_thread.create(function()
								Targeting_blick_Health = not Targeting_blick_Health
								wait(125)
							Targeting_blicking_Health = nil
							end)
						end
						if Targeting_blick_Health then
							if getCharHealth(ped) <= 100 then
								display_texture(sprites['hp_blick'], convert_x(94.0), convert_y(11.0), convert_x(141.8-(47.8-((48.3/100)*getCharHealth(ped)))), convert_y(20.5))
							else
								display_texture(sprites['hp_blick'], convert_x(94.0), convert_y(11.0), convert_x(141.8), convert_y(20.5))
							end
						else
							if getCharHealth(ped) <= 100 then
								display_texture(sprites['hp'], convert_x(94.0), convert_y(11.0), convert_x(141.8-(47.8-((48.3/100)*getCharHealth(ped)))), convert_y(20.5))
							else
								display_texture(sprites['hp'], convert_x(94.0), convert_y(11.0), convert_x(141.8), convert_y(20.5))
							end
						end
					end
				---------------------Targeting health---------------------
				---------------------Targeting Armour and Sprint---------------------
				if Targeting_Armour_Damage == nil then Targeting_Armour_Damage = { getCharArmour(ped), nil, nil, nil } end
				math.randomseed(tonumber(tostring(os.clock()):match('%.(%d)')) or 0)
				if Targeting_Armour_Damage[1] ~= getCharArmour(ped) then
					local GiveHP = getCharArmour(ped) - Targeting_Armour_Damage[1]
					Targeting_Armour_Damage = { getCharArmour(ped), getCharArmour(ped) - GiveHP, GiveHP, GiveHP > 0 and os.clock() - 0.5 or os.clock() }
				end

				if Targeting_Armour_Damage[4] == nil or (os.clock() - Targeting_Armour_Damage[4] > 1.0) then
					if getCharArmour(ped) <= 100 then
						display_texture(sprites['armour'], convert_x(94.0), convert_y(21.0), convert_x(141.8-(47.8-((47.8/100)*getCharArmour(ped)))), convert_y(25.0))
					else
						display_texture(sprites['armour'], convert_x(94.0), convert_y(21.0), convert_x(141.8), convert_y(25.0))
					end
				else
					if not Targeting_blicking_armour then
						Targeting_blicking_armour = lua_thread.create(function()
							Targeting_blick_armour = not Targeting_blick_armour
							wait(125)
						Targeting_blicking_armour = nil
						end)
					end
	
					if Targeting_blick_armour then
						if getCharArmour(ped) <= 100 then
							display_texture(sprites['armour_blick'], convert_x(94.0), convert_y(21.0), convert_x(141.8-(47.8-((47.8/100)*getCharArmour(ped)))), convert_y(20))
						else
							display_texture(sprites['armour_blick'], convert_x(94.0), convert_y(21.0), convert_x(141.8), convert_y(25.0))
						end
					else
						if getCharArmour(ped) <= 100 then
							display_texture(sprites['armour'], convert_x(94.0), convert_y(21.0), convert_x(141.8-(47.8-((47.8/100)*getCharArmour(ped)))), convert_y(25.0))
						else
							display_texture(sprites['armour'], convert_x(94.0), convert_y(21.0), convert_x(141.8), convert_y(25.0))
						end
					end
				end
				---------------------Armour and Sprint---------------------
				
				-- Actor_Smoke = 130,
-- Actor_Sweet = 131,
-- Actor_Ryder = 132,
-- Actor_Cesar = 133,
-- Actor_OG_Loc = 134,
-- Smoke_Car = 135,
-- Sweet_Car = 136,
-- Ryder_Car = 137,
-- Actor_Truth = 146,
-- Actor_Catalina = 147,
				for i = 130, 146 do
					if ped ~= getGameGlobal(i) then 
					-- testwaea = true
					goto continue 
					testwaea = true
					end
				if ped == getGameGlobal(i) and isCharMale(getGameGlobal(i)) then			
					if i == 131 then
						testwaea = false
						display_texture(sprites['skin_270'], convert_x(167.5), convert_y(9.0), convert_x(143.0), convert_y(34.0))						
					elseif i == 130 then
						testwaea = false
						display_texture(sprites['skin_269'], convert_x(167.5), convert_y(9.0), convert_x(143.0), convert_y(34.0))

					elseif i == 132 then
						testwaea = false
						display_texture(sprites['skin_271'], convert_x(167.5), convert_y(9.0), convert_x(143.0), convert_y(34.0))
					-- end
					-- print(getCharModel(ped))
					elseif i == 133 then
						testwaea = false
						display_texture(sprites['skin_292'], convert_x(167.5), convert_y(9.0), convert_x(143.0), convert_y(34.0))
					elseif i == 134 then
						testwaea = false
						display_texture(sprites['skin_293'], convert_x(167.5), convert_y(9.0), convert_x(143.0), convert_y(34.0))
					elseif i == 146 then
						testwaea = false
						display_texture(sprites['skin_1'], convert_x(167.5), convert_y(9.0), convert_x(143.0), convert_y(34.0))
					elseif i == 147 then
						testwaea = false
						display_texture(sprites['skin_298'], convert_x(167.5), convert_y(9.0), convert_x(143.0), convert_y(34.0))
					end
				-- else
					-- testwaea = true
				end
				::continue::
				end
				if testwaea then
					display_texture(sprites['skin_'..getCharModel(ped)], convert_x(167.5), convert_y(9.0), convert_x(143.0), convert_y(34.0))
				end 
				display_texture(sprites['hud_maininvert'], convert_x(89.2), convert_y(4), convert_x(170.0), convert_y(38.5))
				
				display_texture(sprites['guns_'..getCurrentCharWeapon(ped)], convert_x(159), convert_y(25), convert_x(169), convert_y(36.0))
				
				if random_name_male and check_name_tbl(table_ped_handle, ped) then
					random_name_male = false
					if ped == getGameGlobal(glob.Actor_Ryder) then
						setGxtEntry(Gxt_random_name, "Lance 'Ryder' Wilson")
					else
						setGxtEntry(Gxt_random_name, table_ped_handle[ped])
					end
					-- setGxtEntry(Gxt_random_name, table_ped_handle[ped])
				elseif random_name_male and not check_name_tbl(table_ped_handle, ped) then
					random_name_male = false
					random_name_male_func(ped)
				end
					
				setTextCentre(true)
				if getGxtText(Gxt_random_name):len() <= 13 then
					setTextScale(0.2, 0.85)
				elseif getGxtText(Gxt_random_name):len() <= 15 then
					setTextScale(0.18, 0.85)
				elseif getGxtText(Gxt_random_name):len() <= 20 then
					setTextScale(0.16, 0.85)
				elseif getGxtText(Gxt_random_name):len() <= 25 then
					setTextScale(0.14, 0.85)
				end
				setTextFont(1)
				setTextEdge(1.0, 0, 0, 0, 50)
				setTextProportional(true)
				setTextDropshadow(1, 74, 74, 74, 50)
				setTextDrawBeforeFade(true)
				displayText(120, 27.3, Gxt_random_name)
				
			else
				targeting_skin = true
				random_name_male = true
				testwaea = true
				for k, v in pairs(table_ped_handle) do
					if not doesCharExist(k) then
						table_ped_handle[k] = nil
					end
				end
			end
			
			-- print(PLAYER_HANDLE)
			local posY_group = 0
			local posY_group2 = posY_group - 0.5
			for i = 0, 7 do
			if getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) ~= -1 then
			-- local testadawdawd_buff = {'body_armour', 'body_stamina', 'o2_icon', 'hp_plus'}
			-- local x_buff, y_buff = 545.0 - 3 * 16, 9.5
			-- local posX_buff, posY_buff, posY_buff2 = x_buff, y_buff - (y_buff-2), y_buff + y_buff-3
			
			-- local column_buff = 1
			
			if getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) == -1 and i == i then goto continue end
			if getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) == 1 and i == i then goto continue end
			display_texture(sprites['hp_boarded'], convert_x(27.0), convert_y(49.0+posY_group), convert_x(67.0), convert_y(53+posY_group+posY_group2))

			display_texture(sprites['boarded'], convert_x(27.0), convert_y(52.0+posY_group), convert_x(67.0), convert_y(56+posY_group+posY_group2))
			
			if getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) == getGameGlobal(glob.Actor_Ryder) then
			-- print(getGroupMember(getPlayerGroup(PLAYER_HANDLE), 0))
			-- print(string.format("%s", getGameGlobal(glob.Actor_Ryder)))
				display_texture(sprites['skin_271'], convert_x(5), convert_y(42.0+posY_group), convert_x(26.0), convert_y(59.0+posY_group+posY_group2))
			else
				display_texture(sprites['skin_'..getCharModel(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))], convert_x(5), convert_y(42.0+posY_group), convert_x(26.0), convert_y(59.0+posY_group+posY_group2))
			end
				---------------------Group  health---------------------
				-- if i == i then
				if Group_Health_Damage['test_'..i] == nil then Group_Health_Damage['test_'..i] = {getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)), nil, nil, nil } end
				
				math.randomseed(tonumber(tostring(os.clock()):match('%.(%d)')) or 0)
				-- print(unpack(Group_Health_Damage['test_'..i]))
				if Group_Health_Damage['test_'..i][1] ~= getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) then
				-- print('123')
					local GiveHP = getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) - Group_Health_Damage['test_'..i][1]
					-- Group_Health_Damage = {['test_'..i] = {getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)), getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) - GiveHP, GiveHP, GiveHP > 0 and os.clock() - 0.5 or os.clock() }}
					Group_Health_Damage['test_'..i] = {getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)), getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) - GiveHP, GiveHP, GiveHP > 0 and os.clock() - 0.5 or os.clock() }
				end

				if Group_Health_Damage['test_'..i][4] == nil or (os.clock() - Group_Health_Damage['test_'..i][4] > 1.0) then
					-- if Group_Health_Damage['test_'..i][4] == nil or (os.clock() - Group_Health_Damage['test_'..i][4] > 1.0) then
					if getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) <= 100 then
						display_texture(sprites['hp'], convert_x(27.0), convert_y(49.0+posY_group), convert_x(67-(40-((40/100)*getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))))), convert_y(53+posY_group+posY_group2))
					else
						display_texture(sprites['hp'], convert_x(27.0), convert_y(49.0+posY_group), convert_x(67.0), convert_y(53+posY_group+posY_group2))
					end
					-- end --- DELETE
				elseif (os.clock() + Group_Health_Damage['test_'..i][4] > 1.0) and i == i then
					if not Group_blicking_Health then
						Group_blicking_Health = lua_thread.create(function()
							Group_blick_Health = not Group_blick_Health
							wait(125)
						Group_blicking_Health = nil
						end)
					end
					if Group_blick_Health then
						if getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) <= 100 then
							display_texture(sprites['hp_blick'], convert_x(27.0), convert_y(49.0+posY_group), convert_x(67-(40-((40/100)*getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))))), convert_y(53+posY_group+posY_group2))
						else
							display_texture(sprites['hp_blick'], convert_x(27.0), convert_y(49.0+posY_group), convert_x(67.0), convert_y(53+posY_group+posY_group2))
						end
					else
						if getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) <= 100 then
							display_texture(sprites['hp'], convert_x(27.0), convert_y(49.0+posY_group), convert_x(67-(40-((40/100)*getCharHealth(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))))), convert_y(53+posY_group+posY_group2))
						else
							display_texture(sprites['hp'], convert_x(27.0), convert_y(49.0+posY_group), convert_x(67.0), convert_y(53+posY_group+posY_group2))
						end
					end
				end
				-- end
				---------------------Group  health---------------------
				-- -------------------Group  Armour and Sprint---------------------
				-- if Group_Armour_Damage == nil then Group_Armour_Damage = { getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)), nil, nil, nil } end
				-- math.randomseed(tonumber(tostring(os.clock()):match('%.(%d)')) or 0)
				-- if Group_Armour_Damage[1] ~= getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) then
					-- local GiveHP = getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) - Group_Armour_Damage[1]
					-- Group_Armour_Damage = { getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)), getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) - GiveHP, GiveHP, GiveHP > 0 and os.clock() - 0.5 or os.clock() }
				-- end

				-- if Group_Armour_Damage[4] == nil or (os.clock() - Group_Armour_Damage[4] > 1.0) then
					-- if getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) <= 100 then
						-- display_texture(sprites['armour'], convert_x(27.0), convert_y(52.0+posY_group), convert_x(67.0-(40-((40/100)*getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))))), convert_y(56.0+posY_group+posY_group2))
					-- else
						-- display_texture(sprites['armour'], convert_x(27.0), convert_y(52.0+posY_group), convert_x(67.0), convert_y(56+posY_group+posY_group2))
					-- end
				-- else
					-- if not Group_blicking_armour then
						-- Group_blicking_armour = lua_thread.create(function()
							-- Group_blick_armour = not Group_blick_armour
							-- wait(125)
						-- Group_blicking_armour = nil
						-- end)
					-- end
	
					-- if Group_blick_armour then
						-- if getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) <= 100 then
							-- display_texture(sprites['armour_blick'], convert_x(27.0), convert_y(52.0+posY_group), convert_x(67.0-(40-((40/100)*getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))))), convert_y(56.0+posY_group+posY_group2))
						-- else
							-- display_texture(sprites['armour_blick'], convert_x(27.0), convert_y(52.0+posY_group), convert_x(67.0), convert_y(56+posY_group+posY_group2))
						-- end
					-- else
						-- if getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) <= 100 then
							-- display_texture(sprites['armour'], convert_x(27.0), convert_y(52.0+posY_group), convert_x(67.0-(40-((40/100)*getCharArmour(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))))), convert_y(56.0+posY_group+posY_group2))
						-- else
							-- display_texture(sprites['armour'], convert_x(27.0), convert_y(52.0+posY_group), convert_x(67.0), convert_y(56+posY_group+posY_group2))
						-- end
					-- end
				-- end
				-- ---------------------Group Armour and Sprint---------------------
			
			display_texture(sprites['hud_friend'], convert_x(4.3), convert_y(40+posY_group), convert_x(67.1), convert_y(60.5+posY_group+posY_group2))
			-- print(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))
			display_texture(sprites['guns_'..getCurrentCharWeapon(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))], convert_x(5), convert_y(51+posY_group), convert_x(15), convert_y(62.0+posY_group+posY_group2))
			-- print(getGroupMember(getPlayerGroup(PLAYER_HANDLE), 0))
			-- print(string.format("%s", getGameGlobal(glob.Actor_Ryder)))
			-- lua_thread.create(function() 
			-- print(ped)
			-- wait(10)
				-- if random_name_male and check_name_tbl(table_ped_handle, getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) then
						
						
						if i == 0 then
							if getGameGlobal(glob.Actor_Ryder) == getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) then
								setGxtEntry(Gxt_random_name_group0, '"Lance "Ryder" Wilson')
							else
								setGxtEntry(Gxt_random_name_group0, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
							end
						elseif i == 1 then
							if getGameGlobal(glob.Actor_Ryder) == getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) then
								setGxtEntry(Gxt_random_name_group1, '"Lance "Ryder" Wilson')
							else
								setGxtEntry(Gxt_random_name_group1, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
							end
						-- setGxtEntry(Gxt_random_name_group1, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
						elseif i == 2 then
							if getGameGlobal(glob.Actor_Ryder) == getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) then
								setGxtEntry(Gxt_random_name_group2, '"Lance "Ryder" Wilson')
							else
								setGxtEntry(Gxt_random_name_group2, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
							end
						-- setGxtEntry(Gxt_random_name_group2, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
						elseif i == 3 then
							if getGameGlobal(glob.Actor_Ryder) == getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) then
								setGxtEntry(Gxt_random_name_group3, '"Lance "Ryder" Wilson')
							else
								setGxtEntry(Gxt_random_name_group3, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
							end
						-- setGxtEntry(Gxt_random_name_group3, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
						elseif i == 4 then
							if getGameGlobal(glob.Actor_Ryder) == getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) then
								setGxtEntry(Gxt_random_name_group4, '"Lance "Ryder" Wilson')
							else
								setGxtEntry(Gxt_random_name_group4, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
							end
						-- setGxtEntry(Gxt_random_name_group4, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
						elseif i == 5 then
							if getGameGlobal(glob.Actor_Ryder) == getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) then
								setGxtEntry(Gxt_random_name_group5, '"Lance "Ryder" Wilson')
							else
								setGxtEntry(Gxt_random_name_group5, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
							end
						-- setGxtEntry(Gxt_random_name_group5, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
						elseif i == 6 then
							if getGameGlobal(glob.Actor_Ryder) == getGroupMember(getPlayerGroup(PLAYER_HANDLE), i) then
								setGxtEntry(Gxt_random_name_group6, '"Lance "Ryder" Wilson')
							else
								setGxtEntry(Gxt_random_name_group6, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
							end
						-- setGxtEntry(Gxt_random_name_group6, table_ped_handle[getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)])
						end
						
				-- elseif random_name_male and not check_name_tbl(table_ped_handle, getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) then
				if random_name_male and not check_name_tbl(table_ped_handle, getGroupMember(getPlayerGroup(PLAYER_HANDLE), i)) then
						-- -- if i == 0 then
-- -- random_name_male_func(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))						elseif i == 1 then
-- -- random_name_male_func(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))						elseif i == 2 then
-- -- random_name_male_func(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))						elseif i == 3 then
-- -- random_name_male_func(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))						elseif i == 4 then
-- -- random_name_male_func(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))						elseif i == 5 then
-- -- random_name_male_func(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))						elseif i == 6 then
-- -- random_name_male_func(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))						end
					random_name_male_func(getGroupMember(getPlayerGroup(PLAYER_HANDLE), i))
					-- random_name_male = false
					-- else
					-- random_name_male = true
				end
				-- end)
					-- print(unpack(testdad))
				setTextCentre(true)
				if getGxtText(testdad[i+1]):len() <= 13 then
					setTextScale(0.16, 0.62)
				elseif getGxtText(testdad[i+1]):len() <= 15 then
					setTextScale(0.14, 0.60)
				elseif getGxtText(testdad[i+1]):len() <= 20 then
					setTextScale(0.12, 0.58)
				elseif getGxtText(testdad[i+1]):len() <= 25 then
					setTextScale(0.10, 0.56)
				end
				setTextFont(1)
				setTextColour(255, 255, 255, 220)
				setTextEdge(1.0, 0, 0, 0, 120)
				setTextProportional(true)
				setTextDropshadow(1, 50, 50, 50, 120)
				setTextDrawBeforeFade(true)
				displayText(47, 43.3+posY_group, testdad[i+1])
				-- print(unpack(testdad))
				-- print(Gxt_random_name_group0)
							-- display_texture(sprites[testadawdawd_buff[i]], convert_x(posX_buff), convert_y(posY_buff), convert_x(posX_buff+posY_buff2), convert_y(posY_buff+posY_buff2), 255, 255, 255, 250)
			-- end
				
				-- if column_group < 5 then
					-- column_buff = column_buff + 1
					
					-- posX_buff = posX_buff - 16
					-- -- posY_buff = y_buff - 16
				-- else
					-- column_buff = 1
					-- posX_buff = x_buff
					-- -- posY_buff2 = y_buff
					posY_group =  posY_group + 21
				-- end
				
			end
			::continue::
			end
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			local testadawdawd_buff = {'body_armour', 'body_stamina', 'o2_icon', 'hp_plus'}
			local x_buff, y_buff = 545.0 - 3 * 16, 9.5
			local posX_buff, posY_buff, posY_buff2 = x_buff, y_buff - (y_buff-2), y_buff + y_buff-3
			local column_buff = 1
			
			for i = 1, #testadawdawd_buff do
				if not isCharInWater(PLAYER_PED) and i == 3 then 
					goto continue
				elseif isCharInWater(PLAYER_PED) and i == 3 then
				setTextCentre(true)
				setTextFont(2)
				setTextScale(0.15, 1.2)
				setTextColour(255, 255, 255, 200)
				setTextEdge(1, 0, 0, 0, 100)
				setTextProportional(true)
				setTextDropshadow(1, 74, 74, 74, 50)
				setTextDrawBeforeFade(true)
				Gxt_oxygen = setFreeGxtEntry(oxygen..'%')
				displayText(posX_buff+9.1, posY_buff+2.5, Gxt_oxygen)
				-- goto continue
									-- display_texture(sprites['hp_plus'], convert_x(100), convert_y(100), convert_x(300), convert_y(200), 255, 255, 255, 100)

				end
				-- drawBuff(testadawdawd_buff[i], posX_buff, posY_buff, i and (16 + 2) or 16)
				-- display_texture(sprites[testadawdawd_buff[i]], convert_y(posX_buff), convert_y(posY_buff+posY_buff2), convert_y(posY_buff+posX_buff), convert_y(posY_buff+posY_buff2))
				-- display_texture(sprites[testadawdawd_buff[i]], convert_x(posX_buff), convert_y(posY_buff), convert_x(posX_buff+posY_buff2), convert_y(posY_buff+posY_buff2), 255, 255, 255, 250)
			if x_mouse > posX_buff and y_mouse > posY_buff and posX_buff+posY_buff2 > x_mouse and posY_buff+posY_buff2 > y_mouse then
				display_texture(sprites[testadawdawd_buff[i]], convert_x(posX_buff), convert_y(posY_buff), convert_x(posX_buff+posY_buff2), convert_y(posY_buff+posY_buff2), 255, 255, 255, 100)
				if wasKeyPressed(1) then
					print(i)
					display_texture(sprites[testadawdawd_buff[i]], convert_x(posX_buff), convert_y(posY_buff), convert_x(posX_buff+posY_buff2), convert_y(posY_buff+posY_buff2), 255, 255, 255, 255)
					help_buff_time = os.clock() + (1*4.2)
					if i == 4 then
						help_text_main_buff = setFreeGxtEntry('This buff means that you have more than 100 health points, as soon as it disappears, the health will begin to decrease from the main HP bar.')
					elseif i == 1 then
						help_text_main_buff = setFreeGxtEntry('This buff means that you have more than 100 armour points, as soon as it disappears, the armour will begin to decrease from the main HP bar.')
					elseif i == 2 then
						help_text_main_buff = setFreeGxtEntry("Just a test. When I'm done, it'll be fat or lean or muscular. May be.")
					elseif i == 3 then
						help_text_main_buff = setFreeGxtEntry('The current smell of oxygen. Now:'..oxygen..'%. To increase the maximum value, upgrade your stamina.')
						
					end
					help_gxt_main_buff = true
					if getGxtText(help_text_main_buff):len() <= 20 then
						help_gxt_time = os.clock() + (1*3.2)
					elseif getGxtText(help_text_main_buff):len() >= 21 then
						help_gxt_time = os.clock() + (1*6.2)
					end
				-- displayText(120, 27.3, Gxt_random_name)
				end
			else
				display_texture(sprites[testadawdawd_buff[i]], convert_x(posX_buff), convert_y(posY_buff), convert_x(posX_buff+posY_buff2), convert_y(posY_buff+posY_buff2), 255, 255, 255, 250)
			end
				
				if column_buff < 5 then
					column_buff = column_buff + 1
					
					posX_buff = posX_buff - 16
					-- posY_buff = y_buff - 16
				else
					column_buff = 1
					posX_buff = x_buff
					-- posY_buff2 = y_buff
					posY_buff = posY_buff + 16
				end
				::continue::
			end
-- -- callMethod(0x535FA0, pointer, 0, 0)
			-- if x_mouse > 497.0 and y_mouse > 0.5 and 514.0 > x_mouse and 19.0 > y_mouse then
				-- display_texture(sprites['hp_plus'], convert_x(100), convert_y(100), convert_x(200), convert_y(200), 255, 255, 255, 100)
				-- if wasKeyPressed(1) then
					-- display_texture(sprites['hp_plus'], convert_x(100), convert_y(100), convert_x(200), convert_y(200), 255, 255, 255, 255)
					-- help_buff_time = os.clock() + (1*4.2)
					-- help_text_main_buff = setFreeGxtEntry('This buff means that you have more than 100 health points, as soon as it disappears, the health will begin to decrease from the main HP bar.')
					-- help_gxt_main_buff = true
					-- if getGxtText(help_text_main_buff):len() <= 20 then
						-- help_gxt_time = os.clock() + (1*3.2)
					-- elseif getGxtText(help_text_main_buff):len() >= 21 then
						-- help_gxt_time = os.clock() + (1*6.2)
					-- end
				-- -- displayText(120, 27.3, Gxt_random_name)
				-- end
			-- else
				-- display_texture(sprites['hp_plus'], convert_x(100), convert_y(100), convert_x(200), convert_y(200), 255, 255, 255, 250)
			-- end
			if help_gxt_main_buff then
				setTextScale(0.23, 0.77)
				setTextFont(1)
				setTextEdge(1.0, 0, 0, 0, 50)
				setTextColour(255, 255, 255, 225)
				setTextProportional(true)
				setTextDropshadow(1, 20, 20, 20, 50)
				setTextCentre(true)
				setTextDrawBeforeFade(true)
				setTextCentreSize(174.0)
				
				display_texture(sprites['help_parchment'], convert_x(215), convert_y(4), convert_x(425.0), convert_y(39))
				
				if getGxtText(help_text_main_buff):len() <= 41 then
					displayText(320, 19, help_text_main_buff)						
				elseif getGxtText(Gxt_Window_test):len() <= 76 then
					displayText(320, 8, help_text_main_buff)
				elseif getGxtText(Gxt_Window_test):len() >= 77 then
					displayText(320, 8, help_text_main_buff)
				end

				if help_gxt_time < os.clock() then
					help_gxt_time = os.clock() + (1*0)
					help_gxt_main_buff = false
				end
			end
			
			

			


			
						
			if wasKeyPressed(117) then
				lock_player = not lock_player
				if lock_player then
						setPlayerControl(PLAYER_HANDLE, false)
						x_mouse = 325.0
						y_mouse = 225.0
					else
						setPlayerControl(PLAYER_HANDLE, true)
						-- showCursor(false, false)
				end
			end

			if lock_player then
				x_mouse_Pc, y_mouse_PC = getPcMouseMovement()
				x_mouse = x_mouse + x_mouse_Pc
				y_mouse = y_mouse + -y_mouse_PC
				if x_mouse > 638.0 then	x_mouse= 638.0 end
				if 0.0 > x_mouse then x_mouse = 0.0 end
				if y_mouse > 440.0 then y_mouse = 440.0 end
				if 0.0 > y_mouse then y_mouse = 0.0 end

				display_texture(sprites['mouse_hud'], convert_x(x_mouse), convert_y(y_mouse), convert_x(x_mouse+15), convert_y(y_mouse+15))
			end
		end
	end
end


function store_chars_in_vehicle(vehicle_handle)
  if not doesVehicleExist(vehicle_handle) then return false end
  local stored_data = {}
  for i = -1, getMaximumNumberOfPassengers(vehicle_handle) - 1 do
    if not isCarPassengerSeatFree(vehicle_handle, i) then
      stored_data[#stored_data + 1] = {
        i+1, getCharInCarPassengerSeat(vehicle_handle, i)
      }
    else stored_data[#stored_data + 1] = {i+1, -1} end
  end
  return stored_data
end

function getNearCarToCenter(radius)
    local arr = {}
    local sx, sy = getScreenResolution()
    for _, car in ipairs(getAllVehicles()) do
        if isCarOnScreen(car) and getDriverOfCar(car) ~= playerPed then
            local carX, carY, carZ = getCarCoordinates(car)
            local cX, cY = convert3DCoordsToScreen(carX, carY, carZ)
            local distBetween2d = getDistanceBetweenCoords2d(sx / 2, sy / 2, cX, cY)
            if distBetween2d <= tonumber(radius and radius or sx) then
                table.insert(arr, {distBetween2d, car})
            end
        end
    end
    if #arr > 0 then
        table.sort(arr, function(a, b) return (a[1] < b[1]) end)
        return arr[1][2]
    end
    return nil
end




-- ffi.cast('bool *', 0xB7CB49)
-- user_pause 	= ffi.cast('bool *', 0xB7CB49)

-- print(readMemory(0x86969C, 1, false))
function getActiveCamMode()
    local activeCamId = memory.getint8(0x00B6F028 + 0x59)
    return getCamMode(activeCamId)
end

function getCamMode(id)
    local cams = 0x00B6F028 + 0x174
    local cam = cams + id * 0x238
    return memory.getint16(cam + 0x0C)
end

-- 0x522C80, 0xC3
	-- print(memory.getuint8(0x522C80+0xC3, true))
	-- memory.fill(0x58FC3E, 0x90, 14) -- Disable radar map hiding when pressing TAB (action key) while on foot
	
	-- memory.fill(0x57BA57, 0x90, 6); --  Disable the GTASA main menu.
-- print(memory.getfloat(getCharPointer(PLAYER_PED) + 0x544))
	-- print(memory.getint8(0x522C80+0xC3))
function patches()
	memory.setuint8(0x522C80, 0xC3, true) -- Disable idle cam
	
	
	-- --ALLOW more than 8 players (crash with more if this isn't done)
	-- memory.write(0x60D64D, 0x90, 1, true)
	-- memory.write(0x60D64E, 0xE9, 1, true)
	
	-- --DISABLE STATS MESSAGES
	-- memory.write(0x55B980, 0xC3, 1, true)
	-- memory.write(0x559760, 0xC3, 1, true)
	
	
	-- memory.write(0x53BC78, 0x00, 1) --Disable MENU AFTER alt + tab
	
	-- memory.write(0x561AF6, 0x00, 1) --// Hack to make the game run in the background when paused


	 -- memory.setint32(0x551177 , 9001) --Increase the events pool size
 -- memory.write(0x86D1EC, 0x0, 1, true)
-- memory.fill(0x561AF0, 0x90, 7, true)
  -- memory.write(0x47C477, 0xEB, 1, true)
   -- memory.fill(0x748063, 0x90, 5, true)
   -- memory.write(0x588BE0, 0xC3, 1, true)
    -- memory.write(0x588BE0+0xC3, 1, 1, true)
  -- print(memory.read(0x588BE0+0xc0, 1, true))
end

-- Проверяет, целится ли игрок с пассажирского места
-- Lua:
function isCharTargettingAsPassenger()
    return memory.getint8(0xB6FC70) == 1
end
-- print(readMemory(0xB701531, 4, true)) 
-- print(memory.getint8(0xBAA474))
-- print(memory.getint32(0xBA6748+0x24))
-- ryde = getGameGlobal(glob.Actor_Ryder)
-- print(getCharCoordinates(glob.Actor_Ryder))
-- special_skins={[3]='ANDRE',[4]='BBTHIN',[5]='BB',[298]='CAT',[292]='CESAR',[190]='COPGRL3',[299]='CLAUDE',[194]='CROGRL3',[268]='DWAYNE',
-- [6]='EMMET',[272]='FORELLI',[195]='GANGRL3',[191]='GUNGRL3',[267]='HERN',[8]='JANITOR',[42]='JETHRO',[296]='JIZZY',[65]='KENDL',[2]='MACCER',
-- [297]='MADDOGG',[192]='MECGRL3',[193]='NURGRL2',[293]='OGLOC',[291]='PAUL',[266]='PULASKI',[290]='ROSE',[271]='RYDER',[86]='RYDER3',[119]='SINDACO',
-- [269]='SMOKE',[149]='SMOKEV',[208]='SUZIE',[270]='SWEET',[273]='TBONE',[265]='TENPEN',[295]='TORINO',[1]='TRUTH',[294]='WUZIMU',[289]='ZERO',
-- [300]='LAPDNA',[301]='SFPDNA',[302]='LVPDNA',[303]='LAPDPC',[304]='LAPDPD',[305]='LVPDPC',[306]='WFYCLPD',[307]='VBFYCPD',[308]='WFYCLEM',
-- [309]='WFYCLLV',[310]='CSHERNA',[311]='DSHERNA',[312]='COPGRL1'}

-- function set_skin(skin)
  -- local is_special = false
  -- if special_skins[skin] then
    -- is_special = true; loadSpecialCharacter(special_skins[skin], 1)
  -- else requestModel(skin) loadAllModelsNow() end
  -- setPlayerModel(PLAYER_HANDLE, is_special and 290 or skin)
  -- if is_special then unloadSpecialCharacter(1)
  -- else markModelAsNoLongerNeeded(skin) end
-- end

--draw_text(string text, float x, float y, [uint style, float width, float height, uint align, float wrap, bool proportional, bool justify, int text_r, int text_g, int text_b, int text_a, uint outline, uint shadow, int shadow_r, int shadow_g, int shadow_b, int shadow_a, bool background, int background_r, int background_g, int background_b, int background_a])

-- style = {"GOTHIC","SUBTITLES","MENU","PRICEDOWN"}
-- align = {{"Центру","CENTER"},{"Левому краю","LEFT"},{"Правому краю","RIGHT"}}
-- {x = 500, y = 400, text = "%d %%", text_style = 1, text_align = 1, mode = false, text_size = 0.6
-- function draw_text(str, x, y, text_style, text_size, mode, )
	
-- end
testwaea = true

				-- [int r, int g, int b, int a, float angle]
lock_player = false
x_mouse = 325.0
y_mouse = 225.0
-- setPlayerControl(PLAYER_HANDLE, true)
-- freezeCharPosition(PLAYER_PED, true)
-- lockPlayerControl(false)
	-- cameraPersistPos(false)
-- showCursor(false, false)

targeting_skin = true
function targeting_skin_func()
	result, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
	ped_last = ped
	targeting_skin = false
end

table_ped_handle = {}
random_name_male = true
function random_name_male_func(ped)
	math.randomseed(os.clock())
	if getGenderBySkinId(getCharModel(ped)) == 'male' then
		random_name_male_text = mainIni.male[math.random(1, #mainIni.male)]
	elseif getGenderBySkinId(getCharModel(ped)) == 'female' then
		random_name_male_text = mainIni.female[math.random(1, #mainIni.female)]
	end
	Gxt_random_name = setFreeGxtEntry(random_name_male_text)
	table_ped_handle[ped] = random_name_male_text
	random_name_male = false
end

function check_name_tbl(t, str)
	for k, v in pairs(t) do
		if k == str then return true end
	end
	return false
end

function getGenderBySkinId(skinId)
	local skins = {male = {0, 1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 86, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 149, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 206, 208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 304, 305, 310, 311}, 
	female = {9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298, 306, 307, 308, 309}}
	for k, v in pairs(skins) do
		for m, n in pairs(v) do
			if n == skinId then
				return k
			end
		end
	end
	return 'Skin not found'
end


function split(str, delim, plain)
	local tokens, pos, plain = {}, 1, not (plain == false)
	repeat
		local npos, epos = string.find(str, delim, pos, plain)
		table.insert(tokens, string.sub(str, pos, npos and npos - 1))
		pos = epos and epos + 1
	until not pos
	return tokens
end

function convert_x(x)
	gposX, gposY = convertGameScreenCoordsToWindowScreenCoords(x, x)
	return gposX
end

function convert_y(y)
	gposX, gposY = convertGameScreenCoordsToWindowScreenCoords(y, y)
	return gposY
end

-- print(convert_y(100))

function display_texture(tex, x, y, x2, y2, r, g, b, a, angle)
	tex:draw(x, y, x2, y2, r, g, b, a, angle)
end

function getSprintLocalPlayer()
    local float = memory.getfloat(0xB7CDB4)
    return float/31.47000244
end

function myAmmo()
    return memory.getint32(getCharPointer(PLAYER_PED) + 0x5A0 + memory.getint8(getCharPointer(PLAYER_PED) + 0x0718, false) * 0x1C + 0x8, false)
end



function comma_value(n)
	local num = string.match(n,'(%d+)')
	local result = num:reverse():gsub('(%d%d%d)','%1.'):reverse()
	if string.char(result:byte(1)) == '.' then result = result:sub(2) end
	return result
end

function separator(text)
		for S in string.gmatch(text, "(%d+)") do
			S = string.sub(S, 0, #S)
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)			
	    end
	return text
end

function changeRadarSize(width, height)
    local width, height = tonumber(width), tonumber(height)
    memory.setfloat(0x866B78, width, true)
    memory.setfloat(0x866B74, height, true)
end

function changeRadarPos(posX, posY)
    local positionX = ffi.cast('float*', ffi.C.malloc(4))
    local positionY = ffi.cast('float*', ffi.C.malloc(4))
    positionX[0] = posX
    positionY[0] = posY
    ffi.cast('float**', 0x58A79B)[0] = positionX
    ffi.cast('float**', 0x5834D4)[0] = positionX
    ffi.cast('float**', 0x58A836)[0] = positionX
    ffi.cast('float**', 0x58A8E9)[0] = positionX
    ffi.cast('float**', 0x58A98A)[0] = positionX
    ffi.cast('float**', 0x58A469)[0] = positionX
    ffi.cast('float**', 0x58A5E2)[0] = positionX
    ffi.cast('float**', 0x58A6E6)[0] = positionX

    ffi.cast('float**', 0x58A7C7)[0] = positionY
    ffi.cast('float**', 0x58A868)[0] = positionY
    ffi.cast('float**', 0x58A913)[0] = positionY
    ffi.cast('float**', 0x58A9C7)[0] = positionY
    ffi.cast('float**', 0x583500)[0] = positionY
    ffi.cast('float**', 0x58A499)[0] = positionY
    ffi.cast('float**', 0x58A60E)[0] = positionY
    ffi.cast('float**', 0x58A71E)[0] = positionY
end

function onScriptTerminate(LuaScript, quitGame)
    if LuaScript == thisScript() or quitGame then
		-- ffi.C.free(positionX)
		-- ffi.C.free(positionY)
		setPlayerControl(PLAYER_HANDLE, true)
    end
end

function onExitScript()
    ffi.C.free(positionX)
    ffi.C.free(positionY)
end


function Radar_Disc_Color_Fix()
	writeMemory(0x58A9A2, 1, 255, true)
	writeMemory(0x58A99A, 1, 255, true)
	writeMemory(0x58A996, 1, 255, true)
	writeMemory(0x58A8EE, 1, 255, true)
	writeMemory(0x58A8E6, 1, 255, true)
	writeMemory(0x58A8DE, 1, 255, true)
	writeMemory(0x58A89A, 1, 255, true)
	writeMemory(0x58A896, 1, 255, true)
	writeMemory(0x58A894, 1, 255, true)
	writeMemory(0x58A798, 1, 255, true)
	writeMemory(0x58A790, 1, 255, true)
	writeMemory(0x58A78E, 1, 255, true)
end
-- l_scale_x, l_scale_x = 0, 0
function calculateZoneEN(x, y, z)
    local streets = {
        {"Avispa Country Club", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
        {"Easter Bay Airport", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
        {"Avispa Country Club", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
        {"Easter Bay Airport", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
        {"Garcia", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
        {"Shady Cabin", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
        {"East Los Santos", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
        {"LVA Freight Depot", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
        {"Blackfield Intersection", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
        {"Avispa Country Club", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
        {"Temple", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
        {"Unity Station", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
        {"LVA Freight Depot", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
        {"Los Flores", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
        {"Starfish Casino", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
        {"Easter Bay Chemicals", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
        {"Downtown Los Santos", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
        {"Esplanade East", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
        {"Market Station", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
        {"Linden Station", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
        {"Montgomery Intersection", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
        {"Frederick Bridge", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
        {"Yellow Bell Station", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
        {"Downtown Los Santos", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
        {"Jefferson", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
        {"Mulholland", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
        {"Avispa Country Club", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
        {"Jefferson", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
        {"Julius Thruway West", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
        {"Jefferson", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
        {"Julius Thruway North", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
        {"Rodeo", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
        {"Cranberry Station", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
        {"Downtown Los Santos", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
        {"Redsands West", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
        {"Little Mexico", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
        {"Blackfield Intersection", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
        {"Los Santos International", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
        {"Beacon Hill", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
        {"Rodeo", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
        {"Richman", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
        {"Downtown Los Santos", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
        {"The Strip", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
        {"Downtown Los Santos", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
        {"Blackfield Intersection", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
        {"Conference Center", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
        {"Montgomery", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
        {"Foster Valley", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
        {"Blackfield Chapel", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
        {"Los Santos International", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
        {"Mulholland", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
        {"Yellow Bell Gol Course", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
        {"The Strip", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
        {"Jefferson", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
        {"Mulholland", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
        {"Aldea Malvada", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
        {"Las Colinas", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
        {"Las Colinas", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
        {"Richman", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
        {"LVA Freight Depot", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
        {"Julius Thruway North", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
        {"Willowfield", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
        {"Julius Thruway North", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
        {"Temple", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
        {"Little Mexico", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
        {"Queens", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
        {"Las Venturas Airport", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
        {"Richman", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
        {"Temple", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
        {"East Los Santos", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
        {"Julius Thruway East", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
        {"Willowfield", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
        {"Las Colinas", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
        {"Julius Thruway East", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
        {"Rodeo", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
        {"Las Brujas", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
        {"Julius Thruway East", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
        {"Rodeo", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
        {"Vinewood", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
        {"Rodeo", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
        {"Julius Thruway North", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
        {"Downtown Los Santos", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
        {"Rodeo", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
        {"Jefferson", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
        {"Hampton Barns", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
        {"Temple", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
        {"Kincaid Bridge", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
        {"Verona Beach", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
        {"Commerce", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
        {"Mulholland", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
        {"Rodeo", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
        {"Mulholland", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
        {"Mulholland", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
        {"Julius Thruway South", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
        {"Idlewood", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
        {"Ocean Docks", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
        {"Commerce", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
        {"Julius Thruway North", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
        {"Temple", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
        {"Glen Park", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
        {"Easter Bay Airport", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
        {"Martin Bridge", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
        {"The Strip", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
        {"Willowfield", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
        {"Marina", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
        {"Las Venturas Airport", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
        {"Idlewood", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
        {"Esplanade East", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
        {"Downtown Los Santos", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
        {"The Mako Span", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
        {"Rodeo", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
        {"Pershing Square", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
        {"Mulholland", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
        {"Gant Bridge", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
        {"Las Colinas", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
        {"Mulholland", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
        {"Julius Thruway North", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
        {"Commerce", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
        {"Rodeo", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
        {"Roca Escalante", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
        {"Rodeo", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
        {"Market", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
        {"Las Colinas", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
        {"Mulholland", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
        {"King's", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
        {"Redsands East", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
        {"Downtown", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
        {"Conference Center", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
        {"Richman", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
        {"Ocean Flats", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
        {"Greenglass College", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
        {"Glen Park", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
        {"LVA Freight Depot", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
        {"Regular Tom", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
        {"Verona Beach", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
        {"East Los Santos", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
        {"Caligula's Palace", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
        {"Idlewood", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
        {"Pilgrim", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
        {"Idlewood", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
        {"Queens", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
        {"Downtown", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
        {"Commerce", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
        {"East Los Santos", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
        {"Marina", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
        {"Richman", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
        {"Vinewood", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
        {"East Los Santos", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
        {"Rodeo", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
        {"Easter Tunnel", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
        {"Rodeo", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
        {"Redsands East", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
        {"The Clown's Pocket", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
        {"Idlewood", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
        {"Montgomery Intersection", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
        {"Willowfield", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
        {"Temple", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
        {"Prickle Pine", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
        {"Los Santos International", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
        {"Garver Bridge", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
        {"Garver Bridge", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
        {"Kincaid Bridge", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
        {"Kincaid Bridge", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
        {"Verona Beach", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
        {"Verdant Bluffs", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
        {"Vinewood", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
        {"Vinewood", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
        {"Commerce", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
        {"Market", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
        {"Rockshore West", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
        {"Julius Thruway North", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
        {"East Beach", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
        {"Fallow Bridge", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
        {"Willowfield", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
        {"Chinatown", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
        {"El Castillo del Diablo", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
        {"Ocean Docks", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
        {"Easter Bay Chemicals", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
        {"The Visage", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
        {"Ocean Flats", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
        {"Richman", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
        {"Green Palms", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
        {"Richman", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
        {"Starfish Casino", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
        {"East Beach", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
        {"Jefferson", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
        {"Downtown Los Santos", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
        {"Downtown Los Santos", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
        {"Garver Bridge", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
        {"Julius Thruway South", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
        {"East Los Santos", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
        {"Greenglass College", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
        {"Las Colinas", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
        {"Mulholland", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
        {"Ocean Docks", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
        {"East Los Santos", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
        {"Ganton", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
        {"Avispa Country Club", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
        {"Willowfield", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
        {"Esplanade North", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
        {"The High Roller", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
        {"Ocean Docks", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
        {"Last Dime Motel", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
        {"Bayside Marina", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
        {"King's", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
        {"El Corona", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
        {"Blackfield Chapel", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
        {"The Pink Swan", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
        {"Julius Thruway West", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
        {"Los Flores", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
        {"The Visage", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
        {"Prickle Pine", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
        {"Verona Beach", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
        {"Robada Intersection", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
        {"Linden Side", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
        {"Ocean Docks", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
        {"Willowfield", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
        {"King's", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
        {"Commerce", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
        {"Mulholland", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
        {"Marina", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
        {"Battery Point", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
        {"The Four Dragons Casino", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
        {"Blackfield", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
        {"Julius Thruway North", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
        {"Yellow Bell Gol Course", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
        {"Idlewood", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
        {"Redsands West", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
        {"Doherty", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
        {"Hilltop Farm", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
        {"Las Barrancas", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
        {"Pirates in Men's Pants", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
        {"City Hall", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
        {"Avispa Country Club", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
        {"The Strip", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
        {"Hashbury", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
        {"Los Santos International", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
        {"Whitewood Estates", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
        {"Sherman Reservoir", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
        {"El Corona", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
        {"Downtown", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
        {"Foster Valley", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
        {"Las Payasadas", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
        {"Valle Ocultado", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
        {"Blackfield Intersection", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
        {"Ganton", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
        {"Easter Bay Airport", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
        {"Redsands East", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
        {"Esplanade East", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
        {"Caligula's Palace", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
        {"Royal Casino", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
        {"Richman", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
        {"Starfish Casino", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
        {"Mulholland", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
        {"Downtown", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
        {"Hankypanky Point", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
        {"K.A.C.C. Military Fuels", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
        {"Harry Gold Parkway", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
        {"Bayside Tunnel", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
        {"Ocean Docks", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
        {"Richman", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
        {"Randolph Industrial Estate", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
        {"East Beach", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
        {"Flint Water", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
        {"Blueberry", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
        {"Linden Station", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
        {"Glen Park", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
        {"Downtown", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
        {"Redsands West", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
        {"Richman", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
        {"Gant Bridge", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
        {"Lil' Probe Inn", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
        {"Flint Intersection", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
        {"Las Colinas", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
        {"Sobell Rail Yards", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
        {"The Emerald Isle", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
        {"El Castillo del Diablo", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
        {"Santa Flora", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
        {"Playa del Seville", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
        {"Market", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
        {"Queens", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
        {"Pilson Intersection", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
        {"Spinybed", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
        {"Pilgrim", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
        {"Blackfield", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
        {"'The Big Ear'", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
        {"Dillimore", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
        {"El Quebrados", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
        {"Esplanade North", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
        {"Easter Bay Airport", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
        {"Fisher's Lagoon", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
        {"Mulholland", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
        {"East Beach", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
        {"San Andreas Sound", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
        {"Shady Creeks", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
        {"Market", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
        {"Rockshore West", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
        {"Prickle Pine", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
        {"Easter Basin", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
        {"Leafy Hollow", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
        {"LVA Freight Depot", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
        {"Prickle Pine", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
        {"Blueberry", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
        {"El Castillo del Diablo", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
        {"Downtown", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
        {"Rockshore East", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
        {"San Fierro Bay", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
        {"Paradiso", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
        {"The Camel's Toe", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
        {"Old Venturas Strip", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
        {"Juniper Hill", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
        {"Juniper Hollow", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
        {"Roca Escalante", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
        {"Julius Thruway East", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
        {"Verona Beach", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
        {"Foster Valley", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
        {"Arco del Oeste", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
        {"Fallen Tree", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
        {"The Farm", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
        {"The Sherman Dam", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
        {"Esplanade North", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
        {"Financial", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
        {"Garcia", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
        {"Montgomery", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
        {"Creek", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
        {"Los Santos International", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
        {"Santa Maria Beach", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
        {"Mulholland Intersection", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
        {"Angel Pine", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
        {"Verdant Meadows", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
        {"Octane Springs", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
        {"Come-A-Lot", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
        {"Redsands West", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
        {"Santa Maria Beach", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
        {"Verdant Bluffs", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
        {"Las Venturas Airport", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
        {"Flint Range", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
        {"Verdant Bluffs", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
        {"Palomino Creek", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
        {"Ocean Docks", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
        {"Easter Bay Airport", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
        {"Whitewood Estates", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
        {"Calton Heights", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
        {"Easter Basin", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
        {"Los Santos Inlet", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
        {"Doherty", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
        {"Mount Chiliad", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
        {"Fort Carson", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
        {"Foster Valley", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
        {"Ocean Flats", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
        {"Fern Ridge", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
        {"Bayside", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
        {"Las Venturas Airport", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
        {"Blueberry Acres", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
        {"Palisades", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
        {"North Rock", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
        {"Hunter Quarry", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
        {"Los Santos International", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
        {"Missionary Hill", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
        {"San Fierro Bay", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
        {"Restricted Area", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
        {"Mount Chiliad", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
        {"Mount Chiliad", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
        {"Easter Bay Airport", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
        {"The Panopticon", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
        {"Shady Creeks", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
        {"Back o Beyond", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
        {"Mount Chiliad", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
        {"Tierra Robada", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
        {"Flint County", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
        {"Whetstone", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
        {"Bone County", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
        {"Tierra Robada", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
        {"San Fierro", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
        {"Las Venturas", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
        {"Red County", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
        {"Los Santos", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
	-- print(getActiveInterior())
    return interior()
end

function interior()
    local interior_tbl = {
		{"Ammu-nation 1", 289.7870, -35.7190, 1003.5160},
		{"Burglary House 1", 224.6351, 1289.012, 1082.141},
		{"The Wellcome Pump (Catalina?)", 681.65, -452.86, -25.62},
		{"Alhambra", 446.6941, -9.7977, 1000.7340},
		{"Caligulas Casino", 2235.2524, 1708.5146, 1010.6129},
		{"Denise's Place", 244.0892, 304.8456, 999.1484},
		{"Shamal cabin", 1.6127, 34.7411, 1199.0},
		{"Liberty City", -750.80, 491.00, 1371.70},
		{"Johnsons House", 2525.0420, -1679.1150, 1015.4990},
		{"Transfender", 621.7850, -12.5417, 1000.9220},
		{"Safe House 4", 2216.5400, -1076.2900, 1050.4840},
		{"Trials(Hyman Memorial?) Stadium", -1401.13, 106.110, 1032.273},
		{"Warehouse 1", 1405.3120, -8.2928, 1000.9130},
		{"Doherty Garage", -2042.42, 178.59, 28.84},
		{"Sindacco Abatoir", 963.6078, 2108.3970, 1011.0300},
		{"Sub Urban", 203.8173, -46.5385, 1001.8050},
		{"Wu Zi Mu's Betting place", -2159.9260, 641.4587, 1052.3820},
		{"Ryder's House", 2464.2110, -1697.9520, 1013.5080},
		{"Angel Pine Trailer", 0.3440, -0.5140, 1000.5490},
		{"The Pig Pen", 1213.4330, -6.6830, 1000.9220},
		{"BDups Crack Palace", 1523.7510, -46.0458, 1002.1310},
		{"Big Smoke's Crack Palace", 2543.6610, -1303.9320, 1025.0700},
		{"Burglary House 2", 225.756, 1240.000, 1082.149},
		{"Burglary House 3", 447.470, 1398.348, 1084.305},
		{"Burglary House 4", 491.740, 1400.541, 1080.265},
		{"Katie's Place", 267.2290, 304.7100, 999.1480},
		{"Loco Low Co.", 612.5910, -75.6370, 997.9920},
		{"Reece's Barbershop", 411.6259, -21.4332, 1001.8046},
		{"Jizzy's Pleasure Domes", -2636.7190, 1402.9170, 906.4609},
		{"Brothel", 940.6520, -18.4860, 1000.9300},
		{"Brothel 2", 967.5334, -53.0245, 1001.1250},
		{"BDups Apartment", 1527.38, -11.02, 1002.10},
		{"Bike School", 1494.3350, 1305.6510, 1093.2890},
		{"Big Spread Ranch", 1210.2570, -29.2986, 1000.8790},
		{"Tattoo Parlour", -204.4390, -43.6520, 1002.2990},
		{"LVPD HQ", 289.7703, 171.7460, 1007.1790},
		{"OG Loc's House", 516.8890, -18.4120, 1001.5650},
		{"Pro-Laps", 207.3560, -138.0029, 1003.3130},
		{"Las Venturas Planning Dep.", 374.6708, 173.8050, 1008.3893},
		{"Record Label Hallway", 1038.2190, 6.9905, 1001.2840},
		{"Driving School", -2027.9200, -105.1830, 1035.1720},
		{"Johnson House", 2496.0500, -1693.9260, 1014.7420},
		{"Burglary House 5", 234.733, 1190.391, 1080.258},
		{"Gay Gordo's Barbershop", 418.6530, -82.6390, 1001.8050},
		{"Helena's Place", 292.4459, 308.7790, 999.1484},
		{"Inside Track Betting", 826.8863, 5.5091, 1004.4830},
		{"Sex Shop", -106.7268, -19.6444, 1000.7190},
		{"Wheel Arch Angels", 614.3889, -124.0991, 997.9950},
		{"24/7 shop 1", -27.3769, -27.6416, 1003.5570},
		{"Ammu-Nation 2", 285.8000, -84.5470, 1001.5390},
		{"Burglary House 6", -262.91, 1454.966, 1084.367},
		{"Burglary House 7", 221.4296, 1142.423, 1082.609},
		{"Burglary House 8", 261.1168, 1286.519, 1080.258},
		{"Diner 2", 460.0, -88.43, 999.62},
		{"Dirtbike Stadium", -1435.8690, -662.2505, 1052.4650},
		{"Michelle's Place", 302.6404, 304.8048, 999.1484},
		{"Madd Dogg's Mansion", 1272.9116, -768.9028, 1090.5097},
		{"Well Stacked Pizza Co.", 377.7758, -126.2766, 1001.4920},
		{"Victim", 221.3310, -6.6169, 1005.1977},
		{"Burning Desire House", 2351.1540, -1180.5770, 1027.9770},
		{"Barbara's Place", 322.1979, 302.4979, 999.1484},
		{"Burglary House 9", 22.79996, 1404.642, 1084.43},
		{"Burglary House 10", 228.9003, 1114.477, 1080.992},
		{"Burglary House 11", 140.5631, 1369.051, 1083.864},
		{"The Crack Den", 322.1117, 1119.3270, 1083.8830},
		{"Police Station (Barbara's)", 322.72, 306.43, 999.15},
		{"Diner 1", 448.7435, -110.0457, 1000.0772},
		{"Ganton Gym", 768.0793, 5.8606, 1000.7160},
		{"Vank Hoff Hotel ", 2232.8210, -1110.0180, 1050.8830},
		{"Ammu-Nation 3", 297.4460, -109.9680, 1001.5160},
		{"Ammu-Nation 4", 317.2380, -168.0520, 999.5930},
		{"LSPD HQ ", 246.4510, 65.5860, 1003.6410},
		{"Safe House 3", 2333.0330, -1073.9600, 1049.0230},
		{"Safe House 5", 2194.2910, -1204.0150, 1049.0230},
		{"Safe House 6", 2308.8710, -1210.7170, 1049.0230},
		{"Cobra Marital Arts Gym", 774.0870, -47.9830, 1000.5860},
		{"24/7 shop 2", -26.7180, -55.9860, 1003.5470},
		{"Millie's Bedroom", 344.5200, 304.8210, 999.1480},
		{"Fanny Batter's Brothel", 744.2710, 1437.2530, 1102.7030},
		{"Restaurant 2", 443.9810, -65.2190, 1050.0000},
		{"Burglary House 15", 234.319, 1066.455, 1084.208},
		{"Burglary House 16", -69.049, 1354.056, 1080.211},
		{"Ammu-Nation 5 (2 Floors)", 315.3850, -142.2420, 999.6010},
		{"8-Track Stadium", -1417.8720, -276.4260, 1051.1910},
		{"Below the Belt Gym", 774.2430, -76.0090, 1000.6540},
		{"Safe house 2", 2365.2383, -1134.2969, 1050.875},
		{"Colonel Fuhrberger's House", 2807.8990, -1172.9210, 1025.5700},
		{"Burglary House 22", -42.490, 1407.644, 1084.43},
		{"Unknown safe house", 2253.1740, -1139.0100, 1050.6330},
		{"Andromada Cargo hold", 315.48, 984.13, 1959.11},
		{"Burglary House 12", 85.32596, 1323.585, 1083.859},
		{"Burglary House 13", 260.3189, 1239.663, 1084.258},
		{"Cluckin' Bell", 365.67, -11.61, 1002},
		{"Four Dragons Casino", 2009.4140, 1017.8990, 994.4680},
		{"RC Zero's Battlefield", -975.5766, 1061.1312, 1345.6719},
		{"Burger Shot", 366.4220, -73.4700, 1001.5080},
		{"Burglary House 14", 21.241, 1342.153, 1084.375},
		{"Janitor room(Four Dragons Maintenance)", 1891.3960, 1018.1260, 31.8820},
		{"Safe House 1", 2262.83, -1137.71, 1050.63},
		{"Hashbury safe house", 2264.5231, -1210.5229, 1049.0234},
		{"24/7 shop 3", 6.0780, -28.6330, 1003.5490},
		{"Abandoned AC Tower", 419.6140, 2536.6030, 10.0000},
		{"SFPD HQ", 246.4410, 112.1640, 1003.2190},
		{"The Four Dragons Office", 2011.6030, 1017.0230, 39.0910},
		{"Los Santos safe house", 2282.9766, -1140.2861, 1050.8984},
		{"Ten Green Bottles Bar", 502.3310, -70.6820, 998.7570},
		{"Budget Inn Motel Room", 444.6469, 508.2390, 1001.4194},
		{"The Casino", 1132.9450, -8.6750, 1000.6800},
		{"Macisla's Barbershop", 411.6410, -51.8460, 1001.8980},
		{"Safe house 7", 2324.3848, -1148.4805, 1050.7101},
		{"Modern safe house", 2324.4990, -1147.0710, 1050.7100},
		{"LS Atrium", 1724.33, -1625.784, 20.211},
		{"CJ's Garage", -2043.966, 172.932, 28.835},
		{"Kickstart Stadium", -1464.5360, 1557.6900, 1052.5310},
		{"Didier Sachs", 204.1789, -165.8740, 1000.5230},
		{"Francis Int. Airport (Front ext.)", -1827.1473, 7.2074, 1061.1435},
		{"Francis Int. Airport (Baggage Claim/Ticket Sales)", -1855.5687, 41.2631, 1061.1435},
		{"Wardrobe", 255.7190, -41.1370, 1002.0230},
		{"Binco", 207.5430, -109.0040, 1005.1330},
		{"Blood Bowl Stadium", -1394.20, 987.62, 1023.96},
		{"Jefferson Motel", 2217.6250, -1150.6580, 1025.7970},
		{"Burglary House 17", -285.711, 1470.697, 1084.375},
		{"Burglary House 18", 327.808, 1479.74, 1084.438},
		{"Burglary House 19", 375.572, 1417.439, 1081.328},
		{"Burglary House 20", 384.644, 1471.479, 1080.195},
		{"Burglary House 21", 295.467, 1474.697, 1080.258},
		{"24/7 shop 4", -25.3730, -139.6540, 1003.5470},
		{"Tattoo Parlour", -204.5580, -25.6970, 1002.2730},
		{"Sumoring? stadium", -1400, 1250, 1040},
		{"24/7 shop 5", -25.3930, -185.9110, 1003.5470},
		{"Club", 493.4687, -23.0080, 1000.6796},
		{"Rusty Brown's - Ring Donuts", 377.0030, -192.5070, 1000.6330},
		{"The Sherman's Dam Generator Hall", -942.1320, 1849.1420, 5.0050},
		{"Hemlock Tattoo", 377.0030, -192.5070, 1000.6330},
		{"Lil Probe Inn", -227.0280, 1401.2290, 27.7690},
		{"24/7 shop 6", -30.9460, -89.6090, 1003.5490},
		{"Atrium", 1726.1370, -1645.2300, 20.2260},
		{"Warehouse 2", 1296.6310, 0.5920, 1001.0230},
		{"Zip", 161.4620, -91.3940, 1001.8050}
	}
    for i, v in ipairs(interior_tbl) do
        if locateCharAnyMeans3d(PLAYER_PED, v[2], v[3], v[4], 25.0, 25.0, 25.0, false) then
            return v[1]
        end
    end
	return 'Unknown'
end