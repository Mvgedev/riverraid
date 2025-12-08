extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		ScoreSystem.gain_score(get_parent().score_value)
		get_parent().queue_free()
		body.queue_free()
	elif body is Player:
		body.hurt()
		get_parent().queue_free()
	else:
		print("What is even happening!")
