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

local TimeDelay = require("Assets.Scripts.Utils.TimeDelay")

local Patrol =
{
	Properties =
	{
		Points =
		{
			Vector3(0.0, 0.0, 0.0)
		},

		Events =
		{
			HealthNotificationEvents = ScriptEventsAssetRef(),
			MoveRequestEvents = ScriptEventsAssetRef(),
			MoveNotificationEvents = ScriptEventsAssetRef()
		}
	}
}

function Patrol:OnActivate()
	self.healthHandler = HealthNotificationEvents.Connect(self, self.entityId)
	self.moveHandler = MoveNotificationEvents.Connect(self, self.entityId)

	self.timer = TimeDelay:Start(1.0, function() self:OnSpawn() end)
end

function Patrol:OnSpawn()
	self.pointIndex = 0
	
	local firstPointPosition = self.Properties.Points[1]
	CharacterControllerRequestBus.Event.SetBasePosition(self.entityId, firstPointPosition)

	self:OnMoveEnd()
end

function Patrol:OnMoveEnd()
	self.pointIndex = (self.pointIndex + 1) % #self.Properties.Points

	local nextPointPosition = self.Properties.Points[1 + self.pointIndex]
	MoveRequestEvents.Event.MoveToward(self.entityId, nextPointPosition)
end

function Patrol:OnDeactivate()
	self.moveHandler:Disconnect()
	self.healthHandler:Disconnect()
end

return Patrol
