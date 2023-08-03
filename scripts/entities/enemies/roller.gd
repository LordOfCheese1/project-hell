extends "res://scripts/classes/entity_class.gd"

var max_speed = 80


func _ready():
	setup_entity(12.0, 0, 1)


func _physics_process(delta):
	move_and_slide()
