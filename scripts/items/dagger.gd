extends "res://scripts/classes/item_class.gd"

var velocity = Vector2()
var touching_wall = false
var projectile_path = load("res://prefabs/projectiles/dagger_beam.tscn")


func _ready():
	setup_item(Vector2(6, 0))


func _physics_process(delta):
	item_update()
	position += velocity * delta
	
	if !touching_wall && grabbed_entity == null && is_attached_to == null:
		velocity.y += gravity_pull * delta
		rotation_degrees += velocity.y / 10
	else:
		velocity = Vector2(0, 0)
	
	velocity.x = lerp(velocity.x, 0.0, 0.01)


func _on_body_entered(body):
	if body.is_in_group("wall"):
		position.y -= velocity.y / 60
		touching_wall = true


func _on_body_exited(body):
	if body.is_in_group("wall"):
		touching_wall = false


func _on_used():
	for i in range(8):
		var projectile = projectile_path.instantiate()
		projectile.starting_velocity = 50 + i * 20
		projectile.position = global_position + transform.x * 4
		projectile.rotation_degrees = rotation_degrees + randi_range(-5, 5)
		if is_attached_to == null:
			projectile.get_child(0).ignore_in_detection.append(grabbed_entity)
		else:
			projectile.get_child(0).ignore_in_detection.append(is_attached_to.grabbed_entity)
		get_tree().current_scene.add_child(projectile)
