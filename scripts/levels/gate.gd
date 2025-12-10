extends Area2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var score_value = 100

var crashed = false


func _on_body_entered(body: Node2D) -> void:
	if body is Bullet and crashed == false:
		ScoreSystem.gain_score(score_value)
		sprite_2d.play("crashed")
		crashed = true
	elif body is Player and crashed == false:
		body.hurt(4)
		sprite_2d.play("crashed")
		crashed = true
