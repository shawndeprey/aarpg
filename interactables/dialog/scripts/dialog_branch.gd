@tool
@icon("res://GUI/dialog_system/icons/answer_bubble.svg")
class_name DialogBranch extends DialogItem
signal selected

@export var text: String = "Ok..." : set = _set_text

var dialog_items: Array[DialogItem]

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	for c in get_children():
		if c is DialogItem:
			dialog_items.append(c)

func _set_text(value: String) -> void:
	text = value
	if Engine.is_editor_hint() and example_dialog:
		_set_editor_display()

func set_related_text() -> void:
	var p = get_parent()
	var p2 = p.get_parent()
	if !p || !p2: return
	var t = p2.get_child(p.get_index() - 1)
	if t is DialogText:
		example_dialog.set_dialog_text(t)
		example_dialog.content.visible_characters = -1

func _set_editor_display() -> void:
	var p = get_parent()
	if p is DialogChoice:
		set_related_text()
		if p.dialog_branches.size() < 2: return
		example_dialog.set_dialog_choice(p as DialogChoice)
