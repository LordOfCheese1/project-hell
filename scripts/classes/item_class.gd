extends Area2D

signal used
var is_grabbed = false
var gravity_pull = 550
var grabbed_entity : Node
var is_attached_to : Node
var has_attachment = false


func grab(entity : Node):
	is_grabbed = true
	grabbed_entity = entity
	if len(grabbed_entity.grabbed_items) < grabbed_entity.max_grab:
		grabbed_entity.grabbed_items.append(self)


func destroy():
	if grabbed_entity != null:
		if grabbed_entity.grabbed_items.has(self):
			grabbed_entity.grabbed_items.remove_at(grabbed_entity.grabbed_items.find(self))
	call_deferred("free")


func attach_to(target : Node):
	target.has_attachment = true
	is_attached_to = target
	if grabbed_entity != null:
		if grabbed_entity.grabbed_items.has(self):
			grabbed_entity.grabbed_items.remove_at(grabbed_entity.grabbed_items.find(self))
	is_grabbed = false


func setup_item():
	add_to_group("item")


func item_update():
	if is_attached_to != null:
		position = is_attached_to.position
