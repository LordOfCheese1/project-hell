extends "res://scripts/classes/item_class.gd"

var velocity = Vector2()
var touching_wall = false
var projectile_path = load("res://prefabs/projectiles/dagger_swing.tscn")
var prev_dir = -1
var target_rot = -100
var flash_fac = 0.0
var sounds = [
	load("res://sfx/items/dagger/dagger0.wav"),
	load("res://sfx/items/dagger/dagger1.wav"),
	load("res://sfx/items/dagger/dagger2.wav"),
	load("res://sfx/items/dagger/dagger3.wav"),
	load("res://sfx/items/dagger/dagger4.wav"),
	load("res://sfx/items/dagger/dagger5.wav"),
	load("res://sfx/items/dagger/dagger6.wav")
]


func _ready():
	$Sprite2D.scale.y = -1
	setup_item(Vector2(4, 0))


func _physics_process(delta):
	item_update()
	position += velocity * delta
	
	if !touching_wall && grabbed_entity == null && is_attached_to == null:
		velocity.y += gravity_pull * delta
		rotation_degrees += velocity.y / 10
	else:
		velocity = Vector2(0, 0)
	
	velocity.x = lerp(velocity.x, 0.0, 0.01)
	
	$Sprite2D.rotation_degrees = lerp(float($Sprite2D.rotation_degrees), float(target_rot), 0.25)
	flash_fac = lerp(flash_fac, 0.0, 0.1)
	$Sprite2D.material.set_shader_parameter("fac", flash_fac)
	
	$CollisionShape2D.position = $Sprite2D.position + $Sprite2D.transform.x * 7
	$CollisionShape2D.rotation_degrees = $Sprite2D.rotation_degrees


func _on_body_entered(body):
	if body.is_in_group("wall"):
		position.y -= velocity.y * 0.017
		touching_wall = true


func _on_body_exited(body):
	if body.is_in_group("wall"):
		touching_wall = false


func _on_used():
	$swing.stream = sounds[randi_range(0, 6)]
	$swing.play()
	flash_fac = 1.0
	target_rot = 100 * -prev_dir
	var projectile = projectile_path.instantiate()
	projectile.position = global_position + transform.x
	projectile.rotation_degrees = rotation_degrees + prev_dir * 90
	projectile.goal_rot = rotation_degrees - prev_dir * 90
	projectile.instanced_by = self
	if is_attached_to == null:
		projectile.get_child(0).ignore_in_detection.append(grabbed_entity)
	else:
		projectile.get_child(0).ignore_in_detection.append(is_attached_to.grabbed_entity)
	get_tree().current_scene.add_child(projectile)
	$Sprite2D.scale.y = -prev_dir
	prev_dir = -prev_dir
