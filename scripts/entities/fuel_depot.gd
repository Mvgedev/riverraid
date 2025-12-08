extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		ScoreSystem.gain_score(20)
		queue_free()
	elif body is Player:
		body.on_depot = true
		print("Should get fuel")

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.on_depot = false
		print("Should stop fueling")
