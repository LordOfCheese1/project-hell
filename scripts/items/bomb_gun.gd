extends "res://scripts/classes/item_class.gd"

var bomb_path = load("res://prefabs/projectiles/poison_spew.tscn")
var bubble_size = 1
var velocity = Vector2()
var touching_wall = false


func _ready():
	setup_item(Vector2(-4, 0))


func _physics_process(delta):
	item_update()
	position += velocity * delta
	if bubble_size < 1:
		bubble_size += 0.1
	$bubble.scale = lerp($bubble.scale, Vector2(bubble_size, bubble_size), 0.3)
	
	if !touching_wall && grabbed_entity == null && is_attached_to == null:
		velocity.y += gravity_pull * delta
		rotation_degrees += velocity.y / 10
	else:
		velocity = Vector2(0, 0)
	
	velocity.x = lerp(velocity.x, 0.0, 0.01)


func _on_used():
	var bomb_inst = bomb_path.instantiate()
	bomb_inst.position = global_position + transform.x * 12
	bomb_inst.rotation_degrees = rotation_degrees
	if !bomb_inst.get_child(0).ignore_in_detection.has(grabbed_entity):
		bomb_inst.get_child(0).ignore_in_detection.append(grabbed_entity)
	get_tree().current_scene.add_child(bomb_inst)
	bubble_size = 0.1
	$spit.pitch_scale = randf_range(0.8, 1.2)
	$spit.play()


func _on_body_entered(body):
	if body.is_in_group("wall"):
		position.y -= velocity.y * 0.017
		touching_wall = true


func _on_body_exited(body):
	if body.is_in_group("wall"):
		touching_wall = false
