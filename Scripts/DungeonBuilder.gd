class_name DungeonBuilder extends Node

const DIRECTIONS: Array = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
const MIN_ROOM_SIZE: int = 4
const MAX_ROOM_SIZE: int = 8
const CHANGE_DIRECTION_CHANCE: float = .5
const BRANCH_CHANCE: float = .3

var current_position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.RIGHT
var rooms: Array = []

var max_room_size: int = MAX_ROOM_SIZE
var min_room_size: int = MIN_ROOM_SIZE

var change_direction_chance: float = CHANGE_DIRECTION_CHANCE
var branch_chance: float = BRANCH_CHANCE

func _init(
	starting_position: Vector2,
	new_direction_chance: float = CHANGE_DIRECTION_CHANCE,
	new_branch_chance: float = BRANCH_CHANCE,
	new_max_room_size: int = MAX_ROOM_SIZE,
	new_min_room_size: int = MIN_ROOM_SIZE
) -> void:
	var available_directions = DIRECTIONS.duplicate()
	available_directions.shuffle()
	direction = available_directions.pop_front()
	
	change_direction_chance = new_direction_chance
	branch_chance = new_branch_chance
	
	max_room_size = new_max_room_size
	min_room_size = new_min_room_size
	
	current_position = starting_position
	rooms = [_create_room(current_position)]
	pass

func build(size: int) -> Array:
	if (!_build_main_path(size)):
		return rooms
	_build_branches()
	return rooms
	pass

func _build_main_path(size: int) -> bool:
	var previous_room: DungeonRoom = rooms[0]
	for _i in size:
		if (!_step()):
			return false
		var new_room := _create_room(current_position, DungeonCorridor.new(-direction, previous_room))
		rooms.append(new_room)
		previous_room = new_room
		continue
	return true
	pass

func _build_branches() -> void:
	var current_room: DungeonRoom
	for i in range(1, rooms.size() - 1):
		current_room = rooms[i]
		_add_branch(current_room)
		continue
	pass

func _step() -> bool:
	if (rand_range(0, 1) < change_direction_chance):
		direction = _change_direction()
	var new_position := current_position + direction
	var available_directions := _get_available_directions()
	while _is_position_taken(new_position):
		if (available_directions.size() <= 0):
			return false
		direction = _change_direction(available_directions)
		new_position = current_position + direction
		continue
	current_position = new_position
	return true
	pass

func _is_position_taken(position: Vector2) -> bool:
	return _get_room_at(position) != null
	pass

func _get_room_at(position: Vector2) -> DungeonRoom:
	for room in rooms:
		if (room.position == position):
			return room
		continue
	return null
	pass

func _change_direction(directions: Array = DIRECTIONS.duplicate()) -> Vector2:
	var available_directions := _get_available_directions(directions)
	available_directions.shuffle()
	return available_directions.pop_front()
	pass

func _create_room(room_position: Vector2, previous_room: DungeonCorridor = null) -> DungeonRoom:
	var has_previous_room := previous_room != null
	var size := Vector2(randi() % max_room_size + min_room_size, randi() % max_room_size + min_room_size)
	var new_room := DungeonRoom.new(room_position, size, previous_room)
	if (has_previous_room):
		previous_room.room.exits.append(DungeonCorridor.new(direction, new_room))
	return new_room
	pass

func _add_branch(current_room: DungeonRoom) -> void:
	if (rand_range(0, 1) > branch_chance):
		return
	var position := current_room.position
	var available_directions := current_room.get_available_directions()
	available_directions.shuffle()
	var branch_direction: Vector2 = available_directions.pop_front()
	var branch_position := position + branch_direction
	var room_at_branch := _get_room_at(branch_position)
	var corridor := DungeonCorridor.new(-branch_direction, current_room)
	if (room_at_branch != null):
		room_at_branch.exits.append(corridor)
		return
	var branch := _create_room(branch_position, corridor)
	_add_branch(branch)
	pass

func _get_available_directions(directions: Array = DIRECTIONS.duplicate()) -> Array:
	var available_directions := directions
	available_directions.erase(direction)
	return available_directions
	pass

class DungeonRoom:
	var position: Vector2
	var size: Vector2
	var exits: Array
	var entrance: DungeonCorridor
	
	func _init(
		new_position: Vector2,
		new_size: Vector2,
		new_entrance: DungeonCorridor = null,
		new_exits: Array = []
	) -> void:
		position = new_position
		size = new_size
		entrance = new_entrance
		exits = new_exits
		pass
	
	func get_available_directions() -> Array:
		var available_directions = DIRECTIONS.duplicate()
		var taken_directions = get_taken_directions()
		for direction in taken_directions:
			available_directions.erase(direction)
			continue
		return available_directions
		pass
	
	func get_taken_directions() -> Array:
		var taken_directions = []
		var corridors = exits.duplicate()
		corridors.append(entrance)
		for corridor in corridors:
			taken_directions.append(corridor.direction)
			continue
		return taken_directions
		pass

class DungeonCorridor:
	var direction: Vector2
	var room: DungeonRoom
	
	func _init(new_direction: Vector2, new_room: DungeonRoom) -> void:
		direction = new_direction
		room = new_room
		pass
