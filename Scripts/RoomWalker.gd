class_name RoomWalker extends Node

const DIRECTIONS: Array = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
const MAX_STEPS: int = 6
const MAX_ROOM_SIZE: int = 4

var position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.RIGHT
var borders: Rect2 = Rect2()
var step_since_turn: int= 0
var step_history: Array = []
var rooms: Array = []

var max_steps: int = MAX_STEPS
var max_room_size: int = MAX_ROOM_SIZE

func _init(starting_position: Vector2, new_borders: Rect2):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders
	
func walk(steps) -> Array:
	_place_room(position)
	for step in steps:
		if (step_since_turn >= max_steps):
			_change_directions()
		if (!_step()):
			_change_directions()
		step_history.append(position)
	return step_history

func _step() -> bool:
	var target_position = position + direction
	if (!borders.has_point(target_position)):
		return false
	step_since_turn += 1
	position = target_position
	return true
	
func _change_directions() -> void:
	_place_room(position)
	step_since_turn = 0
	var directions := DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()
		
func _place_room(room_position: Vector2) -> void:
	var size := Vector2(randi() % max_room_size + 2, randi() % max_room_size + 2)
	var top_left_corner := (room_position - size / 2).ceil()
	rooms.append(_create_room(room_position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if not borders.has_point(new_step):
				continue
			step_history.append(new_step)
		
func _create_room(room_position: Vector2, size: Vector2) -> Dictionary:
	return {
		position = room_position,
		size = size
	}
	
func get_end_room() -> Dictionary:
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if (starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position)):
			end_room = room
	return end_room
