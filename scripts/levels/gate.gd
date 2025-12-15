extends Area2D
class_name Gate

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var explosions: Node2D = $Explosions

@export var score_value = 500

signal next_level()

var crashed = false

func _ready() -> void:
	for child in explosions.get_children():
		child.animation_finished.connect(_on_explosion_finished.bind(child))

func _on_body_entered(body: Node2D) -> void:
	if body is Bullet and crashed == false:
		ScoreSystem.gain_score(score_value)
		explode()
		sprite_2d.play("crashed")
		crashed = true
		body.queue_free()
	elif body is Player and crashed == false:
		body.hurt(4)
		sprite_2d.play("crashed")
		crashed = true

func explode():
	emit_signal("next_level")
	for child in explosions.get_children():
		child.visible = true
		child.play("default")
		await get_tree().create_timer(0.03).timeout

func _on_explosion_finished(sprite):
	sprite.visible = false
