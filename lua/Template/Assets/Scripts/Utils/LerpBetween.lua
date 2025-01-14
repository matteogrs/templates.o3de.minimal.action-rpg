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

local LerpBetween = {}

function LerpBetween:StartWithDuration(from, to, duration, callbacks)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self

	instance.fromValue = from
	instance.toValue = to
	instance.isNumber = (type(from) == "number")
	instance.callbacks = callbacks

	instance.duration = duration
	instance.elapsedTime = 0.0

	instance.tickHandler = TickBus.Connect(instance)

	return instance
end

function LerpBetween:StartWithSpeed(from, to, speed, callbacks)
	local distance
	if type(from) == "number" then
		distance = Math.Abs(to - from)
	else
		distance = from:GetDistance(to)
	end

	local duration = distance / speed

	return self:StartWithDuration(from, to, duration, callbacks)
end

function LerpBetween:OnTick(deltaTime, time)
	self.elapsedTime = self.elapsedTime + deltaTime

	local parameter = Math.Min(self.elapsedTime / self.duration, 1.0)
	local value
	if self.isNumber then
		value = Math.Lerp(self.fromValue, self.toValue, parameter)
	else
		value = self.fromValue:Lerp(self.toValue, parameter)
	end

	if self.callbacks.OnTick ~= nil then
		self.callbacks.OnTick(value, parameter)
	end

	if self.elapsedTime > self.duration then
		self.tickHandler:Disconnect()
		self.tickHandler = nil

		if self.callbacks.OnCompleted ~= nil then
			self.callbacks.OnCompleted()
		end
	end
end

function LerpBetween:Cancel()	
	if self.tickHandler ~= nil then
		self.tickHandler:Disconnect()
		self.tickHandler = nil

		if self.callbacks.OnCanceled ~= nil then
			self.callbacks.OnCanceled()
		end
	end
end

return LerpBetween
