class_name InventorySlotUI extends Button

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var slot_data: SlotData: set = set_slot_data

func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect(item_focus)
	focus_exited.connect(item_blur)

func set_slot_data(value: SlotData) -> void:
	slot_data = value
	if slot_data == null: return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)

func item_focus() -> void:
	if !slot_data or !slot_data.item_data: return
	PauseMenu.update_item_description(slot_data.item_data.description)

func item_blur() -> void:
	PauseMenu.update_item_description("")
