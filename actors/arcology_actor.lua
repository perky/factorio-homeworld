function ArcologyActor( entity )
	local arcology = {
		entity = entity,
		population = 6,
		max_population_growth = 6,
		max_population_shrink = 12,
		min_satisfaction_for_population_growth = 0.75,
		max_satisfaction_for_population_shrink = 0.35,
		max_population = 2000,
		min_population = 6,
		guiActive = false,
		take_need_rate = 60*1,
		enabled = true
	}

	arcology.needs = {
		{
			item = "raw-fish",
			per_capita = 2,
			consumption = 0.01
		},
		{
			item = "wood",
			per_capita = 1,
			consumption = 0.01
		}
	}

	function arcology:NeedRoutine()
		while self.enabled do
			WaitForTicks(60)
			for _, need in ipairs(self.needs) do
				if not need.amountTaken or need.amountTaken == 0 then
					 need.amountTaken = 0
				else
					need.amountTaken = need.amountTaken - (need.consumption * self.population)
					if need.amountTaken < 0 then need.amountTaken = 0 end
				end
			end
			self:TakeNeeds2()
			coroutine.yield()
		end
	end

	function arcology:PopulationRoutine()
		while self.enabled do
			WaitForTicks(60*6)
			self:UpdatePopulation()
			coroutine.yield()
		end
	end

	function arcology:TakeNeeds2()
		local inventory = self.entity.getinventory(1)

		local totalNeeded = 0
		local totalTaken = 0
		for _, need in ipairs(self.needs) do
			if not need.amountTaken then
				need.amountTaken = 0
			end
			need.amountNeeded = need.per_capita * self.population
			totalNeeded = totalNeeded + need.amountNeeded
			totalTaken = totalTaken + need.amountTaken
		end

		while totalTaken < totalNeeded do
			local takenThisLoop = 0
			for _, need in ipairs(self.needs) do
				if need.amountTaken < need.amountNeeded and inventory.getitemcount(need.item) > 0 then
					inventory.remove{name = need.item, count = 1}
					totalTaken = totalTaken + 1
					takenThisLoop = takenThisLoop + 1
					need.amountTaken = need.amountTaken + 1
				end
			end
			if takenThisLoop == 0 then
				return
			end
			WaitForTicks(10)
		end
	end

	function arcology:TakeNeeds()
		local inventory = self.entity.getinventory(1)

		for i, need in ipairs(self.needs) do
			-- NOTE(luke): reduce the satisfaction by the desaturation amount.
			-- then calculate how much resources are need and try to take them.
			need.satisfaction = need.satisfaction - need.desaturation
			if need.satisfaction < 0 then need.satisfaction = 0 end
			local unsatisfied = 1-need.satisfaction
			local amountNeeded = math.floor(need.per_capita * self.population * unsatisfied)
			if amountNeeded > 0 then
				local amountTaken = 0
				for i = 0, amountNeeded do
					if inventory.getitemcount(need.item) > 0 then
						inventory.remove{name = need.item, count = 1}
						amountTaken = amountTaken + 1
						need.satisfaction = amountTaken / amountNeeded
						coroutine.yield()
					else
						break
					end
				end
			end
		end
	end

	function arcology:UpdatePopulation()
		local totalSatisfaction = 0
		for i, need in ipairs(self.needs) do
			totalSatisfaction = totalSatisfaction + (need.amountTaken / need.amountNeeded)
		end
		local averageSatisfaction = totalSatisfaction / #self.needs

		if self.population < self.max_population and averageSatisfaction >= self.min_satisfaction_for_population_growth then
			local popGrowth = self.max_population_growth * averageSatisfaction
			for i = 0, popGrowth do
				self.population = self.population + 1
				WaitForTicks(30)
			end
		elseif averageSatisfaction <= self.max_satisfaction_for_population_shrink then
			local popShrink = (1 - averageSatisfaction) * self.max_population_shrink
			for i = 0, popShrink do
				self.population = self.population - 1
				WaitForTicks(15)
			end
		end

		if self.population < self.min_population then
			self.population = self.min_population
		end
	end

	function arcology:Init()
		self.need_routine = coroutine.create(arcology.NeedRoutine)
		self.population_routine = coroutine.create(arcology.PopulationRoutine)
	end

	function arcology:OnTick()
		local openedEntity = game.player.opened
		if openedEntity ~= nil 
			and openedEntity.equals(self.entity) 
			and not self.guiActive then
			self:OpenGUI()
		elseif self.guiActive and openedEntity == nil then
			self:CloseGUI()
		end

		coroutine.resume(self.need_routine, self)
		coroutine.resume(self.population_routine, self)

		if self.guiActive then
			self:UpdateGUI()
		end
	end

	function arcology:OnDestroy()
	end

	function arcology:OpenGUI()
		self.guiActive = true

		GUI.PushParent(game.player.gui.left)
		self.gui = GUI.Frame("arcology_frame", "Arcology", GUI.VERTICAL)

		GUI.PushParent(self.gui)
		local populationFlow = GUI.Flow("population", GUI.HORIZONTAL)
		GUI.PushParent(populationFlow)
			GUI.Label("pop_label", "Population:")
			GUI.Label("pop_value", "0/0")
		GUI.PopParent()
		GUI.ProgressBar("population_bar", self.max_population)

		GUI.PushParent(GUI.Frame("needs", "Needs", GUI.VERTICAL))
		for i, need in ipairs(self.needs) do
			GUI.PushParent(GUI.Flow("need_"..i, GUI.VERTICAL))
				GUI.PushParent(GUI.Flow("label_icon", GUI.HORIZONTAL))
					GUI.Icon("icon", need.item)
					GUI.Label("label", need.item)
				GUI.PopParent()
				GUI.ProgressBar("satisfaction", 1, 0, "health_progressbar_style")
			GUI.PopParent()
		end

		GUI.PopAll()
	end

	function arcology:CloseGUI()
		self.guiActive = false
		game.player.gui.left.arcology_frame.destroy()
	end

	function  arcology:UpdateGUI()
		if not self.guiActive then
			return
		end

		self.gui.population.pop_value.caption = string.format("%u/%u", self.population, self.max_population)
		self.gui.population_bar.value = self.population / self.max_population
		for i, need in ipairs(self.needs) do
			local gui = self.gui.needs["need_"..i]
			if need.amountTaken then
				gui.satisfaction.value = need.amountTaken / need.amountNeeded
				gui.label_icon.label.caption = string.format("%s [%f/%f]", need.item, need.amountTaken, need.amountNeeded)
			end
		end
	end

	return arcology
end
