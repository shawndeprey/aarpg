@tool
class_name TreasureChest extends Node2D
@export var item_data: ItemData : set = _set_item_data
@export var quantity: int : set = _set_quantity

@onready var sprite: Sprite2D = $ItemSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D
@onready var label: Label = $ItemSprite/Label


var is_open: bool = false

func _ready() -> void:
	_update_texture()
	_update_label()
	if Engine.is_editor_hint(): return
	interact_area.area_entered.connect(_on_area_enter)
	interact_area.area_exited.connect(_on_area_exit)

func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()

func _set_quantity(value: int) -> void:
	quantity = value
	_update_label()

func _update_texture() -> void:
	if item_data and sprite:
		sprite.texture = item_data.texture

func _update_label() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = "x" + str(quantity)

func player_interact() -> void:
	if is_open: return
	is_open = true
	animation_player.play("open_chest")
	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item(item_data, quantity)
	else:
		printerr("No items in chest!")
		push_error("No items in chest! Chest Name: ", name)

func _on_area_enter(_a: Area2D) -> void:
	PlayerManager.interact_pressed.connect(player_interact)

func _on_area_exit(_a: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(player_interact)
