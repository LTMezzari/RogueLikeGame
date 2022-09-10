tool
class_name Minimap extends Control

export(PackedScene) var map_scene: PackedScene
export(bool) var use_camera: bool = false
export(Vector2) var camera_zoom: Vector2 = Vector2.ONE
export(Vector2) var camera_position: Vector2 = Vector2.ZERO

onready var _texture_rect: TextureRect = $ViewportTexture
onready var _view_port: Viewport = $ViewportContainer/MinimapViewport
onready var _camera: Camera2D = $ViewportContainer/MinimapViewport/MinimapCamera
onready var _markers_parent := $ViewportContainer/MinimapViewport/Markers

var map: Node setget _set_map
var markers: Array = [] setget _set_markers

const MarkerSprite = preload("res://UI/Minimap/Marker/MarkerSprite.tscn")

func _ready() -> void:
	if (use_camera):
		_camera.make_current()
		_camera.zoom = camera_zoom
		_camera.position = camera_position
	else:
		_camera.clear_current()
	pass

func _set_map_scene(new_map_scene: PackedScene) -> void:
	map_scene = new_map_scene
	self.map = map_scene.instance()
	pass

func _set_map(new_map: Node) -> void:
	map = new_map
	_place_map()
	pass

func _place_map() -> void:
	map.position = Vector2.ZERO
	_view_port.add_child_below_node(_camera, map)
	pass

func _set_markers(new_markers: Array) -> void:
	markers = new_markers
	_update_markers()
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
		continue
	pass

func _remove_markers() -> void:
	for i in range(0, _markers_parent.get_child_count()):
		_markers_parent.get_child(i).queue_free()
		continue
	pass

class Marker:
	var node: Node2D
	var color: Color
	var texture: Texture
	
	func _init(target_node: Node2D, target_color: Color = Color.white, new_texture: Texture = null) -> void:
		node = target_node
		color = target_color
		texture = new_texture
		pass
