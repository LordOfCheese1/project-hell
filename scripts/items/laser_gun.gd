extends "res://scripts/classes/item_class.gd"

var laser_path = load("res://prefabs/projectiles/cerberus_laser.tscn")


func _ready():
	setup_item(Vector2(-6, 0))


func _physics_process(delta):
	item_update()


func _on_used():
	var laser_inst = laser_path.instantiate()
	laser_inst.position = global_position
	laser_inst.rotation_degrees = rotation_degrees
	laser_inst.get_child(0).ignore_in_detection.append(grabbed_entity)
	get_tree().current_scene.add_child(laser_inst)
