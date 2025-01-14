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

local Item =
{
	Properties =
	{
		Events =
		{
			HealthRequestEvents = ScriptEventsAssetRef()
		}
	}
}

function Item:OnActivate()
	self.physicsHandler = RigidBodyNotificationBus.Connect(self, self.entityId)
end

function Item:OnPhysicsEnabled(entityId)
	self.triggerHandler = SimulatedBody.GetOnTriggerEnterEvent(entityId)

	self.triggerHandler:Connect(function(bodyHandle, triggerEvent) self:OnTriggerEnter(triggerEvent) end)
end

function Item:OnTriggerEnter(triggerEvent)
	local otherId = triggerEvent:GetOtherEntityId()

	local isPlayer = TagComponentRequestBus.Event.HasTag(otherId, Crc32("Player"))
	if isPlayer then
		HealthRequestEvents.Event.IncreaseHealth(otherId)

		local containerId = TransformBus.Event.GetParentId(self.entityId)
		GameEntityContextRequestBus.Broadcast.DestroyGameEntityAndDescendants(containerId)
	end
end

function Item:OnDeactivate()
	self.physicsHandler:Disconnect()
end

return Item
