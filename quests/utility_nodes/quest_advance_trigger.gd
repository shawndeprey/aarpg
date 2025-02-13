@tool
@icon("res://quests/utility_nodes/icons/quest_advance.png")
class_name QuestAdvanceTrigger extends QuestNode

@export_category("Signal Parent Connection")
@export var signal_name: String = ""

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if has_node("Sprite2D"): $Sprite2D.queue_free()
	if signal_name != "" and get_parent().has_signal(signal_name):
		print("Set Signal: ", signal_name)
		get_parent().connect(signal_name, advance_quest)

func advance_quest() -> void:
	if linked_quest == null: return
	await get_tree().process_frame
	await get_tree().process_frame
	var title: String = linked_quest.title
	var step: String = get_step()
	if step == "N/A": step = ""
	print("advance_quest: ", title, " - ", step, " - ", quest_complete)
	QuestManager.update_quest(title, step, quest_complete)
