# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2026 Estudio Eclipse. All rights reserved.

@tool
extends EditorPlugin
## Touch Controls Pro Plugin for Godot 4.x

func _enter_tree() -> void:
	add_custom_type("VirtualJoystick", "Control", preload("VirtualJoystick.gd"), null)
	add_custom_type("TouchActionButton", "Control", preload("TouchActionButton.gd"), null)
	print("[TouchControlsPro] Plugin activado.")


func _exit_tree() -> void:
	remove_custom_type("VirtualJoystick")
	remove_custom_type("TouchActionButton")
	print("[TouchControlsPro] Plugin desactivado.")
