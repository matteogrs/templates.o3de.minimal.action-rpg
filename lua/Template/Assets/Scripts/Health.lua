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

local Health =
{
	Properties =
	{
		MeshId = EntityId(),
		MaxValue = 3.0,
		RespawnDelay = 2.0,

		Events =
		{
			HealthRequestEvents = ScriptEventsAssetRef(),
			HealthNotificationEvents = ScriptEventsAssetRef()
		}
	}
}

function Health:OnActivate()
	self.value = self.Properties.MaxValue
	self.respawnPosition = CharacterControllerRequestBus.Event.GetBasePosition(self.entityId) or Vector3(0.0, 0.0, 0.0)

	self.healthHandler = HealthRequestEvents.Connect(self, self.entityId)
end

function Health:IncreaseHealth()
	local newValue = Math.Min(self.value + 1, self.Properties.MaxValue)
	self:SetHealth(newValue)
end

function Health:DecreaseHealth()
	local newValue = Math.Max(self.value - 1, 0.0)
	self:SetHealth(newValue)
end

function Health:SetHealth(value)
	self.value = value

	if value > 0.0 then
		local height = value / self.Properties.MaxValue
		local scale = Vector3(1.0, 1.0, height)

		NonUniformScaleRequestBus.Event.SetScale(self.Properties.MeshId, scale)
	else
		RenderMeshComponentRequestBus.Event.SetVisibility(self.Properties.MeshId, false)
		SimulatedBodyComponentRequestBus.Event.DisablePhysics(self.entityId)

		HealthNotificationEvents.Event.OnDead(self.entityId)

		self.timer = TimeDelay:Start(self.Properties.RespawnDelay, function() self:OnRespawn() end)
	end
end

function Health:OnRespawn()
	self.value = self.Properties.MaxValue

	TransformBus.Event.SetWorldTranslation(self.entityId, self.respawnPosition)
	NonUniformScaleRequestBus.Event.SetScale(self.Properties.MeshId, Vector3(1.0, 1.0, 1.0))

	SimulatedBodyComponentRequestBus.Event.EnablePhysics(self.entityId)
	RenderMeshComponentRequestBus.Event.SetVisibility(self.Properties.MeshId, true)

	HealthNotificationEvents.Event.OnSpawn(self.entityId)
end

function Health:OnDeactivate()
	self.healthHandler:Disconnect()
	
	if self.timer ~= nil then
		self.timer:Stop()
		self.timer = nil
	end
end

return Health
