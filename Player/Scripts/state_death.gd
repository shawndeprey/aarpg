class_name StateDeath extends State

@export var exhaust_audio: AudioStream
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

# What happens when the player inits this state?
func Init() -> void:
	pass

# What happens when the player enters this state?
func Enter() -> void:
	player.animation_player.play("death")
	audio.stream = exhaust_audio
	audio.play()
	PlayerHud.show_game_over_screen()
	AudioManager.play_music(null)

# What happens when the player exits this state?
func Exit() -> void:
	pass

# What happens during the _process update in this State?
func Process(_delta: float) -> State:
	player.velocity = Vector2.ZERO
	return null

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> State:
	return null

# What happens with input events in this State?
func HandleInput(_event: InputEvent) -> State:
	return null
