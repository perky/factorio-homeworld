ActorClass("Sawmill", {
	saw_interval = 10 * SECONDS,
	work_radius = 20
})

function Sawmill:Init()
	self.enabled = true
	StartCoroutine(self.SawRoutine, self)
end

function Sawmill:OnLoad()
	self.enabled = true
	StartCoroutine(self.SawRoutine, self)
end

function Sawmill:OnDestroy()
	self.enabled = false
	DestroyRoutines(self)
end

function Sawmill:SawRoutine()
	WaitForTicks(3 * SECONDS)

	local inventory = self.entity.getinventory(1)
	local pos = self.entity.position
	local r = self.work_radius
	local ents = game.findentities{{pos.x - r, pos.y - r},{pos.x + r, pos.y + r}}
	
	ShuffleTable(ents)
	for _, ent in ipairs(ents) do
		if ent and ent.valid and ent.type == "tree" then
			ent.destroy()
			local item = {name = "raw-wood", count = 5}
			while not inventory.caninsert(item) do
				coroutine.yield()
			end
			inventory.insert(item)
			WaitForTicks(self.saw_interval)
		else
			coroutine.yield()
		end
	end
end
