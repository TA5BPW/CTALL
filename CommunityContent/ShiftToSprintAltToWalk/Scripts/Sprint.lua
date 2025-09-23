local DefaultSpeed = 700
local SprintMulti = 2
local WalkMulti = .25
local Table = {}
--IsBindingPressed("ability_extra_12")
--:Cancel()
local TaskTable = {}
local WalkTaskTable = {}
function OnBindingPressed(player, binding)
	--print("player " .. player.name .. " pressed binding: " .. binding)
	if (binding == "ability_extra_12") and Table[player].Stamina >= 1 then -- Left Shift
		Table[player].Sprint = true
		--print("spawning task")
		if TaskTable[player] ~= nil then
			TaskTable[player]:Cancel()
		end
		TaskTable[player] = Task.Spawn(function ()
			if player:IsBindingPressed("ability_extra_12") == true then
				if Table[player].Stamina > 1 and Table[player].Sprint == true then
					Table[player].Stamina = Table[player].Stamina - 1
					--print(Table[player].Stamina, "Task Spawned counter -")
				else
					player.maxWalkSpeed = DefaultSpeed
				end
			end
		end)
		TaskTable[player].repeatCount = 10
		TaskTable[player].repeatInterval = 1
		player.maxWalkSpeed = DefaultSpeed*SprintMulti
	end
	if (binding == "ability_extra_14") then -- Left Alt
		Table[player].Walk = true
		--print("spawning task")
		if WalkTaskTable[player] ~= nil then
			WalkTaskTable[player]:Cancel()
		end
		WalkTaskTable[player] = Task.Spawn(function ()
			if player:IsBindingPressed("ability_extra_14") == true then
				if Table[player].Walk == true then
					
					--print("Player is Walking")
				else
					player.maxWalkSpeed = DefaultSpeed
				end
			end
		end)
		WalkTaskTable[player].repeatCount = 10
		WalkTaskTable[player].repeatInterval = 1
		player.maxWalkSpeed = DefaultSpeed*WalkMulti
	end
end

function OnBindingReleased(player, binding)
--	print("player " .. player.name .. " released binding: " .. binding)
	if (binding == "ability_extra_12") then  -- Left Shift
		Table[player].Sprint = false
		if TaskTable[player] ~= nil then
			TaskTable[player]:Cancel()
		end
		TaskTable[player] = Task.Spawn(function ()
			if player:IsBindingPressed("ability_extra_12") == false then
				if Table[player].Stamina < 10 and Table[player].Sprint == false then
					Table[player].Stamina = Table[player].Stamina + 1
					--print(Table[player].Stamina, "Task Spawned counter +")
				end
			end
		end)
		TaskTable[player].repeatCount = 10
		TaskTable[player].repeatInterval = 1
		player.maxWalkSpeed = DefaultSpeed
	end
	if (binding == "ability_extra_14") then -- Left Alt
		Table[player].Walk = false
		if WalkTaskTable[player] ~= nil then
			WalkTaskTable[player]:Cancel()
		end
		player.maxWalkSpeed = DefaultSpeed
	end
end

function OnPlayerJoined(player)
	-- hook up binding in player joined event here, move to more appropriate place if needed
	player.bindingPressedEvent:Connect(OnBindingPressed)
	player.bindingReleasedEvent:Connect(OnBindingReleased)
	TaskTable[player] = nil
	--WalkTaskTable[player] = nil
	Table[player] = {}
	Table[player].Sprint = false
	Table[player].Walk = false
	Table[player].Stamina = 10 -- Can adjust this later for different Max Staminas, 
	--Need to make many adjustments to how stamina is stored for dynamic/variable Stats
	player.maxWalkSpeed = DefaultSpeed
end

function OnPlayerLeft(player)
	--print("player left: " .. player.name)
	TaskTable[player] = nil
	Table[player] = nil
	WalkTaskTable[player] = nil
end


-- on player joined/left functions need to be defined before calling event:Connect()

Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)
