@tool
@icon("res://GUI/dialog_system/icons/question_bubble.svg")
class_name DialogChoice extends DialogItem

var dialog_branches: Array[DialogBranch]

func _ready() -> void:
	super()
	for c in get_children():
		if c is DialogBranch:
			dialog_branches.append(c)

func _check_for_dialog_branches() -> bool:
	var count = 0
	for c in get_children():
		if c is DialogBranch:
			count += 1
	return count > 1

func _get_configuration_warnings() -> PackedStringArray:
	if !_check_for_dialog_branches():
		return ["Requires at least 2 DialogBranch nodes."]
	else:
		return []

func set_related_text() -> void:
	var t = get_parent().get_child(self.get_index() - 1)
	if t is DialogText:
		example_dialog.set_dialog_text(t)
		example_dialog.content.visible_characters = -1

func _set_editor_display() -> void:
	set_related_text()
	if dialog_branches.size() < 2: return
	example_dialog.set_dialog_choice(self)
