extends Node
class_name RoomWalker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
const MAX_STEPS = 6
const MAX_ROOM_SIZE = 4

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_since_turn = 0
var step_history = []
var rooms = []

var max_steps = MAX_STEPS
var max_room_size = MAX_ROOM_SIZE

func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders
	
func walk(steps):
	_place_room(position)
	for step in steps:
		if (step_since_turn >= max_steps):
			_change_directions()
		if (!_step()):
			_change_directions()
		step_history.append(position)
	return step_history

func _step():
	var target_position = position + direction
	if (!borders.has_point(target_position)):
		return false
	step_since_turn += 1
	position = target_position
	return true
	
func _change_directions():
	_place_room(position)
	step_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()
		
func _place_room(room_position):
	var size = Vector2(randi() % max_room_size + 2, randi() % max_room_size + 2)
	var top_left_corner = (room_position - size / 2).ceil()
	rooms.append(_create_room(room_position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if not borders.has_point(new_step):
				continue
			step_history.append(new_step)
		
func _create_room(room_position, size):
	return {
		position = room_position,
		size = size
	}
	
func get_end_room():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if (starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position)):
			end_room = room
	return end_room
