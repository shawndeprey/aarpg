class_name StateLower extends State

@export var lower_audio: AudioStream

@onready var idle: StateIdle = $"../Idle"

func Enter() -> void:
	player.UpdateAnimation("lower")
	player.animation_player.animation_finished.connect(state_complete)
	player.audio.stream = lower_audio
	player.audio.play()

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	player.velocity = Vector2.ZERO
	return null

func state_complete(_a: String) -> void:
	player.animation_player.animation_finished.disconnect(state_complete)
	player.lower_item()
	state_machine.ChangeState(idle)
	
