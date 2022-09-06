class_name PositionTracker extends Label

export(NodePath) var target_path: NodePath

onready var target: Node2D = get_node_or_null(target_path)

func _ready() -> void:
	if (target == null):
		queue_free()
	pass

func _physics_process(delta: float) -> void:
	if (target == null):
		return
	self.text = "(" + str(target.position.x) +", " + str(target.position.y) + ")"
	pass
