@tool
@icon("res://GUI/dialog_system/icons/text_bubble.svg")
class_name DialogText extends DialogItem

@export_multiline var text: String = "Placeholder text"

func _ready() -> void:
	if Engine.is_editor_hint(): return
