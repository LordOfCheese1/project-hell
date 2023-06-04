extends Area2D

@export var areaName = ""

signal area_Name(areaName)

func _ready():
	emit_signal("area_Name", areaName)

 
