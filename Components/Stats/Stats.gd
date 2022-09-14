tool
class_name Stats extends Node

signal on_health_reached_zero
signal on_health_updated
signal on_max_health_updated

export(int) var max_health: int = 1 setget _set_max_health

export(int) var health: int = max_health setget _set_health

func _ready() -> void:
	health = max_health
	pass

func _set_max_health(value: int) -> void:
	var new_value := int(max(0, value))
	emit_signal("on_max_health_updated", max_health, new_value)
	max_health = new_value
	if (health != null):
		self.health = int(min(health, max_health))
	pass

func _set_health(value: int) -> void:
	var new_value := int(max(0, min(max_health, value)))
	emit_signal("on_health_updated", health, new_value)
	health = new_value
	if (health <= 0):
		emit_signal("on_health_reached_zero")
	pass
