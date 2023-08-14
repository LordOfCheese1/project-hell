extends Node2D

@export var musicEvent : EventAsset
@export var mixEvent : EventAsset
@export var ambiEvent : EventAsset
@export var cerbDeath : EventAsset
@export var serpentDeath : EventAsset
var musicInstance : EventInstance
var mixInstance : EventInstance
var ambiInstance: EventInstance



func _ready():
	musicInstance = RuntimeManager.create_instance(musicEvent)
	mixInstance = RuntimeManager.create_instance(mixEvent)
	ambiInstance = RuntimeManager.create_instance(ambiEvent)

	if sv.values["music_is_playing"] == true:
		musicInstance.start()
		mixInstance.start()
		#ambiInstance.start()

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

func trigger_cerberus_death():
	RuntimeManager.play_one_shot(cerbDeath)
	
func trigger_serpent_death():
	RuntimeManager.play_one_shot(serpentDeath)
