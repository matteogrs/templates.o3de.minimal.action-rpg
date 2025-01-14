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

local Move =
{
	Properties =
	{
		Speed = 2.0,
		Tolerance = 0.1,

		Events =
		{
			MoveRequestEvents = ScriptEventsAssetRef(),
			MoveNotificationEvents = ScriptEventsAssetRef()
		}
	}
}

function Move:OnActivate()
	self.moveHandler = MoveRequestEvents.Connect(self, self.entityId)
end

function Move:MoveToward(position)
	self.endPosition = Vector3(position.x, position.y, 0.0)

	if self.tickHandler == nil then
		self.tickHandler = TickBus.Connect(self)
	end
end

function Move:OnTick(deltaTime, time)
	local position = CharacterControllerRequestBus.Event.GetBasePosition(self.entityId)
	position.z = 0.0

	local distance = self.endPosition - position
	if distance:GetLength() > self.Properties.Tolerance then
		local direction = distance:GetNormalized()
		local velocity = direction * self.Properties.Speed
		
		CharacterControllerRequestBus.Event.AddVelocityForTick(self.entityId, velocity)
	else
		self.tickHandler:Disconnect()
		self.tickHandler = nil

		MoveNotificationEvents.Event.OnMoveEnd(self.entityId)
	end
end

function Move:CancelMove()
	if self.tickHandler ~= nil then
		self.tickHandler:Disconnect()
		self.tickHandler = nil
	end
end

function Move:ResumeMove()
	if self.tickHandler == nil then
		self.tickHandler = TickBus.Connect(self)
	end
end

function Move:OnDeactivate()
	self.moveHandler:Disconnect()
	self:CancelMove()
end

return Move
