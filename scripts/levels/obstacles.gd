extends Area2D
class_name Obstacles

func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		body.queue_free()
		print("Bullet destroyed by obstacle")
	if body is Player:
		if body.intangible == false:
			body.hurt(4)
	
