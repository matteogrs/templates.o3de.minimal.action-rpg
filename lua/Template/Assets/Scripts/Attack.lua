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

local LerpBetween = require("Assets.Scripts.Utils.LerpBetween")

local Attack =
{
	Properties =
	{
		MeshId = EntityId(),
		AnimationOffset = 0.5,
		Duration = 1.0,
		Range = 2.0,

		Events =
		{
			ActionRequestEvents = ScriptEventsAssetRef(),
			ActionNotificationEvents = ScriptEventsAssetRef(),
			HealthRequestEvents = ScriptEventsAssetRef()
		}
	}
}

function Attack:OnActivate()
	self.halfDuration = self.Properties.Duration / 2.0

	self.actionHandler = ActionRequestEvents.Connect(self, self.entityId)
end

function Attack:Attack(targetId)
	local attackerPosition = CharacterControllerRequestBus.Event.GetBasePosition(self.entityId)

	local targetPosition = CharacterControllerRequestBus.Event.GetBasePosition(targetId)
	self.targetId = targetId

	local direction = (targetPosition - attackerPosition):GetNormalized()
	local maxAnimationPosition = direction * self.Properties.AnimationOffset

	self.lerp = LerpBetween:StartWithDuration(Vector3(0.0, 0.0, 0.0), maxAnimationPosition, self.halfDuration,
	{
		OnTick = function(value, percent) self:OnLerpTick(value, percent) end,
		OnCompleted = function() self:OnForwardLerpCompleted() end
	})
end

function Attack:OnLerpTick(value, percent)
	TransformBus.Event.SetLocalTranslation(self.Properties.MeshId, value)
end

function Attack:OnForwardLerpCompleted()
	local attackerPosition = CharacterControllerRequestBus.Event.GetBasePosition(self.entityId)
	local targetPosition = CharacterControllerRequestBus.Event.GetBasePosition(self.targetId)

	if attackerPosition:GetDistance(targetPosition) < self.Properties.Range then
		HealthRequestEvents.Event.DecreaseHealth(self.targetId, self.entityId)
	end

	self.lerp = LerpBetween:StartWithDuration(self.lerp.toValue, self.lerp.fromValue, self.halfDuration,
	{
		OnTick = function(value, percent) self:OnLerpTick(value, percent) end,
		OnCompleted = function() self:OnBackwardLerpCompleted() end
	})
end

function Attack:OnBackwardLerpCompleted()
	ActionNotificationEvents.Event.OnAttackEnd(self.entityId)
end

function Attack:OnDeactivate()
	self.actionHandler:Disconnect()

	if self.lerp ~= nil then
		self.lerp:Cancel()
		self.lerp = nil
	end
end

return Attack
