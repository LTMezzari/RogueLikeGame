class_name DungeonRoom

const DIRECTIONS: Array = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

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
	var corridors = get_all_corridors()
	for corridor in corridors:
		taken_directions.append(corridor.direction)
		continue
	return taken_directions
	pass

func get_all_corridors() -> Array:
	var corridors = exits.duplicate()
	if (entrance != null):
		corridors.append(entrance)
	return corridors
	pass

class DungeonCorridor:
	var direction: Vector2
	var room: DungeonRoom
	
	func _init(new_direction: Vector2, new_room: DungeonRoom) -> void:
		direction = new_direction
		room = new_room
		pass
