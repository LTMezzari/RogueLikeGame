tool
class_name WanderController extends Node2D

signal on_target_changed

export(float) var wander_range: float = 32 setget _set_wander_range
export(float) var wander_time: float = 2 setget _set_wander_time

onready var _timer: Timer = $Timer
onready var _range_representation: CollisionShape2D = $Representation
onready var _target: Position2D = $Target

onready var _start_position: Vector2 = global_position
onready var target_position: Vector2 = global_position setget _set_target_position

onready var _is_debug: bool = OS.is_debug_build()

func _ready() -> void:
	_update_range_representation()
	_update_target_position()
	_reset_timer()
	pass

func _set_wander_range(value: float) -> void:
	var new_value := max(0, value)
	wander_range = new_value
	_update_range_representation()
	pass

func _set_wander_time(value: float) -> void:
	var new_value := max(0, value)
	wander_time = new_value
	_reset_timer()
	pass

func _set_target_position(value: Vector2) -> void:
	emit_signal("on_target_changed", target_position, value)
	target_position = value
	_update_target_representation()
	pass

func get_time_left() -> float:
	return _timer.time_left if (_timer != null) else .0
	pass

func _get_random_target() -> Vector2:
	return _start_position + _get_random_vector()
	pass

func _get_random_vector() -> Vector2:
	return Vector2(_get_random_float(), _get_random_float())
	pass

func _get_random_float() -> float:
	return rand_range(-wander_range, wander_range)
	pass

func _update_range_representation() -> void:
	if (!_is_debug && _range_representation != null):
		_range_representation.queue_free()
		return

	if (_range_representation != null):
		var circle = _range_representation.shape as CircleShape2D
		circle.radius = wander_range
	pass

func _update_target_representation() -> void:
	if (!_is_debug && _target != null):
		_target.queue_free()
		return
	
	if (_target != null):
		_target.global_position = target_position
	pass

func _reset_timer() -> void:
	if (_timer == null || Engine.is_editor_hint()):
		return
	
	_timer.stop()
	_timer.start(wander_time)
	pass

func _update_target_position() -> void:
	self.target_position = _get_random_target()
	pass
