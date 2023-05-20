extends Sprite2D

@export var scale_amount : float
@export var alpha_amount : float
@export var rot_amount : float
@export var scale_limit : float


func _ready():
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
