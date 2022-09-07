tool
class_name SmartCamera extends Camera2D

export(NodePath) var target: NodePath setget _set_target_path

onready var _remote_transform = RemoteTransform2D.new()
onready var _limit_top_left: Position2D = $Limits/TopLeft
onready var _limit_bottom_right: Position2D = $Limits/BottomRight

var _target_node: Node2D setget _set_target

func _ready() -> void:
	_remote_transform.remote_path = get_path()
	
	#warning-ignore:narrowing_conversion
	limit_top = _limit_top_left.position.y
	#warning-ignore:narrowing_conversion
	limit_left = _limit_top_left.position.x
	#warning-ignore:narrowing_conversion
	limit_bottom = _limit_bottom_right.position.y
	#warning-ignore:narrowing_conversion
	limit_right = _limit_bottom_right.position.x
	
	self._target_node = get_node_or_null(target)
	pass

func _set_target_path(new_target_path: NodePath) -> void:
	self._target_node = get_node_or_null(new_target_path)
	target = new_target_path
	pass

func _set_target(new_target: Node2D) -> void:
	_update_target(_target_node, new_target)
	_target_node = new_target
	pass

func _update_target(old_target: Node2D, new_target: Node2D) -> void:
	if (old_target != null):
		old_target.remove_child(_remote_transform)
	
	if (new_target != null):
		new_target.add_child(_remote_transform)
	pass
