extends CanvasLayer
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

func fade_out() -> bool:
	PauseMenu.ignore_input = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	PauseMenu.ignore_input = false
	return true

func fade_in() -> bool:
	PauseMenu.ignore_input = true
	animation_player.play("fade_in")
	await animation_player.animation_finished
	PauseMenu.ignore_input = false
	return true
