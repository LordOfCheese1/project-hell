extends Node2D

@export var texture : Texture
@export var freq : float
var time = 0.0
var particle_path = load("res://prefabs/world/particle.tscn")
@export var scale_amount : float
@export var alpha_amount : float
@export var rot_amount : float
@export var scale_limit : float
var is_emitting = true


func _physics_process(delta):
	time += delta
	if time > freq:
		time = 0
		if is_emitting:
			spawn_particle()


func spawn_particle():
	var particle = particle_path.instantiate()
	particle.rotation_degrees = randi_range(0, 360)
	particle.global_position = Vector2(global_position.x + randi_range(-1, 1), global_position.y + randi_range(-1, 1))
	particle.scale_amount = scale_amount
	particle.alpha_amount = alpha_amount
	particle.rot_amount = rot_amount
	particle.scale_limit = scale_limit
	particle.texture = texture
	get_tree().current_scene.add_child(particle)
