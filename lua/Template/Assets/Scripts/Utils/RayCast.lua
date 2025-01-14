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

-- This function is ported from the C++ implementation that is bundled in O3DE engine to Lua.
-- See the original file at:
--
--     <O3DE>/Gems/ScriptCanvasPhysics/Code/Source/World.cpp
--
-- Original notice:
--
--     Copyright (c) Contributors to the Open 3D Engine Project.
--     For complete copyright and license terms please see the LICENSE at the root of this distribution.
--
--     SPDX-License-Identifier: Apache-2.0 OR MIT

function RayCastFromScreenCursor()
	local screenPosition = UiCursorBus.Broadcast.GetUiCursorPosition()
	
	local cameraId = CameraSystemRequestBus.Broadcast.GetActiveCamera()

	local origin = CameraRequestBus.Event.ScreenToWorld(cameraId, screenPosition, 0.0)
	local offset = CameraRequestBus.Event.ScreenToWorld(cameraId, screenPosition, 1.0)

	local direction = (offset - origin):GetNormalized()
	local request = SceneQueries.CreateRayCastRequest(origin, direction, 500, "All")

	local physicsSystem = GetPhysicsSystem()
	local physicsSceneHandle = physicsSystem:GetSceneHandle(DefaultPhysicsSceneName)
	local physicsScene = physicsSystem:GetScene(physicsSceneHandle)

	local result = physicsScene:QueryScene(request)
	if not result.HitArray:Empty() then
		return result.HitArray[1]
	else
		return nil
	end
end
