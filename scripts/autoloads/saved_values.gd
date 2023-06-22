extends Node2D

var has_switched_scene = false
var temp_pos_save = Vector2()


func _ready():
	pass


# "pl" is an acronym for "player"
# Values that should be kept after rebooting and scene switching may be stored here. The stored values here load when the game launches for the first time.
var values = {
	"pl_grabbed_items" : [],
	"pl_health" : 10.0,
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


func load_values(from_file = false):
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


func switch_scene(scene : String, player_pos):
	temp_pos_save = player_pos
	save_values(false)
	has_switched_scene = true
	get_tree().change_scene_to_file(scene)
