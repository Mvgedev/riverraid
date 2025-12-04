extends Node2D
class_name Enemy


func _ready() -> void:
	pass

func enable(val):
	if val == true:
		pass
	else:
		queue_free()
