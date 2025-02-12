class_name NotificationUI extends Control

var notification_queue: Array

@onready var panel_container: PanelContainer = $PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var title_label: Label = $PanelContainer/VBoxContainer/TitleLabel
@onready var message_label: Label = $PanelContainer/VBoxContainer/MessageLabel

func _ready() -> void:
	panel_container.visible = false
	animation_player.animation_finished.connect(notification_animation_finished)

func add_notification_to_queue(title: String, message: String) -> void:
	notification_queue.append({title = title, message = message})
	if !animation_player.is_playing():
		display_notification()

func display_notification() -> void:
	var n = notification_queue.pop_front()
	if n == null: return
	title_label.text = n.title
	message_label.text = n.message
	animation_player.play("show_notification")

func notification_animation_finished(_a: String) -> void:
	display_notification()
