extends Enemy

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow: Sprite2D = $Shadow
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var collision_shape_2d: CollisionShape2D = $Killzone/CollisionShape2D
@onready var explode_sfx: AudioStreamPlayer2D = $ExplodeSFX

@onready var rc_left: RayCast2D = $RCLeft
@onready var rc_right: RayCast2D = $RCRight

var direction = 1
var helicopter_speed = 75
var crash = false

func _process(delta: float) -> void:
	if rc_left.is_colliding():
		direction = 1
		sprite_2d.flip_h = true
		shadow.flip_h = true
	elif rc_right.is_colliding():
		direction = -1
		sprite_2d.flip_h = false
		shadow.flip_h = false
	if crash == false:
		position.x += direction * helicopter_speed * delta

func explode():
	crash = true
	explosion.visible = true
	explosion.play("default")
	explode_sfx.play()
	sprite_2d.visible = false
	shadow.visible = false
	collision_shape_2d.set_deferred("disabled", true)

func _on_explosion_animation_finished() -> void:
	explosion.visible = false


func _on_explode_sfx_finished() -> void:
	queue_free()
