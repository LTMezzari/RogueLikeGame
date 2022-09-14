tool
class_name Hurtbox extends Area2D

#warning-ignore:unused_signal
signal invincibility_started
#warning-ignore:unused_signal
signal invincibility_ended

export(Shape2D) var shape: Shape2D setget set_shape
export(float) var invincibility_time: float = 0
export(bool) var disabled: bool setget set_disabled

onready var _collision_shape: CollisionShape2D = $Shape
onready var _timer: Timer = $Timer

var is_invincible: bool = false

func _ready() -> void:
	_collision_shape.shape = shape
	_collision_shape.disabled = disabled
	pass

func set_shape(new_shape: Shape2D) -> void:
	shape = new_shape
	if (_collision_shape != null):
		_collision_shape.shape = shape
	pass

func set_invincible(value: bool) -> void:
	is_invincible = value
	self.disabled = value
	#set_deferred("monitoring", !is_invincible)
	#set_deferred("monitorable", !is_invincible)
	emit_signal("invincibility_started" if is_invincible else "invincibility_ended")
	pass

func set_disabled(value: bool) -> void:
	disabled = value
	if (_collision_shape != null):
		_collision_shape.set_deferred("disabled", value)
	pass

func start_invincibility() -> void:
	_timer.start(invincibility_time)
	self.is_invincible = true
	pass

func turn_invincible(duration: float) -> void:
	_timer.start(duration)
	self.is_invincible = true
	pass

func _on_timer_timeout() -> void:
	self.is_invincible = false
	pass
