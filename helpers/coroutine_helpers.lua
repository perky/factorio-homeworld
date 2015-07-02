KILL_ROUTINE = -1

local routines = {}
local queued_events = {}

function WaitForTicks( ticks )
	local endTicks = game.tick + ticks
	while true do
		if game.tick >= endTicks then
			return 
		end
		coroutine.yield()
	end
end

function QueueEvent( event, data )
	table.insert(queued_events, {event = event, data = data})
end

function SafeResumeCoroutine( co, arg1 )
	if coroutine.status(co) == "dead" then
		return false
	else
		local success, err = coroutine.resume(co, arg1)
		if success then
			return true
		else
			if err then
				game.player.print(err)
			end
			return false
		end
	end
end

local function ResumeRoutine( routine, index )
	if routine then
		local status = coroutine.status(routine.co)
		if status == "dead" and index then
			table.remove(routines, index)
			return false
		elseif status == "suspended" then
			local success, result1 = coroutine.resume(routine.co, routine.args)
			if success then
				if result1 == KILL_ROUTINE and index then
					table.remove(routines, index)
					return false
				else
					return true, result1
				end
			else
				if result1 then
					game.player.print(tostring(result1))
					return false, result1
				else
					return false
				end
			end
		end
	end
end

function StartCoroutine( func, args, autoResume )
	if autoResume == nil then
		autoResume = true
	end

	local co = coroutine.create(func)
	local routine = { co = co, args = args }
	if autoResume then
		table.insert(routines, routine)
		ResumeRoutine(routine, #routines)
	end

	return routine
end

function ResumeRoutines()
	for i = #routines, 0, -1 do
		local routine = routines[i]
		ResumeRoutine(routine, i)
	end

	if #queued_events > 0 then
		for i = #queued_events, 0, -1 do
			local e = queued_events[i]
			if e then
				game.raiseevent(e.event, e.data)
				table.remove(queued_events, i)
			end
		end
	end
end

function DestroyRoutines( owner )
	for i = #routines, 0, -1 do
		local routine = routines[i]
		if routine and routine.args == owner then
			table.remove(routines, i)
		end
	end
end

function GetAllRoutines()
	return routines
end

function InsertRoutines( allRoutines )
	for i, r in ipairs(allRoutines) do
		table.insert(routine, r)
	end
end