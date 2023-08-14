extends Sprite2D

var border = 65
@export var sound : NodePath
var sounds = [
	load("res://sfx/entities/player/footsteps/footsteps_0.wav"),
	load("res://sfx/entities/player/footsteps/footsteps_1.wav"),
	load("res://sfx/entities/player/footsteps/footsteps_2.wav")
]


func _physics_process(_delta):
	if get_parent().get_parent().is_on_floor():
		rotation_degrees += (position.x / 2) * get_parent().get_parent().velocity.x / 12
		if rotation_degrees > border:
			rotation_degrees = -(border - 1)
			get_node(sound).stream = sounds[randi_range(0, 2)]
			get_node(sound).play()
		if rotation_degrees < -border:
			rotation_degrees = border - 1
			get_node(sound).stream = sounds[randi_range(0, 2)]
			get_node(sound).play()
	else:
		rotation_degrees = -(position.x / 2) * border
