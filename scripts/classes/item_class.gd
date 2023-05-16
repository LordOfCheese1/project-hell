extends Area2D

signal used
var is_grabbed = false
var gravity_pull = 550
var grabbed_entity : Node


func grab(entity : Node):
	is_grabbed = true
	grabbed_entity = entity
	if len(grabbed_entity.grabbed_items) < grabbed_entity.max_grab:
		grabbed_entity.grabbed_items.append(self)


func destroy():
	pass


func setup_item():
	add_to_group("item")
