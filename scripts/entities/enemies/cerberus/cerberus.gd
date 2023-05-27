extends "res://scripts/classes/entity_class.gd"


func _ready():
	setup_entity(22, 0)


func _physics_process(delta):
	move_and_slide()
	velocity = (gv.player.position - position)
	$body.rotation_degrees = velocity.x / 5
