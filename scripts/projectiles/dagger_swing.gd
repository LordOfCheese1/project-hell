extends "res://scripts/classes/projectile_class.gd"

var goal_rot = 0.0
var passed_time = 0
var instanced_by = null


func _physics_process(_delta):
	rotation_degrees = lerp(rotation_degrees, goal_rot, 0.3)
	passed_time += 1
	if passed_time > 16:
		call_deferred("free")
	
	if instanced_by != null:
		position = instanced_by.position
