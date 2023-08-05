extends Node2D

@export var flip = false
@export var length = int(2)
var texture = load("res://textures/entities/spider/leg_part.png")
var target_pos = Vector2()
var last_part_pos = Vector2()


func _ready():
	for i in range(length):
		var part = Sprite2D.new()
		part.position = Vector2(0, 0)
		part.texture = texture
		part.offset.x = 8
		$leg_parts.add_child(part)


func _physics_process(delta):
	target_pos = get_global_mouse_position()
	
	var prev_part = target_pos
	for i in $leg_parts.get_child_count():
		$leg_parts.get_child(i).look_at(prev_part)
		$leg_parts.get_child(i).position = prev_part - $leg_parts.get_child(i).transform.x * 16
		prev_part = $leg_parts.get_child(i).position
	
	var dst_to_move = $leg_parts.get_child($leg_parts.get_child_count() - 1).position - Vector2(0, 0)
	
	for i in $leg_parts.get_children():
		i.position -= dst_to_move
	
	last_part_pos = $leg_parts.get_child($leg_parts.get_child_count() - 1).position
