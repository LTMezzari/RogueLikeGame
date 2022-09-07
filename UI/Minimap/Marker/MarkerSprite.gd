tool
class_name MarkerSprite extends Node2D

export(Color) var color: Color = Color.green

onready var _color_rect: ColorRect = $ColorRect

func _ready():
	_color_rect.color = color
	pass
