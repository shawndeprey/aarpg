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
	if !animation_player.animation_finished.is_connected(_on_animation_finished):
		animation_player.animation_finished.connect(_on_animation_finished)
	return true

func _on_animation_finished(_anim_name: String) -> void:
	if animation_player.animation_finished.is_connected(_on_animation_finished):
		animation_player.animation_finished.disconnect(_on_animation_finished)
	PauseMenu.ignore_input = false
	visible = false
