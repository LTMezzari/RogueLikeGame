extends Node2D

export(Rect2) var borders: Rect2 = Rect2(1, 1, 38, 21)
export(int) var steps: int = 200

onready var _tile_map: TileMap = $TileMap
onready var _minimap := $CanvasLayer/Minimap

func _ready() -> void:
	#randomize()
	_generate_level()

func _generate_level() -> void:
	var dimensions = borders.size
	var walker = RoomWalker.new(Vector2(ceil(dimensions.x / 2), ceil(dimensions.y / 2)), borders)
	var map = walker.walk(steps)
	
	var player = $Player
	player.position = map.front() * 32
	
	var exit = $Exit
	#add_child_below_node(player, exit)
	#$CanvasLayer/ExitTracker.target = exit
	exit.position = walker.get_end_room().position * 32
	exit.connect("on_exit_reached", self, "_reset_world")
	
	walker.queue_free()
	_minimap.map = map
	_minimap.markers = [
		Minimap.Marker.new(player),
		Minimap.Marker.new(exit),
	]
	for location in map:
		_tile_map.set_cellv(location, -1)
	_tile_map.update_bitmask_region(borders.position, borders.end)
	
func _reset_world() -> void:
	var _a = get_tree().reload_current_scene()
