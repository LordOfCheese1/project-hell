extends "res://scripts/classes/item_class.gd"

var laser_path = load("res://prefabs/projectiles/cerberus_laser.tscn")
var touching_wall = false
var velocity = Vector2()


func _ready():
	setup_item(Vector2(-6, 0))


func _physics_process(delta):
	item_update()
	
	position += velocity * delta
	if !touching_wall && is_attached_to == null && grabbed_entity == null:
		velocity.y += 550 * delta
		rotation_degrees += velocity.y * 0.1
	else:
		velocity = Vector2(0, 0)


func _on_used():
	var laser_inst = laser_path.instantiate()
	laser_inst.position = global_position
	laser_inst.rotation_degrees = rotation_degrees
	if is_attached_to == null:
		laser_inst.get_child(0).ignore_in_detection.append(grabbed_entity)
	else:
		laser_inst.get_child(0).ignore_in_detection.append(is_attached_to.grabbed_entity)
	get_tree().current_scene.add_child(laser_inst)


func _on_body_entered(body):
	if body.is_in_group("wall"):
		position.y -= velocity.y * 0.017
		touching_wall = true


func _on_body_exited(body):
	if body.is_in_group("wall"):
		touching_wall = false
