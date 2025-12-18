extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $Killzone
@onready var collision_shape_2d: CollisionShape2D = $Killzone/CollisionShape2D
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var explode_sfx: AudioStreamPlayer2D = $ExplodeSFX

@onready var rc_left: RayCast2D = $RCLeft
@onready var rc_right: RayCast2D = $RCRight

@export var boat_speed = 30
var direction = 1
var crashed = false

func _process(delta: float) -> void:
	if crashed == false:
		if rc_left.is_colliding():
			direction = 1
			animated_sprite_2d.flip_h = true
		elif rc_right.is_colliding():
			direction = -1
			animated_sprite_2d.flip_h = false
		position.x += direction * boat_speed * delta

func explode():
	animated_sprite_2d.animation = "crashed"
	explosion.visible = true
	explosion.play("default")
	explode_sfx.play()
	crashed = true
	collision_shape_2d.set_deferred("disabled", true)
	pass


func _on_explosion_animation_finished() -> void:
	explosion.visible = false
