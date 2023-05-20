extends "res://scripts/classes/item_class.gd"

var projectile_path = load("res://prefabs/projectiles/laser.tscn")


func _ready():
	setup_item(Vector2(0, 0))


func _physics_process(delta):
	item_update()


func _on_used():
	var projectile = projectile_path.instantiate()
	projectile.position = global_position
	projectile.rotation_degrees = rotation_degrees + randi_range(-4, 4)
	get_tree().current_scene.add_child(projectile)
