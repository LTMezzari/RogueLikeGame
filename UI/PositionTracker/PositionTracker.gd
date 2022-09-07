tool
class_name PositionTracker extends Label

export(NodePath) var target_path: NodePath

onready var target: Node2D = get_node_or_null(target_path) setget _set_target

func _ready() -> void:
	_update_process_status(target != null)
	pass

func _physics_process(_delta: float) -> void:
	if (target == null):
		self.text = ""
		return
	_update_text(target.position)
	pass

func _set_target(new_target: Node2D) -> void:
	target = new_target
	_update_process_status(target != null)
	pass

func _update_process_status(is_enabled: bool) -> void:
	var isDebug = OS.is_debug_build()
	var should_enable = is_enabled && isDebug
	visible = isDebug
	#set_process(should_enable)
	set_physics_process(should_enable)
	pass

func _update_text(position: Vector2) -> void:
	self.text = "(" + str(position.x) +", " + str(position.y) + ")"
	pass
