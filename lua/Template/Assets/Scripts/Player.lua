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

local InputMultiHandler = require("Scripts.Utils.Components.InputUtils")
require("Assets.Scripts.Utils.RayCast")

local Player =
{
	Properties =
	{
		Events =
		{
			ActionRequestEvents = ScriptEventsAssetRef(),
			ActionNotificationEvents = ScriptEventsAssetRef(),
			MoveRequestEvents = ScriptEventsAssetRef()
		}
	}
}

function Player:OnActivate()
	self.attack = false
	self.actionHandler = ActionNotificationEvents.Connect(self, self.entityId)

	UiCursorBus.Broadcast.IncrementVisibleCounter()

	self.inputHandlers = InputMultiHandler.ConnectMultiHandlers
	{
		[InputEventNotificationId("Move")] =
		{
			OnPressed = function(value) self:OnMovePressed() end
		},
		[InputEventNotificationId("Attack")] =
		{
			OnPressed = function(value) self:OnAttackPressed() end
		}
	}

end

function Player:OnMovePressed()
	if not self.attack then
		local result = RayCastFromScreenCursor()

		if result ~= nil then
			MoveRequestEvents.Event.MoveToward(self.entityId, result.Position)
		end
	end
end

function Player:OnAttackPressed(value)
	if not self.attack then
		local result = RayCastFromScreenCursor()

		if result ~= nil then
			local isEnemy = TagComponentRequestBus.Event.HasTag(result.EntityId, Crc32("Enemy"))

			if isEnemy then
				self.attack = true
				MoveRequestEvents.Event.CancelMove(self.entityId)
				ActionRequestEvents.Event.Attack(self.entityId, result.EntityId)
			end
		end
	end
end

function Player:OnAttackEnd()
	self.attack = false
end

function Player:OnDeactivate()
	self.inputHandlers:Disconnect()
	self.actionHandler:Disconnect()
end

return Player
