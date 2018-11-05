Citizen.CreateThread(function()
local hospitalPickup = {
{x= 1839.41, y= 3672.90, z=34.28},
{x= -247.76, y= 6331.23, z=32.43},
{x= -449.67, y= -340.83, z= 34.50},
{x= 357.43, y= -593.36, z= 28.79},
{x= 295.83, y= -1446.94, z= 29.97},
{x= -676.98, y= 310.68, z= 83.08},
{x= 1151.21, y= -1529.62, z= 35.37},
{x= -874.64, y= -307.71, z= 39.58}
}

local hospitals = {
{id=61, x= 1839.6, y= 3672.93, z= 34.28},
{id=61, x= -247.76, y= 6331.23, z=32.43},
{id=61, x= -449.67, y= -340.83, z= 34.50},
{id=61, x= 357.43, y= -593.36, z= 28.79},
{id=61, x= 295.83, y= -1446.94, z= 29.97},
{id=61, x= -676.98, y= 310.68, z= 83.08},
{id=61, x= 1151.21, y= -1529.62, z= 35.37},
{id=61, x= -874.64, y= -307.71, z= 39.58}
}

-- Create blips on the map for all the hospitals
for _, map in pairs(hospitals) do
map.blip = AddBlipForCoord(map.x, map.y, map.z)
SetBlipSprite(map.blip, map.id)
SetBlipAsShortRange(map.blip, true)
end

-- Spawn the pickup items
for _, item in pairs(hospitalPickup) do
pickup = CreatePickup(GetHashKey("PICKUP_HEALTH_STANDARD"), item.x, item.y, item.z)
SetPickupRegenerationTime(pickup, 60)
end

end)