extends Node2D

var tile_path = load("res://prefabs/components/pathfinder_tile.tscn")
var optimal_path_tiles = []
@export var target_pos = Vector2(0, 0)


func _process(delta):
	if Input.is_action_just_pressed("test"):
		refresh()


func refresh():
	var previous_tiles = [Vector2(snapped(global_position.x, 16), snapped(global_position.y, 16)) / 16]
	for amount in range(16):
		var new_tiles = []
		for i in previous_tiles:
			for tile in range(4):
				match tile:
					0:
						new_tiles.append(previous_tiles[previous_tiles.find(i)] + Vector2(0, -1))
					1:
						new_tiles.append(previous_tiles[previous_tiles.find(i)] + Vector2(1, 0))
					2:
						new_tiles.append(previous_tiles[previous_tiles.find(i)] + Vector2(0, 1))
					3:
						new_tiles.append(previous_tiles[previous_tiles.find(i)] + Vector2(-1, 0))
		previous_tiles = new_tiles
		for l in new_tiles:
			instance_pathfinder_tile(l * 16)
		await get_tree().create_timer(1).timeout


func instance_pathfinder_tile(pos : Vector2):
	var tile = tile_path.instantiate()
	tile.position = pos
	get_tree().current_scene.add_child(tile)
	await get_tree().create_timer(0.8).timeout
	tile.call_deferred("free")
