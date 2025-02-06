class_name StateLift extends State

@export var lift_audio: AudioStream

@onready var carry: StateCarry = $"../Carry"

func Enter() -> void:
	player.UpdateAnimation("lift")
	player.animation_player.animation_finished.connect(state_complete)
	player.audio.stream = lift_audio
	player.audio.play()

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	player.velocity = Vector2.ZERO
	return null

func state_complete(_a: String) -> void:
	player.animation_player.animation_finished.disconnect(state_complete)
	state_machine.ChangeState(carry)
