-- Copyright (c) 2025 Matteo Grasso
-- 
--     https://github.com/matteogrs/templates.o3de.minimal.action-rpg
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

local TimeDelay = {}

function TimeDelay:Start(delay, callback)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self

	instance.timer = delay
	instance.callback = callback
	instance.tickHandler = TickBus.Connect(instance)

	return instance
end

function TimeDelay:OnTick(deltaTime, time)
	self.timer = self.timer - deltaTime

	if self.timer < 0.0 then
		self.tickHandler:Disconnect()
		self.tickHandler = nil

		if self.callback ~= nil then
			self.callback()
		end
	end
end

function TimeDelay:Stop()
	if self.tickHandler ~= nil then
		self.tickHandler:Disconnect()
		self.tickHandler = nil
	end
end

return TimeDelay
