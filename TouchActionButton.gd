# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2026 Estudio Eclipse. All rights reserved.

extends Control
class_name TouchActionButton

## TouchActionButton
## Botón táctil configurable con soporte multi-touch para emular acciones del InputMap de Godot.

@export var action_name: StringName = &"interact"
@export var is_toggle: bool = false
@export var button_text: String = "ACCION"
@export var button_color: Color = Color(1.0, 1.0, 1.0, 0.85)

var is_pressed: bool = false
var touch_index: int = -1
var toggle_state: bool = false

var _label: Label = null
var _bg: Panel = null


func _ready() -> void:
	_label = get_node_or_null("Label") as Label
	_bg = get_node_or_null("Panel") as Panel
	if _label and not button_text.is_empty():
		_label.text = button_text


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch_ev := event as InputEventScreenTouch
		if touch_ev.pressed:
			if not is_pressed and get_global_rect().has_point(touch_ev.position):
				touch_index = touch_ev.index
				is_pressed = true
				if is_toggle:
					toggle_state = not toggle_state
					_emit_action(toggle_state)
				else:
					_emit_action(true)
		elif touch_ev.index == touch_index:
			touch_index = -1
			is_pressed = false
			if not is_toggle:
				_emit_action(false)


func _emit_action(pressed: bool) -> void:
	if action_name.is_empty() or not InputMap.has_action(action_name):
		return
	if pressed:
		Input.action_press(action_name)
	else:
		Input.action_release(action_name)
