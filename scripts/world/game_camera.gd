extends Camera2D

@export var follow : NodePath
var smoothing_cooldown = 10
var current_room_cam : Node


func _ready():
	position_smoothing_enabled = false


func _process(_delta):
	if current_room_cam != null:
		limit_left = current_room_cam.position.x - current_room_cam.size.x / 2
		limit_right = current_room_cam.position.x + current_room_cam.size.x / 2
		limit_top = current_room_cam.position.y - current_room_cam.size.y / 2
		limit_bottom = current_room_cam.position.y + current_room_cam.size.y / 2
	else:
		limit_left = -65536
		limit_right = 65536
		limit_top = -65536
		limit_bottom = 65536
	position = get_node(follow).position
	$room_detect.position = to_local(get_node(follow).position)
	if smoothing_cooldown > 0:
		smoothing_cooldown -= 1
	else:
		if !position_smoothing_enabled:
			position_smoothing_enabled = true


func _on_room_detect_area_entered(area):
	if area.is_in_group("room_cam"):
		current_room_cam = area
