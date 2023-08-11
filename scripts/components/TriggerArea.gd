extends Area2D

@export var paramName1 = ""
@export var paramName2 = ""
@export var paramName3 = ""
@export var paramName4 = ""
@export var paramName5 = ""


signal param_Name(paramName1, paramName2, paramName3, paramName4, paramName5)

func _ready():
	emit_signal("param_Name", paramName1, paramName2, paramName3, paramName4, paramName5)
