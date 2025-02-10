extends CanvasLayer

@export var button_focus_audio: AudioStream = preload("res://title_scene/audio/menu_focus.wav")
@export var button_select_audio: AudioStream = preload("res://title_scene/audio/menu_select.wav")

var hearts: Array[HeartGui] = []

@onready var game_over: Control = $Control/GameOver
@onready var continue_button: Button = $Control/GameOver/VBoxContainer/ContinueButton
@onready var title_button: Button = $Control/GameOver/VBoxContainer/TitleButton
@onready var animation_player: AnimationPlayer = $Control/GameOver/AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@onready var boss_ui: Control = $Control/BossUI
@onready var boss_hp_bar: TextureProgressBar = $Control/BossUI/TextureProgressBar
@onready var boss_label: Label = $Control/BossUI/BossName


func _ready() -> void:
	for child in $Control/Sprite2D/HFlowContainer.get_children():
		if child is HeartGui:
			hearts.append(child)
			child.visible = false
	hide_game_over_screen()
	continue_button.focus_entered.connect(play_audio.bind(button_focus_audio))
	continue_button.pressed.connect(load_game)
	title_button.focus_entered.connect(play_audio.bind(button_focus_audio))
	title_button.pressed.connect(title_screen)
	LevelManager.level_load_started.connect(hide_game_over_screen)
	hide_boss_health()

func update_hp(_hp: int, _max_hp: int) -> void:
	update_max_hp(_max_hp)
	for i in _max_hp:
		update_heart(i, _hp)

func update_heart(_index: int, _hp: int) -> void:
	var _value: int = clampi(_hp - _index * 2, 0, 2)
	hearts[_index].value = _value
	pass

func update_max_hp(_max_hp: int) -> void:
	var _heart_count: int = roundi(_max_hp * 0.5)
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass

func play_audio(a: AudioStream) -> void:
	audio.stream = a
	audio.play()

func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color(1, 1, 1, 0)

func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	var can_continue: bool = SaveManager.has_save()
	continue_button.visible = can_continue
	animation_player.play("show_game_over")
	await animation_player.animation_finished
	if continue_button:
		continue_button.grab_focus()
	else:
		title_button.grab_focus()

func load_game() -> void:
	play_audio(button_select_audio)
	await fade_to_black()
	SaveManager.load_game()

func fade_to_black() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	PlayerManager.player.revive_player()
	return true

func title_screen() -> void:
	play_audio(button_select_audio)
	await fade_to_black()
	LevelManager.load_new_level("res://title_scene/title_screen.tscn", "", Vector2.ZERO)

func hide_boss_health() -> void:
	boss_ui.visible = false

func show_boss_health(_name: String) -> void:
	boss_ui.visible = true
	boss_label.text = _name
	update_boss_health(1, 1)

func update_boss_health(hp: int, max_hp: int) -> void:
	boss_hp_bar.value = clampf(float(hp) / float(max_hp) * 100, 0, 100)
