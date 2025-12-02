extends CharacterBody2D


const LATERAL_SPEED = 300.0

const accel_modifier = 3
var acceleration = 90
var min_accel = 60
var max_accel = 200

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_pressed("Accelerate"):
		acceleration = min(acceleration + accel_modifier, max_accel)
	elif Input.is_action_pressed("Decelerate"):
		acceleration = max(acceleration - accel_modifier, min_accel)
	
	var direction := Input.get_axis("Move Left", "Move Right")
	if direction:
		velocity.x = direction * LATERAL_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, LATERAL_SPEED)

	move_and_slide()
