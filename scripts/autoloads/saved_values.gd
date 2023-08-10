extends Node2D

var has_switched_scene = false
var temp_pos_save = Vector2()


# "pl" is an acronym for "player"
# Values that should be kept after rebooting and scene switching may be stored here. The stored values here load when the game launches for the first time.
var values = {
	#player-related values
	"pl_grabbed_items" : [],
	"pl_health" : 15.0,
	"pl_pos_x" : 192,
	"pl_pos_y" : 8,
	"current_scene" : "res://scenes/levels/00_hellgates.tscn",
	
	#settings
	"music_is_playing" : true
}


func _process(_delta):
	if has_switched_scene == true:
		has_switched_scene = false
		load_values()
		gv.player.position = temp_pos_save
		temp_pos_save = Vector2(0, 0)


func save_values(to_file = false):
	values["pl_grabbed_items"] = gv.player.request_grabbed_items()
	values["pl_health"] = gv.player.hp
	values["pl_pos_x"] = gv.player.position.x
	values["pl_pos_y"] = gv.player.position.y
	values["current_scene"] = get_tree().current_scene.scene_file_path
	if to_file == true:
		var file = FileAccess.open(OS.get_executable_path().get_base_dir() + "/" + "save_file.json", FileAccess.WRITE)
		file.store_string(JSON.stringify(values))
		file.close()


func load_values(from_file = false):
	if from_file == true:
		if FileAccess.file_exists(OS.get_executable_path().get_base_dir() + "/" + "save_file.json"):
			var file = FileAccess.open(OS.get_executable_path().get_base_dir() + "/" + "save_file.json", FileAccess.READ)
			if file.get_as_text() != "":
				values = JSON.parse_string(file.get_as_text())
			file.close()
	else:
		gv.player.hp = values["pl_health"]
		#item transferral
		var give_to_player = []
		for i in values["pl_grabbed_items"]:
			if typeof(i) == TYPE_ARRAY:
				var to_attach = []
				for x in i:
					var item = load(x).instantiate()
					item.position = gv.player.position
					get_tree().current_scene.add_child(item)
					to_attach.append(item)
				to_attach[1].attach_to(to_attach[0])
				to_attach[1].grabbed_entity = gv.player
				give_to_player.append(to_attach[0])
			elif typeof(i) == TYPE_STRING:
				var item = load(i).instantiate()
				item.position = gv.player.position
				get_tree().current_scene.add_child(item)
				give_to_player.append(item)
		for i in give_to_player:
			gv.player.grabbed_items.append(i)
			i.is_grabbed = true
			i.grabbed_entity = gv.player


func switch_scene(scene : String, player_pos, is_in_playable_scene = true):
	temp_pos_save = player_pos
	if is_in_playable_scene:
		save_values(false)
	has_switched_scene = true
	get_tree().change_scene_to_file(scene)
