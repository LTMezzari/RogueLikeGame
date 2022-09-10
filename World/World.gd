extends Node2D

const ExitScene = preload("res://Components/Exit/Exit.tscn")

export(Rect2) var borders: Rect2 = Rect2(1, 1, 38, 21)
export(int) var steps: int = 200

onready var _tile_map: TileMap = $TileMap
onready var _minimap := $CanvasLayer/Minimap

func _ready() -> void:
	#randomize()
	_generate_level()
	pass

func _generate_level() -> void:
	var dimensions := borders.size
	var walker := RoomWalker.new(Vector2(ceil(dimensions.x / 2), ceil(dimensions.y / 2)), borders)
	var map := walker.walk(steps)
	
	var player := $YSort/Player
	player.position = map.front() * 32
	
	var exit := ExitScene.instance()
	$YSort.add_child(exit)
	$CanvasLayer/ExitTracker.target = exit
	exit.position = walker.get_end_room().position * 32
	var _a = exit.connect("on_exit_reached", self, "_reset_world")
	
	walker.queue_free()
	_minimap.markers = [
		Minimap.Marker.new(player, Color.green),
		Minimap.Marker.new(exit, Color.red),
	]
	for location in map:
		_tile_map.set_cellv(location, -1)
		continue
	_tile_map.update_bitmask_region(borders.position, borders.end)
	var clone := _tile_map.duplicate()
	_minimap.map = clone
	pass
	
func _reset_world() -> void:
	var _a = get_tree().reload_current_scene()
	pass
