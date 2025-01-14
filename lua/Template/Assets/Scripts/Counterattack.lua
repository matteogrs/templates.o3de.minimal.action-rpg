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

local Counterattack =
{
	Properties =
	{
		Delay = 1.0,
		OutOfRange = 3.0,

		Events =
		{
			ActionNotificationEvents = ScriptEventsAssetRef(),
			ActionRequestEvents = ScriptEventsAssetRef(),
			HealthRequestEvents = ScriptEventsAssetRef(),
			HealthNotificationEvents = ScriptEventsAssetRef(),
			MoveRequestEvents = ScriptEventsAssetRef()
		}
	}
}

function Counterattack:OnActivate()
	self.attack = false

	self.healthHandler = HealthRequestEvents.Connect(self, self.entityId)
	self.deathHandler = HealthNotificationEvents.Connect(self, self.entityId)
end

function Counterattack:DecreaseHealth(causeId)
	if causeId:IsValid() and not self.attack then
		self.attack = true
		self.attackerId = causeId

		MoveRequestEvents.Event.CancelMove(self.entityId)

		self.actionHandler = ActionNotificationEvents.Connect(self, self.entityId)
		self.transformHandler = TransformNotificationBus.Connect(self, self.attackerId)

		self:OnAttackEnd()
	end
end

function Counterattack:OnAttackEnd()
	self.timer = TimeDelay:Start(self.Properties.Delay, function() self:OnAttackDelayEnd() end)
end

function Counterattack:OnAttackDelayEnd()
	ActionRequestEvents.Event.Attack(self.entityId, self.attackerId)
end

function Counterattack:OnTransformChanged(localTransform, worldTransform)
	local attackerPosition = worldTransform.translation
	local position = CharacterControllerRequestBus.Event.GetBasePosition(self.entityId)

	if attackerPosition:GetDistance(position) > self.Properties.OutOfRange then
		self.actionHandler:Disconnect()
		self.transformHandler:Disconnect()

		self.attack = false

		MoveRequestEvents.Event.ResumeMove(self.entityId)
	end
end

function Counterattack:OnDead()
	if self.attack then
		self:StopAttack()
	end
end

function Counterattack:StopAttack()
	self.actionHandler:Disconnect()
	self.transformHandler:Disconnect()

	self.timer:Stop()

	self.attack = false
end

function Counterattack:OnDeactivate()
	self.healthHandler:Disconnect()
	self.deathHandler:Disconnect()

	if self.attack then
		self:StopAttack()
	end
end

return Counterattack
