tool
class_name PlayerDetectionZone extends Area2D

signal on_player_found
signal on_player_lost

export(Shape2D) var shape: Shape2D setget _set_shape

onready var _collision_shape = $Shape

var player: Node2D = null

func _ready() -> void:
	_update_collision_shape()
	pass

func _set_shape(value: Shape2D) -> void:
	shape = value
	_update_collision_shape()
	pass

func is_seeing_player() -> bool:
	return player != null
	pass

func _update_collision_shape() -> void:
	if (_collision_shape != null):
		_collision_shape.shape = shape
	pass

func _on_body_entered(body: Player) -> void:
	player = body
	emit_signal("on_player_found", player)
	pass

func _on_body_exited(body: Player) -> void:
	player = null
	emit_signal("on_player_lost")
	pass
