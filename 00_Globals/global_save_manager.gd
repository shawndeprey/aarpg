extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save: Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pas_y = 0
	},
	items = [],
	persistence = [],
	quests = [], # Example: {title = "not found", is_complete = false, completed_steps = ['']}
}

func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_item_data()
	update_quest_data()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()

func has_save() -> bool:
	return get_save_file() != null

func get_save_file() -> FileAccess:
	return FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)

func load_game() -> void:
	var file := get_save_file()
	var json = JSON.new()
	json.parse(file.get_line())
	var save_dict: Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	# Load the data into game
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	await LevelManager.level_load_started

	# Place data from file into game memory states
	PlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	PlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	PlayerManager.INVENTORY_DATA.set_save_date(current_save.items)
	QuestManager.current_quests = current_save.quests

	await LevelManager.level_loaded
	game_loaded.emit()

func update_player_data() -> void:
	var p: Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y

func update_scene_path() -> void:
	var p: String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p

func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()

func update_quest_data() -> void:
	current_save.quests = QuestManager.current_quests

func add_persistent_value(value: String) -> void:
	if !check_persistent_value(value):
		current_save.persistence.append(value)

func remove_persistent_value(value: String) -> void:
	var p = current_save.persistence as Array
	p.erase(value)

func check_persistent_value(value: String) -> bool:
	var p = current_save.persistence as Array
	return p.has(value)
