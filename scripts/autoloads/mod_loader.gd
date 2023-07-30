extends Node2D

var mods = [
	
]
var other_files = [
	
]
var orig_game_files = [
	
]
var allowed_extensions = [
	"gd"
]
var game_directory
var mods_folder = ""


func _ready():
	orig_game_files = get_all_files("res://")
	
	game_directory = DirAccess.open(OS.get_executable_path().get_base_dir())
	if game_directory.dir_exists("mods"):
		mods_folder = OS.get_executable_path().get_base_dir() + "/mods"
	else:
		game_directory.make_dir("mods")
		mods_folder = OS.get_executable_path().get_base_dir() + "/mods"
	
	load_mods()
	enable_mods()


func load_mods():
	var mods_dir = DirAccess.open(mods_folder)
	
	mods_dir.list_dir_begin()
	
	while true:
		var file = mods_dir.get_next()
		if file == "":
			break
		else:
			mods.append(file)
	
	mods_dir.list_dir_end()


func enable_mods():
	for i in range(len(mods)):
		if orig_game_files.has(mods[i]): # If current file name is found in orig game files, overwrite the orig game file with new one
			load(mods_folder + "/" + mods[i]).take_over_path(orig_game_files[orig_game_files.find(mods[i]) + 1] + "/" + mods[i])
		else: # This adds any nonexisting script to an autoload, NEEDS REWORKING
			var mod_node = Node2D.new()
			mod_node.set_script(ResourceLoader.load(mods_folder + "/" + mods[i]))
			call_deferred("add_child", mod_node)


func get_all_files(path : String, files := []):
	var dir = DirAccess.open(path)
	
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			files = get_all_files(dir.get_current_dir() + "/" + file_name, files)
		elif allowed_extensions.has(file_name.get_extension()):
			files.append(file_name)
			files.append(dir.get_current_dir())
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	return files
