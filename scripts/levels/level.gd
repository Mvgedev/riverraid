extends Node2D

class_name Level

@onready var borders: Node = $Borders

func _ready() -> void:
	define_y(position.y)
	pass # Replace with function body.


func define_y(pos):
	if borders != null:
		for child in borders.get_children():
			child.position.y = pos

func scroll_level(distance):
	for child in borders.get_children():
		child.position.y += distance
