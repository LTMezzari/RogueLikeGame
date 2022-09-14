class_name Dungeon extends Node2D

const PlayerScene: PackedScene = preload("res://Entities/Player/Player.tscn")
const ExitScene: PackedScene = preload("res://Components/Exit/Exit.tscn")

export(int) var dungeon_main_size: int = 6
export(int) var branch_chance: float = .4
export(int) var change_direction_chance: float = .4
export(int) var max_room_size: int = 4
export(int) var min_room_size: int = 6
export(Rect2) var borders: Rect2 = Rect2(1, 1, 38, 21)

onready var _minimap: Minimap = $CanvasLayer/Minimap
onready var _tile_map: TileMap = $TileMap
onready var _minimap_tiles: TileMap = _tile_map.duplicate()

var markers: Array = []

func _ready() -> void:
	#randomize()
	var dimensions := borders.size
	var start_position := Vector2(ceil(dimensions.x / 2), ceil(dimensions.y / 2))
	if  (not DungeonController.was_built):
		_generate_dungeon(start_position)
	_draw_dungeon(start_position)
	_draw_minimap()
	pass

func _input(_event: InputEvent) -> void:
	#if (Input.is_action_just_pressed("ui_accept")):
	#	_reset_world()
	pass

func _generate_dungeon(start_position: Vector2) -> void:
	var builder := DungeonBuilder.new(
		start_position,
		change_direction_chance,
		branch_chance,
		max_room_size,
		min_room_size
	)
	DungeonController.rooms = builder.build(dungeon_main_size)
	builder.queue_free()
	pass

func _draw_dungeon(start_position: Vector2) -> void:
	_paint_room(DungeonController.current_room)
	_tile_map.update_bitmask_region(borders.position, borders.end)
	_place_player(start_position)
	pass

func _draw_minimap() -> void:
	var clone = _tile_map.duplicate()
	clone.update_bitmask_region(borders.position, borders.end)
	_minimap.markers = markers
	_minimap.map = clone
	pass

func _paint_room(room: DungeonRoom) -> void:
	var size := room.size
	var room_position := room.position
	var top_left_corner := (room_position - (size / 2)).ceil()
	for y in size.y:
		for x in size.x:
			var cell_position := top_left_corner + Vector2(x, y)
			_tile_map.set_cellv(cell_position, -1)
			continue
		continue
	
	var corridors := room.get_all_corridors()
	for i in corridors.size():
		var corridor = corridors[i]
		var exit_position: Vector2 = room_position + ((size / 2) * corridor.direction)
		_place_exit(exit_position, i)
		continue
	pass

func _place_player(start_position: Vector2) -> void:
	var player = PlayerScene.instance()
	$SmartCamera.target = player
	$CanvasLayer/PositionTracker.target = player
	markers.append(Minimap.Marker.new(player, Color.green))
	add_child(player)
	
	if (DungeonController.last_direction == Vector2.ZERO):
		player.position = start_position * 32
		return
	
	#todo:Solve issue where player spawns on exit
	player.position = (start_position + (((DungeonController.current_room.size) / 4) * -DungeonController.last_direction)) * 32
	pass

func _place_exit(exit_position: Vector2, room_id: int) -> void:
	var exit := ExitScene.instance()
	exit.id = room_id
	add_child(exit)
	exit.position = exit_position * 32
	var _a = exit.connect("on_exit_reached", self, "_on_room_exited")
	markers.append(Minimap.Marker.new(exit, Color.red))
	pass

func _on_room_exited(room_id: int) -> void:
	DungeonController.move_to_room(room_id)
	_reset_world()
	pass

func _reset_world() -> void:
	var _a = get_tree().reload_current_scene()
	pass
