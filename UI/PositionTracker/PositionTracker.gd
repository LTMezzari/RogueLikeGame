tool
class_name PositionTracker extends Label

export(NodePath) var target_path: NodePath

onready var target: Node2D = get_node_or_null(target_path) setget _set_target

func _ready() -> void:
	_update_process_status(target != null)
	pass

func _physics_process(_delta: float) -> void:
	if (target == null):
		return
	self.text = "(" + str(target.position.x) +", " + str(target.position.y) + ")"
	pass

func _set_target(new_target: Node2D) -> void:
	target = new_target
	_update_process_status(target != null)
	pass

func _update_process_status(is_enabled: bool) -> void:
	#set_process(is_enabled)
	set_physics_process(is_enabled)
	pass
