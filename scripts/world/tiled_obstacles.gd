extends TileMap


var obstacles = {
	0 : load("res://prefabs/obstacles/lava_top.tscn"),
	1 : load("res://prefabs/obstacles/lava_bottom.tscn")
}


func _ready():
	for i in get_used_cells(0):
		var obstacle_inst = obstacles[get_cell_source_id(0, i, false)].instantiate()
		obstacle_inst.position = (i * 16) + Vector2i(8, 8)
		add_child(obstacle_inst)
	clear()
