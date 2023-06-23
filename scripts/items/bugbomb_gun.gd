extends "res://scripts/classes/item_class.gd"

var bomb_path = load("res://prefabs/projectiles/bomb.tscn")


func _ready():
	setup_item(Vector2(8, 0))


func _physics_process(delta):
	if $bomb.scale.x < 0.9:
		$bomb.scale = lerp($bomb.scale, Vector2(1, 1), 0.1)
	
	item_update()


func _on_used():
	$bomb.scale = Vector2(0, 0)
	var bomb_inst = bomb_path.instantiate()
	bomb_inst.position = position + transform.x * 10
	bomb_inst.rotation_degrees = rotation_degrees
	get_tree().current_scene.add_child(bomb_inst)
