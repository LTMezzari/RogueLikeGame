class_name Dungeon extends Node2D

const PlayerScene: PackedScene = preload("res://Player/Player.tscn")
const ExitScene: PackedScene = preload("res://Components/Exit/Exit.tscn")

export(int) var dungeon_main_size: int = 6
export(int) var branch_chance: float = .4
export(int) var change_direction_chance: float = .4
export(int) var max_room_size: int = 4
export(int) var min_room_size: int = 6
export(Rect2) var borders: Rect2 = Rect2(1, 1, 38, 21)

onready var _tile_map: TileMap = $TileMap

func _ready() -> void:
	#randomize()
	_generate_dungeon()
	pass

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_accept")):
		_reset_world()
	pass

func _generate_dungeon() -> void:
	var dimensions := borders.size
	var start_position := Vector2(ceil(dimensions.x / 2), ceil(dimensions.y / 2))
	var builder := DungeonBuilder.new(
		start_position,
		change_direction_chance,
		branch_chance,
		max_room_size,
		min_room_size
	)
	var rooms := builder.build(dungeon_main_size)
	_paint_room(rooms[DungeonController.current_room])
	_tile_map.update_bitmask_region(borders.position, borders.end)
	builder.queue_free()
	
	_place_player(start_position)
	pass

func _paint_rooms_path(rooms: Array) -> void:
	for room in rooms:
		_tile_map.set_cellv(room.position, -1)
		for corridor in room.exits:
			var branch = corridor.room
			_tile_map.set_cellv(branch.position, -1)
			continue
		continue
	pass

func _paint_rooms(rooms: Array) -> void:
	for room in rooms:
		_paint_room(room)
		for corridor in room.exits:
			var branch = corridor.room
			_paint_room(branch)
			continue
		continue
	pass

func _paint_room(room: DungeonBuilder.DungeonRoom) -> void:
	var size := room.size
	var room_position := room.position
	var top_left_corner := (room_position - (size / 2)).ceil()
	for y in size.y:
		for x in size.x:
			var cell_position := top_left_corner + Vector2(x, y)
			_tile_map.set_cellv(cell_position, -1)
			continue
		continue
	
	for i in room.exits.size():
		var corridor = room.exits[i]
		var exit_position: Vector2 = room_position + ((size / 2) * corridor.direction)
		_place_exit(exit_position, i + 1)
		continue
	pass

func _place_player(start_position: Vector2) -> void:
	var player = PlayerScene.instance()
	add_child(player)
	player.position = start_position * 32
	$SmartCamera.target = player
	$CanvasLayer/PositionTracker.target = player
	pass

func _place_exit(exit_position: Vector2, room_id: int) -> void:
	var exit := ExitScene.instance()
	exit.id = room_id
	add_child(exit)
	exit.position = exit_position * 32
	var _a = exit.connect("on_exit_reached", self, "_on_room_exited")
	pass

func _on_room_exited(room_id: int) -> void:
	DungeonController.current_room = room_id
	var _a = get_tree().reload_current_scene()
	pass

func _reset_world() -> void:
	#var _a = get_tree().reload_current_scene()
	pass
