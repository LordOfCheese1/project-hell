extends Camera2D


@export var screen_size = Vector2(384, 256)
@export var follow : NodePath
var camera_offset = Vector2(0, 0)


func _ready():
	position = get_node(follow).position


func _process(_delta):
	if get_node_or_null(follow) != null:
		position = get_node(follow).position
	position.x = snapped(position.x + (screen_size.x / 2), screen_size.x) - (screen_size.x / 2) + camera_offset.x
	position.y = snapped(position.y + (screen_size.y / 2), screen_size.y) - (screen_size.y / 2) + camera_offset.y
