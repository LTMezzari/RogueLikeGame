extends Node

var was_built: bool = false
var rooms: Array setget _set_rooms
var current_room: DungeonRoom
var last_direction: Vector2 = Vector2.ZERO

func _set_rooms(new_rooms: Array) -> void:
	rooms = new_rooms
	current_room = rooms[0]
	was_built = true
	last_direction = Vector2.ZERO
	pass

func move_to_room(room_id: int) -> void:
	var corridors := current_room.get_all_corridors()
	var corridor: DungeonRoom.DungeonCorridor = corridors[room_id]
	current_room = corridor.room
	last_direction = corridor.direction
	pass
