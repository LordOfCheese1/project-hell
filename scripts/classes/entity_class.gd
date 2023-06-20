extends CharacterBody2D

@onready var hit_shader = load("res://shaders/flash.gdshader")
var scrap_path = load("res://prefabs/world/scrap.tscn")
var hp = 1.0
var gravity = 550
var grabbed_items = []
var max_grab = 0
var is_dead = false
var type = 0 #0 = friendly, 1 = enemy, 2 = boss
var hit_flash_fac = 0.0


func setup_entity(starting_hp : float, grab_capacity : int, entity_type = 0):
	add_to_group("entity")
	hp = starting_hp
	max_grab = grab_capacity
	type = entity_type
	material = ShaderMaterial.new()
	material.shader = hit_shader
	material.setup_local_to_scene()


func entity_update():
	material.set_shader_parameter("fac", hit_flash_fac)
	if !get_child(0).use_parent_material:
		for i in get_children():
			if i.get_class() == "Node2D":
				i.use_parent_material = true
	
	hit_flash_fac = lerp(float(hit_flash_fac), 0.0, 0.1)


func hit():
	hit_flash_fac = 1.0


func die(scrap_amount = 0):
	for i in range(scrap_amount):
		var scrap_inst = scrap_path.instantiate()
		scrap_inst.position = global_position
		scrap_inst.rotation_degrees = randi_range(0, 360)
		get_tree().current_scene.add_child(scrap_inst)
