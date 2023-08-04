extends Node

var first_frame = false


func _process(_delta):
	if !first_frame:
		first_frame = true
		get_tree().change_scene_to_file("res://scenes/levels/00_hellgates.tscn")
