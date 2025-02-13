class_name PersistentDataHandeler extends Node

signal data_loaded
var value: bool = false

func _ready() -> void:
	get_value()
	
func set_value() -> void:
	SaveManager.add_persistent_value(_get_name())

func remove_value() -> void:
	SaveManager.remove_persistent_value(_get_name())

func get_value() -> void:
	value = SaveManager.check_persistent_value(_get_name())
	data_loaded.emit()

func _get_name() -> String:
	# Example: "res://levels/area01/01.tscn/treasurechest/PersistentDataHandler"
	if get_tree() == null: return ""
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name 
