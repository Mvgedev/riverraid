extends CharacterBody2D

@export var SPEED = 400

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0, -SPEED)
	move_and_slide()


func _on_lifetime_timeout() -> void:
	print("Bullet expired")
	queue_free()
