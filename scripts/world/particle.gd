extends Sprite2D

@export var scale_amount : float
@export var alpha_amount : float
@export var rot_amount : float
@export var scale_limit : float
@export var gravity = 0.0
@export var starting_velocity = 0 # directional multiplier
var velocity = Vector2()


func _ready():
	velocity = transform.x * starting_velocity
	modulate.a = 1
	scale.x = 1


func _physics_process(delta):
	scale.x += scale_amount
	scale.y = scale.x
	rotation_degrees += rot_amount
	modulate.a += alpha_amount
	if scale.x < scale_limit:
		call_deferred("free")
	if modulate.a < 0:
		call_deferred("free")
	
	position += velocity * delta
	velocity.y += gravity * delta
