extends Node2D

var orig_game_files = {
	"file_names" : [],
	"file_locations": []
}
var mod_files = {
	"text" : [],
	"audio" : [],
	"image" : []
}
var main_scripts = [
	
]
var stored_files = {}
var allowed_extensions = [
	"gd",
	"png",
	"wav",
	"mp3"
]
var extension_types = {
	"text" : ["gd"],
	"audio" : ["wav", "mp3"],
	"image" : ["png"]
}
var game_directory
var mods_folder = ""


func _ready():
	var is_folder = false
	for i in get_all_files("res://"):
		if is_folder:
			orig_game_files["file_locations"].append(i)
		else:
			orig_game_files["file_names"].append(i)
		is_folder = !is_folder
	
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
	var subdirs = []
	
	mods_dir.list_dir_begin() #Loop through mods directory to find all subdirectories
	
	while true:
		var file = mods_dir.get_next()
		if file == "":
			break
		elif mods_dir.current_is_dir():
			subdirs.append(file)
	
	mods_dir.list_dir_end()
	
	for i in subdirs: #Loop through current mod folder
		var mod_folder = DirAccess.open(mods_folder + "/" + i)
		
		mod_folder.list_dir_begin()
		
		while true:
			var file = mod_folder.get_next()
			if file == "":
				break
			elif !mod_folder.current_is_dir():
				if extension_types["text"].has(file.get_extension()) && file.get_basename() != "main": #Append text files to "mod_files" if it's not called "main"
					mod_files["text"].append([file, mods_folder + "/" + i])
				elif file.get_basename() == "main": #Append "main.gd" to main scripts
					main_scripts.append(mods_folder + "/" + i + "/" + file)
				
				if extension_types["audio"].has(file.get_extension()): #Append audio files to "mod_files"
					mod_files["aduio"].append([file, mods_folder + "/" + i])
				
				if extension_types["image"].has(file.get_extension()): #Append image files to "mod_files
					mod_files["image"].append([file, mods_folder + "/" + i])
					print(file)
		
		mod_folder.list_dir_end()
	
	#Load mod files
	for file in mod_files["text"]: #Load text files
		stored_files[file[0]] = load(file[1] + "/" + file[0])
	
	for file in mod_files["image"]: #Load image files
		var image = Image.load_from_file(file[1] + "/" + file[0])
		var texture = ImageTexture.create_from_image(image)
		stored_files[file[0]] = texture


func enable_mods():
	for i in stored_files: #Replace existing files if they exist, otherwise leave them stored to be accessed by main.gd
		if orig_game_files["file_names"].has(i):
			var file_id = orig_game_files["file_names"].find(i)
			stored_files[i].take_over_path(orig_game_files["file_locations"][file_id] + "/" + orig_game_files["file_names"][file_id])
	
	for i in range(len(main_scripts)):
		var script_holder = Node2D.new()
		script_holder.name = "mod" + str(i)
		script_holder.set_script(load(main_scripts[i]))
		add_child(script_holder)


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
