extends Node2D

const particle_path = preload("res://prefabs/world/particle.tscn")
var player : Node
var cursor_pos = Vector2()
var moved_cursor = 0
var prev_cursor_pos = Vector2(0, 0)


func _physics_process(delta):
	if player == null:
		prev_cursor_pos = cursor_pos
		$cursor.position.x += Input.get_axis("left", "right") * 3
		$cursor.position.y += Input.get_axis("up", "down") * 3
		cursor_pos = $cursor.position
		if moved_cursor > 0:
			$cursor.visible = true
		else:
			$cursor.visible = false
	else:
		$cursor.visible = false
	
	if cursor_pos != prev_cursor_pos:
		moved_cursor = 120
	elif moved_cursor > 0:
		moved_cursor -= 1


func spawn_explosion(particle_amount : int, particle_pos : Vector2, particle_texture : Texture, scale_amount  = 0.0, alpha_amount = 0.0, rot_amount = 0.0, scale_limit = 0.0, gravity = 0.0, starting_velocity = 0.0):
	for i in range(particle_amount):
		var particle_inst = particle_path.instantiate()
		particle_inst.position = particle_pos
		particle_inst.rotation_degrees = randi_range(0, 360)
		particle_inst.texture = particle_texture
		particle_inst.scale_amount = scale_amount
		particle_inst.rot_amount = rot_amount
		particle_inst.alpha_amount = alpha_amount
		particle_inst.scale_limit = scale_limit
		particle_inst.gravity = gravity
		particle_inst.starting_velocity = starting_velocity
		get_tree().current_scene.add_child(particle_inst)


func hitstop(time : float):
	get_tree().paused = true
	await get_tree().create_timer(time, true, false, true).timeout
	get_tree().paused = false
