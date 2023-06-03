extends StudioEventEmitter2D


var playerFootsteps = EventAsset

func _ready():
	RuntimeManager.play_one_shot(playerFootsteps)

