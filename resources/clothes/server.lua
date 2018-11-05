require "resources/mysql-async/lib/MySQL"

function getmodels(identifier)
	return MySQL.Sync.fetchScalar("SELECT model FROM clothes WHERE identifier = @name", {['@name'] = identifier})
end

RegisterServerEvent("clothes:spawn")
AddEventHandler("clothes:spawn", function()
	local identifier = getPlayerID(source)
	MySQL.Async.fetchAll("SELECT * FROM clothes WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (result)
		if(not result[1]) then
			MySQL.Async.execute("INSERT INTO clothes (`identifier`) VALUES (@identifier)", { ['@identifier'] = identifier})
		else
			local model = getmodels(identifier)
			print(model)
			if model == "mp_m_freemode_01" or model == "mp_f_freemode_01" then
				TriggerClientEvent("clothes:changempmodelspawn", source, model)
			else
				print("Notcorrect")
				TriggerClientEvent("clothes:changemodelspawn", source, model)
			end
		end
	end)
end)


RegisterServerEvent("clothes:otherspawn")
AddEventHandler("clothes:otherspawn", function()
	local identifier = getPlayerID(source)
	local model = getmodels(identifier)
	print(model)
	if model == "mp_m_freemode_01" or model == "mp_f_freemode_01" then
		TriggerClientEvent("clothes:changempmodelspawn", source, model)
	else
		print("correct")
		TriggerClientEvent("clothes:changemodelspawn", source, model)
	end
end)

RegisterServerEvent("clothes:spawn2")
AddEventHandler("clothes:spawn2", function()
	local identifier = getPlayerID(source)
	MySQL.Async.fetchAll("SELECT * FROM clothes WHERE identifier=@name", {['@name'] = identifier}, function (result)
		local user = {
			head = result[1].head,
			mask = result[1].mask,
			hair = result[1].hair,
			hand = result[1].hand,
			pants = result[1].pants,
			gloves = result[1].gloves,
			shoes = result[1].shoes,
			eyes = result[1].eyes,
			accessories = result[1].accessories,
			items = result[1].items,
			decals = result[1].decals,
			shirts = result[1].shirts,
			helmet = result[1].helmet,
			glasses = result[1].glasses,
			earrings = result[1].earrings,
			beard = result[1].beard,
			eyebrow = result[1].eyebrow,
			makeup = result[1].makeup,
			lipstick = result[1].lipstick,
			mask_txt = result[1].mask_txt,
			hair_txt = result[1].hair_txt,
			pants_txt = result[1].pants_txt,
			gloves_txt = result[1].gloves_txt,
			shoes_txt = result[1].shoes_txt,
			eyes_txt = result[1].eyes_txt,
			accessories_txt = result[1].accessories_txt,
			items_txt = result[1].items_txt,
			decals_txt = result[1].decals_txt,
			shirts_txt = result[1].shirts_txt,
			helmet_txt = result[1].helmet_txt,
			glasses_txt = result[1].glasses_txt,
			earrings_txt = result[1].earrings_txt,
			hand_txt = result[1].hand_txt
		}
		TriggerClientEvent("clothes:changeeverything_spawn", source, user)
	end)
end)

RegisterServerEvent("clothes:saveeverything")
AddEventHandler("clothes:saveeverything",function(currentmodel, drawables, textures)
	local identifier = getPlayerID(source)
	MySQL.Sync.execute("UPDATE clothes SET model=@model, head=@head, mask=@mask, hair=@hair, hand=@hand, pants=@pants, gloves=@gloves, shoes=@shoes, eyes=@eyes, accessories=@accessories, items=@items, decals=@decals, shirts=@shirts, helmet=@helmet, glasses=@glasses, earrings=@earrings, beard=@beard, eyebrow=@eyebrow, makeup=@makeup, lipstick=@lipstick, mask_txt=@mtxt, hair_txt=@htxt, pants_txt=@ptxt, gloves_txt=@gtxt, shoes_txt=@stxt, eyes_txt=@etxt, accessories_txt=@atxt, items_txt=@itxt, decals=@dtxt, shirts_txt=@shtxt, helmet_txt=@mettxt, glasses_txt=@lassestxt, earrings=@ringstxt, hand_txt=@dhtxt WHERE identifier=@user",{['@model']= currentmodel,['@head']= drawables.head,['@mask']= drawables.mask,['@mtxt']= textures.mask,['@hair']= drawables.hair,['@htxt']= textures.hair,['@shirts']= drawables.shirts,['@shtxt']= textures.shirts,['@hand']= drawables.hand,['@shoes']= drawables.shoes,['@stxt']= textures.shoes,['@pants']= drawables.pants,['@ptxt']= textures.pants,['@gloves']= drawables.gloves,['@gtxt']= textures.gloves,['@eyes']= drawables.eyes,['@etxt']= textures.eyes,['@accessories']= drawables.accessories,['@atxt']= textures.accessories,['@items']=drawables.items,['@itxt']= textures.items,['@decals']= drawables.decals,['@dtxt']= textures.decals,['@helmet']= drawables.helmet,['@mettxt']= textures.helmet,['@glasses']= drawables.glasses,['@lassestxt']= textures.glasses,['@earrings']=drawables.earrings,['@ringstxt']= textures.earrings,['@beard']= drawables.beard,['@eyebrow']= drawables.eyebrow,['@makeup']=drawables.makeup,['@lipstick']= drawables.lipstick, ['@dhtxt']= textures.hand,['@user']= identifier})
end)

-- get's the player id without having to use bugged essentials
function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

-- gets the actual player id unique to the player,
-- independent of whether the player changes their screen name
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end