cmenu = {show = 0, row = 0, field = 1}
text_in = 0
draw = {0,0,0}
prop = {0,0,1}
model_id = 1
bar = {x=0.328, y=0.142, x1=0.037,y1=0.014}
local currentmodel = "a_m_m_acult_01"
function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function startClothes()
	isMenuOpen = true
	cmenu.show = 1
	cmenu.row = 1
	cmenu.field = 1
	text_in = 0
end

function ClothShop()
	HideHudAndRadarThisFrame()
	DrawRect(0.12,0.07,0.22,0.09,0,0,0,150) -- header
	drawTxt(0.177, 0.066, 0.25, 0.03, 0.40,"Binco Clothing",255,255,255,255) -- header
	DrawRect(0.12,0.024,0.216,0.005,58,95,205,150) -- blue_head
	if cmenu.show == 1 then
		if cmenu.row == 1 then DrawRect(0.12,0.135,0.22,0.035,76,88,102,150) else DrawRect(0.12,0.135,0.22,0.035,0,0,0,150) end
		if cmenu.row == 2 then DrawRect(0.12,0.172,0.22,0.035,76,88,102,150) else DrawRect(0.12,0.172,0.22,0.035,0,0,0,150) end
		if cmenu.row == 3 then DrawRect(0.12,0.209,0.22,0.035,76,88,102,150) else DrawRect(0.12,0.209,0.22,0.035,0,0,0,150) end
		if cmenu.row == 4 then DrawRect(0.12,0.246,0.22,0.035,76,88,102,150) else DrawRect(0.12,0.246,0.22,0.035,0,0,0,150) end
		drawTxt(0.177, 0.128, 0.25, 0.03, 0.40,"Choose slot",255,255,255,255)
		drawTxt(0.177, 0.165, 0.25, 0.03, 0.40,"Accessories",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.202, 0.25, 0.03, 0.40,"Player Model",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.239, 0.25, 0.03, 0.40,"Exit",255,255,255,255) -- row_2 (+0.037)
	elseif cmenu.show == 2 then
		-- debug_you_can_delete_it
		local drawstr = string.format("Slot: %d~n~Draw: %d~n~Tex: %d~n~Pal: %d",cmenu.field-1, draw[1],draw[2],draw[3])
		drawTxt(0.28, 0.8, 0, 0, 0.40,drawstr,255,255,255,255)
		-- debug_end
		DrawRect(0.12,0.135,0.22,0.035,76,88,102,150)
		DrawRect(0.12,0.172,0.22,0.035,0,0,0,150)
		DrawRect(0.12,0.209,0.22,0.035,0,0,0,150)
		DrawRect(0.12,0.246,0.22,0.035,0,0,0,150)
		drawTxt(0.177, 0.128, 0.25, 0.03, 0.40,"~b~Choose slot",255,255,255,255)
		drawTxt(0.177, 0.165, 0.25, 0.03, 0.40,"Accessories",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.202, 0.25, 0.03, 0.40,"Player Model",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.239, 0.25, 0.03, 0.40,"Exit",255,255,255,255) -- row_2 (+0.037)
		---
		DrawRect(0.328,0.051,0.18,0.049,0,0,0,150) -- title
		drawTxt(0.382,0.048,0.175,0.035, 0.40,"Choose slot",255,255,255,255)
		DrawRect(0.328,0.024,0.175,0.005,58,95,205,150)
		if cmenu.row == 1 then DrawRect(0.328,0.096,0.18,0.035,76,88,102,150) else DrawRect(0.328,0.096,0.18,0.035,0,0,0,150) end
		if cmenu.row == 2 then DrawRect(0.328,0.133,0.18,0.035,76,88,102,150) else DrawRect(0.328,0.133,0.18,0.035,0,0,0,150) end
		if cmenu.row == 3 then DrawRect(0.328,0.170,0.18,0.035,76,88,102,150) else DrawRect(0.328,0.170,0.18,0.035,0,0,0,150) end
		if cmenu.row == 4 then DrawRect(0.328,0.207,0.18,0.035,76,88,102,150) else DrawRect(0.328,0.207,0.18,0.035,0,0,0,150) end
		--
		local draw_str = string.format("Slot: %d / 11", cmenu.field-1)
		drawTxt(0.328,0.093,0.175,0.035, 0.40,draw_str,255,255,255,255)
		--
		if GetNumberOfPedDrawableVariations(GetPlayerPed(-1), cmenu.field-1) ~= 0 and GetNumberOfPedDrawableVariations(GetPlayerPed(-1), cmenu.field-1) ~= false then
			DrawRect(0.328,0.142,0.175,0.014,28,134,238,150)
			local link = 0.138/(GetNumberOfPedDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1)
			local new_x = (bar.x-0.069)+(link*draw[1])
			if new_x < 0.259 then new_x = 0.259 end
			if new_x > 0.397 then new_x = 0.397 end
			DrawRect(new_x,bar.y,bar.x1,bar.y1,0,0,238,150)
			-- row_3
			DrawRect(0.328,0.179,0.175,0.014,28,134,238,150) -- bar_main
			local link = 0.138/(GetNumberOfPedTextureVariations(GetPlayerPed(-1), cmenu.field-1, draw[1])-1)
			local new_x = (bar.x-0.069)+(link*draw[2])
			if new_x < 0.259 then new_x = 0.259 end
			if new_x > 0.397 then new_x = 0.397 end
			DrawRect(new_x,bar.y+0.037,bar.x1,bar.y1,0,0,238,150)
			--
			DrawRect(0.328,0.216,0.175,0.014,28,134,238,150) 
			local link = 0.138/2
			local new_x = (bar.x-0.069)+(link*draw[3])
			if new_x < 0.259 then new_x = 0.259 end
			if new_x > 0.397 then new_x = 0.397 end
			DrawRect(new_x,bar.y+0.074,bar.x1,bar.y1,0,0,238,150) -- +2 rows
			--
			if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					if cmenu.field > 1 then 
						cmenu.field = cmenu.field-1
						draw[1] = 0
						draw[2] = 0
					else 
						cmenu.field = 12
						draw[1] = 0
						draw[2] = 0
					end
				elseif cmenu.row == 2 then
					if draw[1] > 0 then draw[1] = draw[1]-1 else draw[1] = 0 end
					draw[2] = 0
					SetPedComponentVariation(GetPlayerPed(-1), cmenu.field-1, draw[1], draw[2], draw[3])
				elseif cmenu.row == 3 then
					if draw[2] > 0 then draw[2] = draw[2]-1 else draw[2] = 0 end
					SetPedComponentVariation(GetPlayerPed(-1), cmenu.field-1, draw[1], draw[2], draw[3])
				elseif cmenu.row == 4 then
					if draw[3] > 0 then draw[3] = draw[3]-1 end
				end
			end
			if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					if cmenu.field < 12 then 
						cmenu.field = cmenu.field+1 
						draw[1] = 0
						draw[2] = 0
					else 
						cmenu.field = 1
						draw[1] = 0
						draw[2] = 0
					end
				elseif cmenu.row == 2 then
					if draw[1] < GetNumberOfPedDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1 then draw[1] = draw[1]+1 else draw[1] = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1 end
					draw[2] = 0
					SetPedComponentVariation(GetPlayerPed(-1), cmenu.field-1, draw[1], draw[2], draw[3])
				elseif cmenu.row == 3 then
					if draw[2] < GetNumberOfPedTextureVariations(GetPlayerPed(-1), cmenu.field-1, draw[1])-1 then draw[2] = draw[2]+1 else draw[2] = GetNumberOfPedTextureVariations(GetPlayerPed(-1), cmenu.field-1, draw[1])-1 end
					SetPedComponentVariation(GetPlayerPed(-1), cmenu.field-1, draw[1], draw[2], draw[3])
				elseif cmenu.row == 4 then
					if draw[3] < 2 then draw[3] = draw[3]+1 end
				end
			end
		else
			drawTxt(0.328,0.130,0.175,0.035, 0.40,"EMPTY SLOT",255,255,255,255)
			drawTxt(0.328,0.167,0.175,0.035, 0.40,"EMPTY SLOT",255,255,255,255)
			drawTxt(0.328,0.204,0.175,0.035, 0.40,"EMPTY SLOT",255,255,255,255)
			if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.field > 1 then 
					cmenu.field = cmenu.field-1
					draw[1] = 0
					draw[2] = 0
				else 
					cmenu.field = 12
					draw[1] = 0
					draw[2] = 0
				end
			end
			if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.field < 12 then 
					cmenu.field = cmenu.field+1
					draw[1] = 0
					draw[2] = 0
				else 
					cmenu.field = 1
					draw[1] = 0
					draw[2] = 0
				end
			end
		end
	elseif cmenu.show == 3 then
		-- debug_you_can_delete_it
		local drawstr = string.format("Slot: %d~n~Prop: %d~n~Var: %d",cmenu.field-1, prop[1],prop[2])
		drawTxt(0.28, 0.8, 0, 0, 0.40,drawstr,255,255,255,255)
		-- debug_end
		DrawRect(0.12,0.135,0.22,0.035,0,0,0,150)
		DrawRect(0.12,0.172,0.22,0.035,76,88,102,150)
		DrawRect(0.12,0.209,0.22,0.035,0,0,0,150)
		DrawRect(0.12,0.246,0.22,0.035,0,0,0,150)
		drawTxt(0.177, 0.128, 0.25, 0.03, 0.40,"Choose slot",255,255,255,255)
		drawTxt(0.177, 0.165, 0.25, 0.03, 0.40,"~b~Accessories",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.202, 0.25, 0.03, 0.40,"Player Model",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.239, 0.25, 0.03, 0.40,"Exit",255,255,255,255) -- row_2 (+0.037)
		---
		DrawRect(0.328,0.051,0.18,0.049,0,0,0,150) -- title
		drawTxt(0.382,0.048,0.175,0.035, 0.40,"Accessories",255,255,255,255)
		DrawRect(0.328,0.024,0.175,0.005,58,95,205,150)
		if cmenu.row == 1 then DrawRect(0.328,0.096,0.18,0.035,76,88,102,150) else DrawRect(0.328,0.096,0.18,0.035,0,0,0,150) end
		if cmenu.row == 2 then DrawRect(0.328,0.133,0.18,0.035,76,88,102,150) else DrawRect(0.328,0.133,0.18,0.035,0,0,0,150) end
		if cmenu.row == 3 then DrawRect(0.328,0.170,0.18,0.035,76,88,102,150) else DrawRect(0.328,0.170,0.18,0.035,0,0,0,150) end
		local draw_str = string.format("Slot: %d / 7", cmenu.field-1)
		drawTxt(0.328,0.093,0.175,0.035, 0.40,draw_str,255,255,255,255)
		--
		if GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), cmenu.field-1) ~= 0 and GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), cmenu.field-1) ~= false then
			DrawRect(0.328,0.142,0.175,0.014,28,134,238,150)
			local link = 0.138/(GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1)
			local new_x = (bar.x-0.069)+(link*prop[1])
			if new_x < 0.259 then new_x = 0.259 end
			if new_x > 0.397 then new_x = 0.397 end
			DrawRect(new_x,bar.y,bar.x1,bar.y1,0,0,238,150)
			-- row_3
			DrawRect(0.328,0.179,0.175,0.014,28,134,238,150) -- bar_main
			local link = 0.138/(GetNumberOfPedPropTextureVariations(GetPlayerPed(-1), cmenu.field-1, prop[1])-1)
			local new_x = (bar.x-0.069)+(link*prop[2])
			if new_x < 0.259 then new_x = 0.259 end
			if new_x > 0.397 then new_x = 0.397 end
			DrawRect(new_x,bar.y+0.037,bar.x1,bar.y1,0,0,238,150)
			--
			if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					if cmenu.field > 1 then 
						cmenu.field = cmenu.field-1 
						prop[1] = 0
						prop[2] = 0
					else 
						cmenu.field = 8
						prop[1] = 0
						prop[2] = 0
					end
				elseif cmenu.row == 2 then
					if prop[1] > 0 then prop[1] = prop[1]-1 else prop[1] = 0 end
					prop[2] = 0
					SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, prop[1], prop[2], prop[3])
				elseif cmenu.row == 3 then
					if prop[2] > 0 then prop[2] = prop[2]-1 else prop[2] = 0 end
					SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, prop[1], prop[2], prop[3])
				end
			end
			if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					if cmenu.field < 8 then 
						cmenu.field = cmenu.field+1 
						prop[1] = 0
						prop[2] = 0
					else 
						cmenu.field = 1
						prop[1] = 0
						prop[2] = 0
					end
				elseif cmenu.row == 2 then
					if prop[1] < GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1 then prop[1] = prop[1]+1 else prop[1] = GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1 end
					prop[2] = 0
					SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, prop[1], prop[2], prop[3])
				elseif cmenu.row == 3 then
					if prop[2] < GetNumberOfPedPropTextureVariations(GetPlayerPed(-1), cmenu.field-1, prop[1])-1 then prop[2] = prop[2]+1 else prop[2] = GetNumberOfPedPropTextureVariations(GetPlayerPed(-1), cmenu.field-1, prop[1])-1 end
					SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, prop[1], prop[2], prop[3])
				end
			end
		else
			drawTxt(0.328,0.130,0.175,0.035, 0.40,"EMPTY SLOT",255,255,255,255)
			drawTxt(0.328,0.167,0.175,0.035, 0.40,"EMPTY SLOT",255,255,255,255)
			if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.field > 1 then 
					cmenu.field = cmenu.field-1
					prop[1] = 0
					prop[2] = 0
				else 
					cmenu.field = 8
					prop[1] = 0
					prop[2] = 0
				end
			end
			if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.field < 8 then 
					cmenu.field = cmenu.field+1
					prop[1] = 0
					prop[2] = 0
				else 
					cmenu.field = 1
					prop[1] = 0
					prop[2] = 0
				end
			end
		end
	elseif cmenu.show == 4 then
		local drawstr = string.format("ID: %d~n~Name: %s",model_id, fr_skins[model_id])
		drawTxt(0.28, 0.8, 0, 0, 0.40,drawstr,255,255,255,255)
		DrawRect(0.12,0.135,0.22,0.035,0,0,0,150)
		DrawRect(0.12,0.172,0.22,0.035,0,0,0,150)
		DrawRect(0.12,0.209,0.22,0.035,76,88,102,150)
		DrawRect(0.12,0.246,0.22,0.035,0,0,0,150)
		drawTxt(0.177, 0.128, 0.25, 0.03, 0.40,"Choose slot",255,255,255,255)
		drawTxt(0.177, 0.165, 0.25, 0.03, 0.40,"Accessories",255,255,255,255)
		drawTxt(0.177, 0.202, 0.25, 0.03, 0.40,"~b~Player Model",255,255,255,255)
		drawTxt(0.177, 0.239, 0.25, 0.03, 0.40,"Exit",255,255,255,255)
		DrawRect(0.328,0.051,0.18,0.049,0,0,0,150)
		drawTxt(0.382,0.048,0.175,0.035, 0.40,"Player Model",255,255,255,255)
		DrawRect(0.328,0.024,0.175,0.005,58,95,205,150)
		if cmenu.row == 1 then DrawRect(0.328,0.096,0.18,0.035,76,88,102,150) else DrawRect(0.328,0.096,0.18,0.035,0,0,0,150) end
		if cmenu.row == 2 then DrawRect(0.328,0.133,0.18,0.035,76,88,102,150) else DrawRect(0.328,0.133,0.18,0.035,0,0,0,150) end
		if cmenu.row == 3 then DrawRect(0.328,0.170,0.18,0.035,76,88,102,150) else DrawRect(0.328,0.170,0.18,0.035,0,0,0,150) end
		local draw_str = string.format("Slot: < %d / 492 >", model_id)
		drawTxt(0.328,0.093,0.175,0.035, 0.40,draw_str,255,255,255,255)
		draw_str = string.format("%s", fr_skins[model_id])
		drawTxt(0.328,0.093+0.037,0.175,0.035, 0.40,draw_str,255,255,255,255)
		drawTxt(0.328,0.093+0.037*2,0.175,0.035, 0.40,"Exact Skin",255,255,255,255)
		if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
			if cmenu.row == 1 then
				if model_id > 1 then
					model_id=model_id-1
				else
					model_id = 492
				end
			end
		end
		if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
			if cmenu.row == 1 then
				if model_id < 492 then
					model_id=model_id+1
				else
					model_id = 1
				end
			end
		end
		if IsControlJustPressed(1, 201) or IsDisabledControlJustPressed(1, 201) then -- Enter
			if cmenu.row == 1 or cmenu.row == 2 then
				ChangeToSkin(fr_skins[model_id])
			elseif cmenu.row == 3 then
				if text_in == 0 then
					text_in = 1
					DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
				end
			end
		end
	end
end

function ShowRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

changemodel = false
function ChangeToSkin(skin)
	changemodel = true
	for i = 1, #banned_skins do
		if	skin == banned_skins[i] then
			ShowRadarMessage("You cannot use a banned model!")
			changemodel = false
		end
	end
	if changemodel then
		currentmodel = skin
		local model = GetHashKey(skin)
		if IsModelInCdimage(model) and IsModelValid(model) then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
			SetPlayerModel(PlayerId(), model)
			SetPedRandomComponentVariation(GetPlayerPed(-1), true)
			ShowRadarMessage('New skin is: '..skin)
			SetModelAsNoLongerNeeded(model)
		else
			ShowRadarMessage("Model is not found!")
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		--if IsControlJustPressed(1, 214) or IsDisabledControlJustPressed(1, 214) then -- delete
			--if cmenu.show == 0 then
				--PlaySound(-1, "FocusIn", "HintCamSounds", 0, 0, 1)
				--startClothes()
			--end
		--end
		if cmenu.show == 1 then
			ClothShop()
			if IsControlJustPressed(1, 188) or IsDisabledControlJustPressed(1, 188) then -- up
				if cmenu.row > 1 then cmenu.row = cmenu.row-1 else cmenu.row = 4 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 187) or IsDisabledControlJustPressed(1, 187) then -- down
				if cmenu.row < 4 then cmenu.row = cmenu.row+1 else cmenu.row = 1 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 201) or IsDisabledControlJustPressed(1, 201) then -- Enter
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					cmenu.show = 2
					cmenu.row = 1
				elseif cmenu.row == 2 then
					cmenu.show = 3
					cmenu.row = 1
				elseif cmenu.row == 3 then
					cmenu.show = 4
					cmenu.row = 1
				elseif cmenu.row == 4 then
					cmenu.show = 0
					cmenu.row = 0
					cmenu.field = 0
					local drawables = {
						head = GetPedDrawableVariation(GetPlayerPed(-1), 0),
						mask = GetPedDrawableVariation(GetPlayerPed(-1), 1),
						hair = GetPedDrawableVariation(GetPlayerPed(-1), 2),
						hand = GetPedDrawableVariation(GetPlayerPed(-1), 3),
						pants = GetPedDrawableVariation(GetPlayerPed(-1), 4),
						gloves = GetPedDrawableVariation(GetPlayerPed(-1), 5),
						shoes = GetPedDrawableVariation(GetPlayerPed(-1), 6),
						eyes = GetPedDrawableVariation(GetPlayerPed(-1), 7),
						accessories = GetPedDrawableVariation(GetPlayerPed(-1), 8),
						items = GetPedDrawableVariation(GetPlayerPed(-1), 9),
						decals = GetPedDrawableVariation(GetPlayerPed(-1), 10),
						shirts = GetPedDrawableVariation(GetPlayerPed(-1), 11),
						helmet = GetPedPropIndex(GetPlayerPed(-1), 0),
						glasses = GetPedPropIndex(GetPlayerPed(-1), 1),
						earrings = GetPedPropIndex(GetPlayerPed(-1), 2),
						beard = GetPedHeadOverlayValue(GetPlayerPed(-1), 1),
						eyebrow = GetPedHeadOverlayValue(GetPlayerPed(-1), 2),
						makeup = GetPedHeadOverlayValue(GetPlayerPed(-1), 4),
						lipstick = GetPedHeadOverlayValue(GetPlayerPed(-1), 8)
					}
					local textures = {
						mask = GetPedTextureVariation(GetPlayerPed(-1), 1),
						hair = GetPedTextureVariation(GetPlayerPed(-1), 2),
						hand = GetPedTextureVariation(GetPlayerPed(-1), 3),
						pants = GetPedTextureVariation(GetPlayerPed(-1), 4),
						gloves = GetPedTextureVariation(GetPlayerPed(-1), 5),
						shoes = GetPedTextureVariation(GetPlayerPed(-1), 6),
						eyes = GetPedTextureVariation(GetPlayerPed(-1), 7),
						accessories = GetPedTextureVariation(GetPlayerPed(-1), 8),
						items = GetPedTextureVariation(GetPlayerPed(-1), 9),
						decals = GetPedTextureVariation(GetPlayerPed(-1), 10),
						shirts = GetPedTextureVariation(GetPlayerPed(-1), 11),
						helmet = GetPedPropTextureIndex(GetPlayerPed(-1), 0),
						glasses = GetPedPropTextureIndex(GetPlayerPed(-1), 1),
						earrings = GetPedPropTextureIndex(GetPlayerPed(-1), 2)
					}
					TriggerServerEvent("clothes:saveeverything", currentmodel, drawables, textures)				
				end
			end
		elseif cmenu.show == 2 then
			ClothShop()
			if IsControlJustPressed(1, 188) or IsDisabledControlJustPressed(1, 188) then -- up
				if cmenu.row > 1 then cmenu.row = cmenu.row-1 else cmenu.row = 4 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 187) or IsDisabledControlJustPressed(1, 187) then -- down
				if cmenu.row < 4 then cmenu.row = cmenu.row+1 else cmenu.row = 1 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- backspase
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				cmenu.show = 1
				cmenu.row = 1
				cmenu.field = 1
			end
		elseif cmenu.show == 3 then
			ClothShop()
			if IsControlJustPressed(1, 188) or IsDisabledControlJustPressed(1, 188) then -- up
				if cmenu.row > 1 then cmenu.row = cmenu.row-1 else cmenu.row = 3 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 187) or IsDisabledControlJustPressed(1, 187) then -- down
				if cmenu.row < 3 then cmenu.row = cmenu.row+1 else cmenu.row = 1 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- backspase
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				cmenu.show = 1
				cmenu.row = 2
				cmenu.field = 1
			end
		elseif cmenu.show == 4 then
			if text_in == 1 then
				HideHudAndRadarThisFrame()
				if UpdateOnscreenKeyboard() == 3 then text_in = 0
				elseif UpdateOnscreenKeyboard() == 1 then 
					text_in = 0
					ChangeToSkin(GetOnscreenKeyboardResult())
				elseif UpdateOnscreenKeyboard() == 2 then text_in = 0 end
			else
				ClothShop()
				if IsControlJustPressed(1, 188) or IsDisabledControlJustPressed(1, 188) then -- up
					if cmenu.row > 1 then cmenu.row = cmenu.row-1 else cmenu.row = 3 end
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				elseif IsControlJustPressed(1, 187) or IsDisabledControlJustPressed(1, 187) then -- down
					if cmenu.row < 3 then cmenu.row = cmenu.row+1 else cmenu.row = 1 end
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				elseif IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- backspase
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					cmenu.show = 1
					cmenu.row = 3
					cmenu.field = 1
				end
			end
		end
	end
end)

RegisterNetEvent("clothes:changeeverything_spawn")
AddEventHandler("clothes:changeeverything_spawn", function(user)
    --SetPedHeadBlendData(GetPlayerPed(-1), tonumber(user.head), tonumber(user.head), 0, tonumber(user.head), tonumber(user.head), 0, 0.5, 0.5, 0.0, false)
    SetPedComponentVariation(GetPlayerPed(-1), 0, tonumber(user.head), tonumber(user.head), 0)
    SetPedComponentVariation(GetPlayerPed(-1), 1, tonumber(user.mask), tonumber(user.mask_txt), 0)
    SetPedComponentVariation(GetPlayerPed(-1), 2, tonumber(user.hair), tonumber(user.hair_txt), 1)
    SetPedComponentVariation(GetPlayerPed(-1), 3, tonumber(user.hand), tonumber(user.hand_txt), 0)
    SetPedComponentVariation(GetPlayerPed(-1), 4, tonumber(user.pants), tonumber(user.pants_txt), 0)   
    SetPedComponentVariation(GetPlayerPed(-1), 5, tonumber(user.gloves), tonumber(user.gloves_txt), 0)   
    SetPedHairColor(GetPlayerPed(-1), tonumber(user.hair_txt), tonumber(user.hair_txt))
    SetPedComponentVariation(GetPlayerPed(-1), 6, tonumber(user.shoes), tonumber(user.shoes_txt), 0)
    SetPedComponentVariation(GetPlayerPed(-1), 7, tonumber(user.eyes), tonumber(user.eyes_txt), 0)
    SetPedComponentVariation(GetPlayerPed(-1), 8, tonumber(user.accessories), tonumber(user.accessories_txt), 0)    
    SetPedComponentVariation(GetPlayerPed(-1), 9, tonumber(user.items), tonumber(user.items_txt), 0)
    SetPedComponentVariation(GetPlayerPed(-1), 10, tonumber(user.decals), tonumber(user.decals_txt), 0)
    SetPedComponentVariation(GetPlayerPed(-1), 11, tonumber(user.shirts), tonumber(user.shirts_txt), 0)
    SetPedPropIndex(GetPlayerPed(-1), 0, tonumber(user.helmet), tonumber(user.helmet_txt), 0)
    SetPedPropIndex(GetPlayerPed(-1), 1, tonumber(user.glasses), tonumber(user.glasses_txt), 0)
    SetPedPropIndex(GetPlayerPed(-1), 2, tonumber(user.earrings), tonumber(user.earrings_txt), 0)
    SetPedHeadOverlay(GetPlayerPed(-1), 1, tonumber(user.beard), 25.11)
    SetPedHeadOverlay(GetPlayerPed(-1), 2, tonumber(user.eyebrow), 25.11)
    SetPedHeadOverlay(GetPlayerPed(-1), 4, tonumber(user.makeup), 25.11)
    SetPedHeadOverlay(GetPlayerPed(-1), 8, tonumber(user.lipstick), 25.11)
end)

firstConnect = true
AddEventHandler('playerSpawned', function(spawn)
    if firstConnect then
        firstConnect = false
        TriggerServerEvent("clothes:spawn")
    else
        TriggerServerEvent("clothes:otherspawn")
    end
end)

RegisterNetEvent("clothes:changemodelspawn")
AddEventHandler("clothes:changemodelspawn",function(model)
    changemodel(model,nil)
    currentmodel = model
    TriggerServerEvent("clothes:spawn2")
end)

RegisterNetEvent("clothes:changempmodelspawn")
AddEventHandler("clothes:changempmodelspawn",function(model)
    changempmodel(model,nil)
    currentmodel = model
    TriggerServerEvent("clothes:spawn2")
end)

function changemodel(model)
    local modelhashed = GetHashKey(model)

    RequestModel(modelhashed)
    while not HasModelLoaded(modelhashed) do 
        RequestModel(modelhashed)
        Citizen.Wait(0)
    end

    SetPlayerModel(PlayerId(), modelhashed)
    SetPedRandomComponentVariation(GetPlayerPed(-1), true)
    local a = "" -- nil doesnt work
    SetModelAsNoLongerNeeded(modelhashed)
end

function changempmodel(model)
    
    local modelhashed = GetHashKey(model)

    RequestModel(modelhashed)
    while not HasModelLoaded(modelhashed) do 
        RequestModel(modelhashed)
        Citizen.Wait(0)
    end

    SetPlayerModel(PlayerId(), modelhashed)
    local a = "" -- nil doesnt work
    SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 0)
    if model == 'mp_f_freemode_01' then
        SetPedComponentVariation(GetPlayerPed(-1), 0, 34, 0, 0)
    end
    SetModelAsNoLongerNeeded(modelhashed)
end

local emplacement = {
    {name="Clothing Store", id=73, x=1932.76989746094, y=3727.73510742188, z=32.8444557189941},
    {name="Clothing Store", id=73, x=1693.26, y=4822.27, z=42.06},
    {name="Clothing Store", id=73, x=125.83, y=-223.16, z=54.55},
    {name="Clothing Store", id=73, x=-710.16, y=-153.26, z=37.41},
    {name="Clothing Store", id=73, x=-821.69, y=-1073.90, z=11.32},
    {name="Clothing Store", id=73, x=-1192.81, y=-768.24, z=17.31},
    {name="Clothing Store", id=73, x=4.25, y=6512.88, z=31.87},
    {name="Clothing Store", id=73, x=425.471, y=-806.164, z=29.4911},
    {name="Clothing Store", id=73, id=73, x=72.2545394897461,  y=-1399.10229492188, z=29.3761386871338},
    {name="Clothing Store", id=73, id=73, x=-167.863754272461, y=-298.969482421875, z=39.7332878112793},
    {name="Clothing Store", id=73, id=73, x=-1447.7978515625,  y=-242.461242675781, z=49.8207931518555},
    {name="Clothing Store", id=73, id=73, x=11.6323690414429,  y=6514.224609375,    z=31.8778476715088},
    {name="Clothing Store", id=73, id=73, x=618.093444824219,  y=2759.62939453125,  z=42.0881042480469},
    {name="Clothing Store", id=73, id=73, x=-3172.49682617188, y=1048.13330078125,  z=20.8632030487061},
    {name="Clothing Store", id=73, id=73, x=-1108.44177246094, y=2708.92358398438,  z=19.1078643798828},
    {name="Clones'R us", id=73, x=138.321, y=-767.649, z=45.752},
}
incircle = false
Citizen.CreateThread(function()
    for _, item in pairs(emplacement) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipColour(item.blip, item.colour)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
    while true do
        Citizen.Wait(0)
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        for k,v in ipairs(emplacement) do
            if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
                DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 0.5001, 1555, 0, 0,165, 0, 0, 0,0)
                if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0)then
                    if (incircle == false) then
                        DisplayHelpText("Press ~INPUT_CONTEXT~ to customise your character.")
                    end
                    incircle = true
                    if IsControlJustReleased(1, 51) then
                    	if cmenu.show == 0 then
							PlaySound(-1, "FocusIn", "HintCamSounds", 0, 0, 1)
							startClothes()
						end
					end
                elseif(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) > 2.0)then
                    incircle = false
                    if cmenu.show ~= 0 then
						local drawables = {
							head = GetPedDrawableVariation(GetPlayerPed(-1), 0),
							mask = GetPedDrawableVariation(GetPlayerPed(-1), 1),
							hair = GetPedDrawableVariation(GetPlayerPed(-1), 2),
							hand = GetPedDrawableVariation(GetPlayerPed(-1), 3),
							pants = GetPedDrawableVariation(GetPlayerPed(-1), 4),
							gloves = GetPedDrawableVariation(GetPlayerPed(-1), 5),
							shoes = GetPedDrawableVariation(GetPlayerPed(-1), 6),
							eyes = GetPedDrawableVariation(GetPlayerPed(-1), 7),
							accessories = GetPedDrawableVariation(GetPlayerPed(-1), 8),
							items = GetPedDrawableVariation(GetPlayerPed(-1), 9),
							decals = GetPedDrawableVariation(GetPlayerPed(-1), 10),
							shirts = GetPedDrawableVariation(GetPlayerPed(-1), 11),
							helmet = GetPedPropIndex(GetPlayerPed(-1), 0),
							glasses = GetPedPropIndex(GetPlayerPed(-1), 1),
							earrings = GetPedPropIndex(GetPlayerPed(-1), 2),
							beard = GetPedHeadOverlayValue(GetPlayerPed(-1), 1),
							eyebrow = GetPedHeadOverlayValue(GetPlayerPed(-1), 2),
							makeup = GetPedHeadOverlayValue(GetPlayerPed(-1), 4),
							lipstick = GetPedHeadOverlayValue(GetPlayerPed(-1), 8)
						}
						local textures = {
							mask = GetPedTextureVariation(GetPlayerPed(-1), 1),
							hair = GetPedTextureVariation(GetPlayerPed(-1), 2),
							hand = GetPedTextureVariation(GetPlayerPed(-1), 3),
							pants = GetPedTextureVariation(GetPlayerPed(-1), 4),
							gloves = GetPedTextureVariation(GetPlayerPed(-1), 5),
							shoes = GetPedTextureVariation(GetPlayerPed(-1), 6),
							eyes = GetPedTextureVariation(GetPlayerPed(-1), 7),
							accessories = GetPedTextureVariation(GetPlayerPed(-1), 8),
							items = GetPedTextureVariation(GetPlayerPed(-1), 9),
							decals = GetPedTextureVariation(GetPlayerPed(-1), 10),
							shirts = GetPedTextureVariation(GetPlayerPed(-1), 11),
							helmet = GetPedPropTextureIndex(GetPlayerPed(-1), 0),
							glasses = GetPedPropTextureIndex(GetPlayerPed(-1), 1),
							earrings = GetPedPropTextureIndex(GetPlayerPed(-1), 2)
						}
						TriggerServerEvent("clothes:saveeverything", currentmodel, drawables, textures)	
					end
                    cmenu.show = 0
					cmenu.row = 0
					cmenu.field = 0
                end
            end
        end
    end
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function IsMenuOpen()
	return cmenu.show
end

RegisterNetEvent("clothes:ondeath")
AddEventHandler("clothes:ondeath",function()
    cmenu.show = 0
	cmenu.row = 0
	cmenu.field = 0
end)