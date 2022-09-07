tool
class_name Panoramic extends Camera2D

onready var _default_system_size: Vector2 = get_viewport_rect().size
onready var _top_left_bound: Position2D = $Bounds/TopLeft
onready var _bottom_right_bound: Position2D = $Bounds/BottomRight

func _ready() -> void:
	var new_scale := Vector2.ONE
	var bounds_size := Vector2(_bottom_right_bound.position.x - _top_left_bound.position.x, _bottom_right_bound.position.y - _top_left_bound.position.y)
	new_scale.x = floor(bounds_size.x) / _default_system_size.x
	new_scale.y = floor(bounds_size.y) / _default_system_size.y
	
	zoom = new_scale
	print(new_scale)
	print(bounds_size)
	print(_default_system_size)
	pass
