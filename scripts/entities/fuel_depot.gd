extends Area2D

@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var explode_sfx: AudioStreamPlayer2D = $ExplodeSFX

var exploding = false

func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		exploding = true
		sprite_2d.visible = false
		sprite_2d_2.visible = false
		collision_shape_2d.set_deferred("disabled", false)
		explosion.visible = true
		explosion.play("default")
		explode_sfx.play()
		ScoreSystem.gain_score(ScoreSystem.SCORE_VAL.FUEL)
		body.queue_free()
	elif body is Player:
		if body.intangible == false and exploding == false:
			body.on_depot = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.on_depot = false


func _on_explosion_animation_finished() -> void:
	explosion.visible = false


func _on_explode_sfx_finished() -> void:
	queue_free()
