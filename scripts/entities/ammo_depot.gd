extends Area2D

@onready var explosion: AnimatedSprite2D = $Explosion
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		collision_shape_2d.set_deferred("disabled", true)
		explosion.visible = true
		sprite_2d_2.visible = false
		animated_sprite_2d.visible = false
		explosion.play("default")
		ScoreSystem.gain_score(100)
		body.queue_free()
	if body is Player:
		body.ammo_refill()
		queue_free()

func _on_explosion_animation_finished() -> void:
	queue_free()
