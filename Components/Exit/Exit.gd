class_name Exit extends Area2D

signal on_exit_reached

func _on_exit_body_entered(_body: Player) -> void:
	emit_signal("on_exit_reached")
	pass
