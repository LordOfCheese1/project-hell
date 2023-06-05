extends Area2D

@export var paramName1 = ""
@export var paramName2 = ""

signal param_Name(paramName1, paramName2)

func _ready():
	emit_signal("param_Name", paramName1, paramName2)

 



