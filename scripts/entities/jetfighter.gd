extends Enemy
class_name JetFighter

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var direction = 1
@export var speed = 200

var launched = false

func _ready():
	sprite_2d.flip_h = true if direction == 1 else false
	visible = false

func launch_jet(val):
	launched = val
	print("Launch jet: ", str(val))
	if launched:
		visible = true

func _process(delta: float) -> void:
	if launched:
		position.x += direction * speed * delta
