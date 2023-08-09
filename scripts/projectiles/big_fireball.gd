extends "res://scripts/classes/projectile_class.gd"

var small_fireball_scene = load("res://prefabs/projectiles/laser.tscn")


func _ready():
	velocity = transform.x * 180
	$sprite.scale = Vector2(0, 0)


func _physics_process(delta):
	$sprite.scale = lerp($sprite.scale, Vector2(1, 1), 0.1)
	$sprite.rotation_degrees += randi_range(-10, 10)
	projectile_update(delta)


func _on_body_entered(body):
	if body.is_in_group("wall"):
		for i in range(-4, 4):
			var small_fireball = small_fireball_scene.instantiate()
			small_fireball.position = global_position - transform.x * 4
			small_fireball.rotation_degrees = (rotation_degrees - 180) + i * 15
			small_fireball.get_child(0).ignore_in_detection = $attackbox.ignore_in_detection
			get_tree().current_scene.call_deferred("add_child", small_fireball)
		call_deferred("free")
