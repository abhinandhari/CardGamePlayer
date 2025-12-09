class_name GameUtils extends Node

var CENTER_OF_SCREEN : Vector2 = Vector2.ZERO

func _ready():
	CENTER_OF_SCREEN = get_viewport().get_visible_rect().size / 2
