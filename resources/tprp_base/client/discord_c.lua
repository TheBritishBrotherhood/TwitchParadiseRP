-- CONFIG --

-- The watermark text --
servernames = "https://discord.gg/XSaNXQQ"

-- The x and y offset (starting at the top left corner) --
-- Default: 0.005, 0.001
offsets = {x = 0.457, y = 0.03}

-- Text RGB Color --
-- Default: 64, 64, 64 (gray)
rgb = {r = 255, g = 255, b = 255}

-- Text transparency --
-- Default: 255
alpha = 255

-- Text scale
-- Default: 0.4
-- NOTE: Number needs to be a float (so instead of 1 do 1.0)
scales = 0.35

-- Text Font --
-- 0 - 5 possible
-- Default: 1
font = 4

-- Rainbow Text --
-- false: Turn off
-- true: Activate rainbow text (overrides color)
bringontherainbows = false

-- CODE --
Citizen.CreateThread(function()
	while true do
		Wait(1)

		if bringontherainbows then
			rgb = RGBRainbow(1)
		end
		SetTextColour(rgb.r, rgb.g, rgb.b, alpha)

		SetTextFont(font)
		SetTextScale(scales, scales)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(2, 2, 0, 0, 0)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(servernames)
		DrawText(offsets.x, offsets.y)
	end
end)

