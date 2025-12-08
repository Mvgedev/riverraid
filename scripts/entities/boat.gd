extends Enemy

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var rc_left: RayCast2D = $RCLeft
@onready var rc_right: RayCast2D = $RCRight

@export var boat_speed = 30
var direction = 1

func _process(delta: float) -> void:
	if rc_left.is_colliding():
		direction = 1
		sprite_2d.flip_h = true
	elif rc_right.is_colliding():
		direction = -1
		sprite_2d.flip_h = false
	position.x += direction * boat_speed * delta
