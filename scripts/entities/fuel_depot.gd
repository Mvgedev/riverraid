extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		print("Destroyed")
		queue_free()
	elif body is Player:
		print("Should get fuel")

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		print("Should stop fueling")
