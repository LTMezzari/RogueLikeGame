tool
class_name Hitbox extends Area2D

export(float) var damage: float = 1
export(Shape2D) var shape: Shape2D
export(bool) var disabled: bool = false setget set_disabled

onready var _collision_shape = $Shape

func _ready() -> void:
	_collision_shape.shape = shape
	_collision_shape.disabled = disabled
	pass

func set_disabled(value: bool) -> void:
	disabled = value
	if (_collision_shape != null):
		_collision_shape.disabled = value
	pass
