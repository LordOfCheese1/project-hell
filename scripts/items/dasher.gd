extends "res://scripts/classes/item_class.gd"

var usable = true


func _ready():
	setup_item(Vector2(5, 0))


func _physics_process(_delta):
	item_update()
	
	if !is_grabbed && is_attached_to == null:
		rotation_degrees += 8


func _on_used():
	if usable:
		if grabbed_entity != null:
			grabbed_entity.velocity.x = transform.x.x * 600
			grabbed_entity.velocity.y = transform.x.y * 300
		
		if has_attachment:
			if self_attachment.scene_file_path == "res://prefabs/items/dasher.tscn":
				usable = false
				self_attachment.usable = true
	
	usable = !usable
	
	if usable:
		gv.spawn_explosion(15, global_position + transform.x * 10, load("res://textures/particles/small_lighting_spark.png"), -0.05, 0, 0, 0, 0, 50)
		$particle_spawner.texture = load("res://textures/particles/lighting_spark.png")
	else:
		gv.spawn_explosion(15, global_position + transform.x * 10, load("res://textures/particles/lighting_spark.png"), -0.05, 0, 0, 0, 0, 80)
		$particle_spawner.texture = load("res://textures/particles/small_lighting_spark.png")
