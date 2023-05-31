extends Node2D

const particle_path = preload("res://prefabs/world/particle.tscn")
var player : Node


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
