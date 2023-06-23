extends "res://scripts/classes/projectile_class.gd"

var starting_speed = 350
var touching_wall = false
var explosion_path = load("res://prefabs/projectiles/laser.tscn")


func _ready():
	velocity = transform.x * starting_speed


func _physics_process(delta):
	projectile_update(delta)
	velocity.x = lerp(velocity.x, 0.0, 0.02)
	velocity.y += 400 * delta


func _on_body_entered(body):
	if body.is_in_group("wall"):
		explode()


func explode():
	for i in range(15):
		var explosion_inst = explosion_path.instantiate()
		explosion_inst.position.x = position.x + randf_range(-4, 4)
		explosion_inst.position.y = position.y + randf_range(-4, 4)
		explosion_inst.rotation_degrees = randi_range(0, 360)
		get_tree().current_scene.call_deferred("add_child", explosion_inst)
	call_deferred("free")
