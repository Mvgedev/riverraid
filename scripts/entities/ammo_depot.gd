extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		ScoreSystem.gain_score(100)
		queue_free()
	if body is Player:
		body.ammo_refill()
		queue_free()
