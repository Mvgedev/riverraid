extends Enemy
class_name JetFighter

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow: Sprite2D = $Shadow
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var collision_shape_2d: CollisionShape2D = $Killzone/CollisionShape2D

@export var direction = 1
@export var speed = 150

var launched = false
var crash = false

func _ready():
	animated_sprite_2d.flip_h = true if direction == 1 else false
	shadow.flip_h = animated_sprite_2d.flip_h
	visible = false

func launch_jet(val):
	launched = val
	print("Launch jet: ", str(val))
	if launched:
		visible = true

func _process(delta: float) -> void:
	if launched and crash == false:
		position.x += direction * speed * delta

func explode():
	crash = true
	explosion.visible = true
	explosion.play("default")
	collision_shape_2d.set_deferred("disabled", true)


func _on_explosion_animation_finished() -> void:
	pass # Replace with function body.
