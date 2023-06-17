extends Area2D

var colours = [
	[59, 21, 45],
	[128, 50, 33]
]


func _physics_process(delta):
	$tile.modulate.r = randi_range(colours[0][0], colours[1][0]) / 255
	$tile.modulate.g = randi_range(colours[0][1], colours[1][1]) / 255
	$tile.modulate.b = randi_range(colours[0][2], colours[1][2]) / 255
