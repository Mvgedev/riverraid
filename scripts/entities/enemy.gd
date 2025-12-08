extends Node2D
class_name Enemy

@export var score_value = 10

func _ready() -> void:
	pass

func enable(val):
	if val == true:
		pass
	else:
		queue_free()
