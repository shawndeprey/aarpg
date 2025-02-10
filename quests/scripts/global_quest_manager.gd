# QUEST MANAGER - GLOBAL SCRIPT
extends Node
signal quest_updated(q)

const QUEST_DATA_LOCATION: String = "res://quests/"

var quests: Array[Quest]
var current_quests: Array = [] # Example: {title = "not found", is_complete = false, completed_steps = ['']}

func _ready() -> void:
	gather_quest_data()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		#print(find_quest(load("res://quests/recover_lost_flute.tres") as Quest))
		#print(find_quest_by_title("Short Quest"))
		#print(get_quest_index_by_title("Recover Lost Magical Flute"))
		#print(get_quest_index_by_title("Short Quest"))
		#print("Before: ", current_quests)
		update_quest("Recover Lost Magical Flute", "")
		update_quest("Recover Lost Magical Flute", "Find the Magical Flute", true)
		update_quest("Short Quest")
		update_quest("Long Quest", "")
		update_quest("Long Quest", "Step 1")
		update_quest("Long Quest", "Step 2")
		print("Quests: ", current_quests)
		#print("------------------------------------------------------")
		pass

# Gather all quest resources and add to quests array
func gather_quest_data() -> void:
	
	var quest_files: PackedStringArray = DirAccess.get_files_at(QUEST_DATA_LOCATION)
	quests.clear()
	for q in quest_files:
		quests.append(load(QUEST_DATA_LOCATION + "/" + q) as Quest)
	print("Quest Count: ", quests.size())
	pass

# Updates the status of a quest
func update_quest(title: String, completed_step: String = "", is_complete: bool = false) -> void:
	var quest_index: int = get_quest_index_by_title(title)
	if quest_index == -1:
		# Quest wasn't found - add it to the current quests array
		var new_quest: Dictionary = {title = title, is_complete = is_complete, completed_steps = []}
		if completed_step != "":
			new_quest.completed_steps.append(completed_step)
		current_quests.append(new_quest)
		quest_updated.emit(new_quest)
		# Display a notification that quest was added
	else:
		var q = current_quests[quest_index]
		if completed_step != "" and !q.completed_steps.has(completed_step):
			q.completed_steps.append(completed_step)
		q.is_complete = is_complete
		quest_updated.emit(q)
		# Display a notification that quest was updated OR completed
		if q.is_complete:
			disperse_quest_rewards(find_quest_by_title(title))

# Give XP and item rewards to player
func disperse_quest_rewards(_q: Quest) -> void:
	PlayerManager.reward_xp(_q.reward_xp)
	for i in _q.reward_items:
		PlayerManager.INVENTORY_DATA.add_item(i.item, i.quantity)
	pass

# Provide a quest and return the current quest associated with it
func find_quest(quest: Quest) -> Dictionary:
	for q in current_quests:
		if q.title.to_lower() == quest.title.to_lower(): return q
	return {title = "not found", is_complete = false, completed_steps = ['']}

# Take title and find associated Quest resource
func find_quest_by_title(title: String) -> Quest:
	for q in quests:
		if q.title.to_lower() == title.to_lower():
			return q
	return null

# Find current quest by title name, and return index in current_quests array
func get_quest_index_by_title(title: String) -> int:
	for i in current_quests.size():
		if current_quests[i].title.to_lower() == title.to_lower(): return i
	return -1

func sort_quests() -> void:
	var active_quests: Array = []
	var completed_quests: Array = []
	for q in current_quests:
		if q.is_complete:
			completed_quests.append(q)
		else:
			active_quests.append(q)
	active_quests.sort_custom(sort_quests_ascending)
	completed_quests.sort_custom(sort_quests_ascending)
	current_quests = active_quests
	current_quests.append_array(completed_quests)

func sort_quests_ascending(a, b) -> bool:
	return a.title < b.title
		
