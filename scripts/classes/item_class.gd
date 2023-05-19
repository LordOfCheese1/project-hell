extends Area2D

signal used
var is_grabbed = false
var gravity_pull = 550
var grabbed_entity : Node
var is_attached_to : Node
var has_attachment = false
var self_attachment : Node
var attach_position = Vector2()


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
	target.self_attachment = self
	if grabbed_entity != null:
		if grabbed_entity.grabbed_items.has(self):
			grabbed_entity.grabbed_items.remove_at(grabbed_entity.grabbed_items.find(self))
	is_grabbed = false


func use():
	emit_signal("used")
	if self_attachment != null:
		self_attachment.use()


func setup_item(attach_pos = Vector2(0, 0)):
	add_to_group("item")
	attach_position = attach_pos


func item_update():
	if is_attached_to != null:
		position = is_attached_to.position + is_attached_to.attach_position * is_attached_to.transform.x
		rotation_degrees = is_attached_to.rotation_degrees
