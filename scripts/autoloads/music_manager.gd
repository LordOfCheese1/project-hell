extends Node2D

@export var musicEvent : EventAsset
@export var mixEvent : EventAsset
var musicInstance : EventInstance
var mixInstance : EventInstance


func _ready():
	musicInstance = RuntimeManager.create_instance(musicEvent)
	mixInstance = RuntimeManager.create_instance(mixEvent)
	if sv.values["music_is_playing"] == true:
		musicInstance.start()
		mixInstance.start()

#change parameter within level music
func switch_level_param(value : String):
	musicInstance.set_parameter_by_name_with_label("LevelVar", value, false)

#change parameter within boss music
func switch_boss_param(value : String):
	musicInstance.set_parameter_by_name_with_label("Boss", value, false)

#switch global music
func switch_fmod_event(value : String, wait_time = 0.0):
	if wait_time != 0.0:
		await get_tree().create_timer(wait_time, true, false, true).timeout
	musicInstance.set_parameter_by_name_with_label("MusicChange", value, false)
	mm.switch_boss_param("Start")

#change mix parameter	
func switch_mix_event(value : String, wait_time = 0.0):
	if wait_time != 0.0:
		await get_tree().create_timer(wait_time, true, false, true).timeout
	FMODStudioModule.get_studio_system().set_parameter_by_name_with_label("MixState", value, false)
