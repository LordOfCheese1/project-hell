extends Node2D

@export var param_name : String


func _ready():
	mm.switch_fmod_event(param_name)
	mm.switch_boss_param("Start")
