extends Area2D
class_name Obstacles

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Player should die")
