extends Node2D

@export var param_name : String


func _ready():
	mm.switch_level_param(param_name)
