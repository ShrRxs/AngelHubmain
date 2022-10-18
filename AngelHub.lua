-- getgenv().Key = ""

repeat wait(1) until game:IsLoaded()

    if not getgenv().Key then
        repeat wait() until getgenv().Key
    end
    
    request = http_request or request or HttpPost or syn.request
    hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    Payload = game:GetService("HttpService"):JSONEncode({key = getgenv().Key, hwid = hwid, type = 0})
    response = request({
        Url = "https://bot-test-tawan.herokuapp.com/api/v1/",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
     Body = Payload
    })
    local j = game:GetService("HttpService"):JSONDecode(response.Body)
    if j["success"] then
      game.StarterGui:SetCore("SendNotification", {
          Icon = "rbxassetid://11311034566";
          Title = "Angel Hub", 
          Text = "Check Whilelist Success!"
      })
        else
            game.Players.LocalPlayer:Kick(j["message"])
     end
    function Hop()
	local PlaceID = game.PlaceId
	local AllIDs = {}
	local foundAnything = ""
	local actualHour = os.date("!*t").hour
	local Deleted = false
	function TPReturner()
		local Site;
		if foundAnything == "" then
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
		else
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
		end
		local ID = ""
		if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
			foundAnything = Site.nextPageCursor
		end
		local num = 0;
		for i,v in pairs(Site.data) do
			local Possible = true
			ID = tostring(v.id)
			if tonumber(v.maxPlayers) > tonumber(v.playing) then
				for _,Existing in pairs(AllIDs) do
					if num ~= 0 then
						if ID == tostring(Existing) then
							Possible = false
						end
					else
						if tonumber(actualHour) ~= tonumber(Existing) then
							local delFile = pcall(function()
								AllIDs = {}
								table.insert(AllIDs, actualHour)
							end)
						end
					end
					num = num + 1
				end
				if Possible == true then
					table.insert(AllIDs, ID)
					wait()
					pcall(function()
						wait()
						game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
					end)
					wait(4)
				end
			end
		end
	end
	function Teleport() 
		while wait() do
			pcall(function()
				TPReturner()
				if foundAnything ~= "" then
					TPReturner()
				end
			end)
		end
	end
	Teleport()
end

_G.Near_Player_Hop = true --เปิดtrueปิดfalse

spawn(function()
    while wait() do
        if _G.Near_Player_Hop then
            pcall(function()
                for i,v in pairs(game:GetService("Workspace").Characters:GetChildren()) do
                    if v.Name ~= game.Players.LocalPlayer.Name then
                        if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1000 then -- ใส่ระยะห่าง
                            warn("Found Player")
                            Hop()
                        end
                    end
                end
            end)
        end
    end
end)
