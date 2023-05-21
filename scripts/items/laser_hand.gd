extends "res://scripts/classes/item_class.gd"

var projectile_path = load("res://prefabs/projectiles/laser.tscn")


func _ready():
	setup_item(Vector2(0, 0))


func _physics_process(_delta):
	item_update()


func _on_used():
	var projectile = projectile_path.instantiate()
	projectile.position = global_position
	projectile.rotation_degrees = rotation_degrees + randi_range(-4, 4)
	projectile.get_child(0).ignore_in_detection.append(grabbed_entity)
	get_tree().current_scene.add_child(projectile)
