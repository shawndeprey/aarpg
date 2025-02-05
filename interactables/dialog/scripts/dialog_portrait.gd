@tool
class_name DialogPortrait extends Sprite2D

var blink: bool = false: set = _set_blink
var open_mouth: bool = false: set = _set_open_mouth
var mouth_open_frames: int = 0
var audio_pitch_base: float = 1.0

@onready var audio: AudioStreamPlayer = $"../AudioStreamPlayer"

func _ready() -> void:
	if Engine.is_editor_hint(): return
	DialogSystem.letter_added.connect(check_mouth_open)
	blinker()

func update_portrait() -> void:
	if open_mouth:
		frame = 2
	else:
		frame= 0
	if blink:
		frame += 1

func blinker() -> void:
	if !blink:
		await get_tree().create_timer(randf_range(0.1, 3)).timeout
	else:
		await get_tree().create_timer(0.15).timeout
	blink = !blink
	blinker()

func _set_blink(value: bool) -> void:
	if blink != value:
		blink = value
		update_portrait()

func _set_open_mouth(value: bool) -> void:
	if open_mouth != value:
		open_mouth = value
		update_portrait()

func check_mouth_open(l: String) -> void:
	if "aeiouy1234567890".contains(l):
		open_mouth = true
		mouth_open_frames += 4
		audio.pitch_scale = randf_range(audio_pitch_base - 0.04, audio_pitch_base + 0.04)
		audio.play()
	elif ".,!?":
		audio.pitch_scale = audio_pitch_base - 0.1
		audio.play()
		mouth_open_frames = 0
	if mouth_open_frames > 0:
		mouth_open_frames -= 1
	if mouth_open_frames == 0:
		if open_mouth:
			open_mouth = false
			audio.pitch_scale = randf_range(audio_pitch_base - 0.08, audio_pitch_base + 0.02)
			audio.play()
