class_name TitleScreen extends Node2D

const START_LEVEL: String = "res://playground.tscn"

@export var music: AudioStream
@export var button_focus_audio: AudioStream
@export var button_pressed_audio: AudioStream

@onready var button_new: Button = $"CanvasLayer/Control/Button New"
@onready var button_continue: Button = $"CanvasLayer/Control/Button Continue"
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var splash_screen: SplashScreen = $CanvasLayer/Control/SplashScreen

func _ready() -> void:
	get_tree().paused = true
	PlayerHud.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().process_frame
	await get_tree().process_frame
	PlayerManager.player.visible = false
	if SaveManager.get_save_file() == null:
		button_continue.disabled = true
		button_continue.visible = false
	splash_screen.finished.connect(setup_title_screen)
	LevelManager.level_load_started.connect(exit_title_screen)

func setup_title_screen() -> void:
	AudioManager.play_music(music)
	button_new.pressed.connect(start_new_game)
	button_new.grab_focus()
	button_continue.pressed.connect(continue_game)

	button_new.focus_entered.connect(play_audio.bind(button_focus_audio))
	button_continue.focus_entered.connect(play_audio.bind(button_focus_audio))

func start_new_game() -> void:
	play_audio(button_pressed_audio)
	LevelManager.load_new_level(START_LEVEL, "", Vector2.ZERO)

func continue_game() -> void:
	play_audio(button_pressed_audio)
	SaveManager.load_game()

func exit_title_screen() -> void:
	PlayerManager.player.visible = true
	PlayerHud.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	self.queue_free()

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream
	audio.play()
