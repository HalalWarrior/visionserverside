--[[
  Vision – server-side HTTP helper (Roblox Studio)

  One-time in Studio:
  1) Game Settings → Security → “Allow HTTP Requests” → ON
  2) Copy this file into ServerScriptService as a Script
  3) Set BASE_URL to your deployed site (e.g. https://your-app.vercel.app) — no trailing slash
  4) Set KEY_SLOT to the same value as “Key” in the website Settings, then Apply

  The site stores text at GET /key/<KEY_SLOT>. This script polls and receives that text.
  Use the string only in ways your game allows.
]]

local HttpService = game:GetService("HttpService")

local BASE_URL = "https://YOUR-DEPLOY.vercel.app"
local KEY_SLOT = "default"
local POLL_SECONDS = 5

local lastHash = ""

local function getScriptText()
	local url = BASE_URL .. "/key/" .. KEY_SLOT
	local ok, res = pcall(function()
		return HttpService:GetAsync(url, true)
	end)
	if not ok then
		warn("[Vision] GET failed: ", res)
		return nil
	end
	if type(res) ~= "string" then
		return nil
	end
	return res
end

while task.wait(POLL_SECONDS) do
	local text = getScriptText()
	if text ~= nil then
		local h = tostring(#text) .. ":" .. string.sub(text, 1, math.min(64, #text))
		if h ~= lastHash then
			lastHash = h
			print("[Vision] New payload from site, length ", #text)
			-- Handle `text` here (your game’s logic).
		end
	end
end
