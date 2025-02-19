extends CanvasLayer
const MAIN_MENU: String = "res://title_scene/title_screen.tscn"
@onready var tab_container: TabContainer = $Control/TabContainer

@onready var button_save: Button = $Control/TabContainer/System/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/TabContainer/System/VBoxContainer/Button_Load
@onready var button_quit: Button = $Control/TabContainer/System/VBoxContainer/Button_Quit

@onready var item_description: Label = $Control/TabContainer/Inventory/ItemDescription
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal shown
signal hidden

var is_paused: bool = false
var ignore_input: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)
	button_quit.pressed.connect(_on_quit_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if ignore_input: return
	if event.is_action_pressed("pause"):
		if !is_paused:
			if DialogSystem.is_active: return
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()
	
	if is_paused:
		if event.is_action_pressed("right_bumper"):
			change_tab(1)
		elif event.is_action_pressed("left_bumper"):
			change_tab(-1)

func show_pause_menu() -> void:
	get_tree().paused = true
	if SaveManager.get_save_file() == null:
		button_load.disabled = true
		button_load.visible = false
	else:
		button_load.disabled = false
		button_load.visible = true
	visible = true
	is_paused = true
	tab_container.current_tab = 0
	shown.emit()

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()

func _on_save_pressed() -> void:
	if !is_paused: return
	SaveManager.save_game()
	hide_pause_menu()

func _on_load_pressed() -> void:
	if !is_paused: return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()

func _on_quit_pressed() -> void:
	if !is_paused: return
	#get_tree().quit()
	LevelManager.load_new_level(MAIN_MENU, "", Vector2.ZERO)
	await LevelManager.level_load_started
	PlayerManager.player.position = Vector2.ZERO
	visible = false
	AudioManager.stop_all_music()

func update_item_description(new_text: String) -> void:
	item_description.text = new_text

func play_audio(audio: AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()

func change_tab(offset: int = 1) -> void:
	tab_container.current_tab = wrapi(tab_container.current_tab + offset, 0, tab_container.get_tab_count())
	tab_container.get_tab_bar().grab_focus()
