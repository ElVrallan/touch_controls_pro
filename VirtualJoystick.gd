# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2026 Estudio Eclipse. All rights reserved.

extends Control
class_name VirtualJoystick

## VirtualJoystick
## Joystick virtual multi-touch altamente responsivo para juegos 2D y 3D en Godot 4.x.
## Soporta modos Fijo (Fixed), Dinámico (Dynamic) y Flotante (Floating).

enum JoystickMode { FIXED, DYNAMIC, FLOATING }

@export var mode: JoystickMode = JoystickMode.DYNAMIC
@export var clamp_zone_radius: float = 75.0
@export var deadzone_radius: float = 12.0
@export var action_left: StringName = &"move_left"
@export var action_right: StringName = &"move_right"
@export var action_up: StringName = &"move_forward"
@export var action_down: StringName = &"move_backward"

var is_pressed: bool = false
var touch_index: int = -1
var output_vector := Vector2.ZERO

var _base_default_pos := Vector2.ZERO
var _tip: Control = null
var _base: Control = null


func _ready() -> void:
	_base = get_node_or_null("Base") as Control
	_tip = get_node_or_null("Base/Tip") as Control
	if _base:
		_base_default_pos = _base.position
	_reset_joystick()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch_ev := event as InputEventScreenTouch
		if touch_ev.pressed:
			if not is_pressed and _is_touch_in_activation_zone(touch_ev.position):
				_start_touch(touch_ev.index, touch_ev.position)
		elif touch_ev.index == touch_index:
			_end_touch()

	elif event is InputEventScreenDrag:
		var drag_ev := event as InputEventScreenDrag
		if drag_ev.index == touch_index:
			_update_drag(drag_ev.position)


func _is_touch_in_activation_zone(pos: Vector2) -> bool:
	if mode == JoystickMode.FIXED:
		if _base:
			var base_center: Vector2 = _base.global_position + (_base.size * 0.5)
			return pos.distance_to(base_center) <= clamp_zone_radius * 1.5
		return get_global_rect().has_point(pos)
	var vp_size := get_viewport_rect().size
	return pos.x < (vp_size.x * 0.5) and pos.y > (vp_size.y * 0.25)


func _start_touch(index: int, pos: Vector2) -> void:
	is_pressed = true
	touch_index = index
	if _base:
		if mode == JoystickMode.DYNAMIC or mode == JoystickMode.FLOATING:
			_base.global_position = pos - (_base.size * 0.5)
			_base.visible = true
	_update_drag(pos)


func _update_drag(pos: Vector2) -> void:
	if not _base or not _tip:
		return

	var base_center: Vector2 = _base.global_position + (_base.size * 0.5)
	var diff: Vector2 = pos - base_center
	var dist: float = diff.length()

	if mode == JoystickMode.FLOATING and dist > clamp_zone_radius:
		var excess: Vector2 = diff.normalized() * (dist - clamp_zone_radius)
		_base.global_position += excess
		base_center = _base.global_position + (_base.size * 0.5)
		diff = pos - base_center
		dist = clamp_zone_radius

	var clamped_diff: Vector2 = diff
	if dist > clamp_zone_radius:
		clamped_diff = diff.normalized() * clamp_zone_radius

	_tip.position = (_base.size * 0.5) + clamped_diff - (_tip.size * 0.5)

	if dist < deadzone_radius:
		output_vector = Vector2.ZERO
	else:
		var norm_dist: float = (dist - deadzone_radius) / (clamp_zone_radius - deadzone_radius)
		output_vector = diff.normalized() * clampf(norm_dist, 0.0, 1.0)

	_apply_input_actions(output_vector)


func _end_touch() -> void:
	is_pressed = false
	touch_index = -1
	output_vector = Vector2.ZERO
	_reset_joystick()
	_apply_input_actions(Vector2.ZERO)


func _reset_joystick() -> void:
	if _base:
		if mode == JoystickMode.DYNAMIC:
			_base.visible = false
		_base.position = _base_default_pos
		if _tip:
			_tip.position = (_base.size * 0.5) - (_tip.size * 0.5)


func _apply_input_actions(vec: Vector2) -> void:
	_update_action(action_right, vec.x > 0.3, maxf(0.0, vec.x))
	_update_action(action_left, vec.x < -0.3, maxf(0.0, -vec.x))
	_update_action(action_down, vec.y > 0.3, maxf(0.0, vec.y))
	_update_action(action_up, vec.y < -0.3, maxf(0.0, -vec.y))


func _update_action(action_name: StringName, pressed: bool, strength: float) -> void:
	if action_name.is_empty() or not InputMap.has_action(action_name):
		return
	if pressed:
		Input.action_press(action_name, strength)
	else:
		Input.action_release(action_name)
