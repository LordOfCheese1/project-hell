extends Node2D

var mods = [
	
]


func _ready():
	load_mods()
	enable_mods()


func load_mods():
	var game_directory = DirAccess.open(OS.get_executable_path().get_base_dir())
	
	game_directory.list_dir_begin()
	
	while true:
		var file = game_directory.get_next()
		if file == "":
			break
		elif file.get_extension() == "gd":
			mods.append(load(file))
	
	game_directory.list_dir_end()


func enable_mods():
	for i in mods:
		var mod_node = Node2D.new()
		mod_node.set_script(i)
		add_child(mod_node)
