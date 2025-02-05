extends CanvasLayer
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

func _ready() -> void:
	visible = false

func fade_out() -> bool:
	PauseMenu.ignore_input = true
	visible = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	PauseMenu.ignore_input = false
	return true

func fade_in() -> bool:
	PauseMenu.ignore_input = true
	animation_player.play("fade_in")
	await animation_player.animation_finished
	PauseMenu.ignore_input = false
	visible = false
	return true
