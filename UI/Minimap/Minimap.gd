tool
class_name Minimap extends Control

onready var _texture_rect: TextureRect = $ViewportTexture
onready var _view_port: Viewport = $ViewportContainer/MinimapViewport
onready var _tile_map: TileMap = $ViewportContainer/MinimapViewport/TileMap
onready var _markers_parent := $ViewportContainer/MinimapViewport/Markers

var map: Array = [] setget _set_map
var markers: Array = [] setget _set_markers

const MarkerSprite = preload("res://UI/Minimap/Marker/MarkerSprite.tscn")

class Marker:
	var node: Node2D
	var color: Color
	
	func _init(target_node: Node2D, target_color: Color = Color.white):
		node = target_node
		color = target_color

func _set_map(new_map: Array) -> void:
	map = new_map
	_update_map()
	pass

func _set_markers(new_markers: Array) -> void:
	markers = new_markers
	_update_markers()
	pass

func _update_map() -> void:
	for location in map:
		_tile_map.set_cellv(location, -1)
	_tile_map.update()
	pass

func _update_markers() -> void:
	_remove_markers()
	for marker in markers:
		var sprite := MarkerSprite.instance()
		sprite.color = marker.color
		_markers_parent.add_child(sprite)
		
		var tracker := RemoteTransform2D.new()
		marker.node.add_child(tracker)
		tracker.remote_path = sprite.get_path()
	pass

func _remove_markers() -> void:
	for i in range(0, _markers_parent.get_child_count()):
		_markers_parent.get_child(i).queue_free()
	pass
