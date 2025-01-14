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

local Drop =
{
	Properties =
	{
		ItemPrefab = SpawnableScriptAssetRef(),

		Events =
		{
			HealthNotificationEvents = ScriptEventsAssetRef()
		}
	}
}

function Drop:OnActivate()
	self.spawnSystem = SpawnableScriptMediator()
	self.spawnTicket = self.spawnSystem:CreateSpawnTicket(self.Properties.ItemPrefab)
	
	self.healthHandler = HealthNotificationEvents.Connect(self, self.entityId)
end

function Drop:OnDead()
	local position = TransformBus.Event.GetLocalTranslation(self.entityId)
	local parentId = TransformBus.Event.GetParentId(self.entityId)

	self.spawnSystem:SpawnAndParentAndTransform(self.spawnTicket, parentId, position, Vector3(0.0, 0.0, 0.0), 1.0)
end

function Drop:OnDeactivate()
	self.healthHandler:Disconnect()
end

return Drop
