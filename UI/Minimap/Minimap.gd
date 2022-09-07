tool
class_name Minimap extends ViewportContainer

onready var _texture_rect: TextureRect = $ViewportTexture
onready var _view_port: Viewport = $MinimapViewport
onready var _tile_map: TileMap = $MinimapViewport/TileMap
onready var _markers_parent: Node = $MinimapViewport/Markers

var map: Array = [] setget _set_map
var markers: Array = [] setget _set_markers

class Marker:
	var node: Node2D
	var texture: Texture
	
	func _init(target_node: Node2D, texture: Texture = null):
		node = target_node
		texture = texture

func _ready() -> void:
	_texture_rect.set_texture(_view_port.get_texture())
	pass

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
		var gradient_texture = GradientTexture.new()
		var gradient = Gradient.new()
		gradient.colors = [Color.aqua]
		gradient_texture.gradient = gradient
		
		var sprite := Sprite.new()
		sprite.texture = gradient_texture
		sprite.region_rect = Rect2(Vector2.ZERO, Vector2.ONE * 32)
		_markers_parent.add_child(sprite)
		
		var tracker := RemoteTransform2D.new()
		marker.node.add_child(tracker)
		tracker.remote_path = sprite.get_path()
	pass

func _remove_markers() -> void:
	for i in range(0, _markers_parent.get_child_count()):
		_markers_parent.get_child(i).queue_free()
	pass
