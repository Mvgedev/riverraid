extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		print("Ouch")
		get_parent().queue_free()
		body.queue_free()
	elif body is Player:
		print("Player hurt!")
	else:
		print("What is even happening!")
