extends Enemy

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow: Sprite2D = $Shadow

@onready var rc_left: RayCast2D = $RCLeft
@onready var rc_right: RayCast2D = $RCRight

var direction = 1
var helicopter_speed = 75

func _process(delta: float) -> void:
	if rc_left.is_colliding():
		direction = 1
		sprite_2d.flip_h = true
		shadow.flip_h = true
	elif rc_right.is_colliding():
		direction = -1
		sprite_2d.flip_h = false
		shadow.flip_h = false
	position.x += direction * helicopter_speed * delta
