class_name State extends Node

# Stores a reference top the player that this State belongs to
static var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# What happens when the player enters this state?
func Enter() -> void:
	pass

# What happens when the player exits this state?
func Exit() -> void:
	pass

# What happens during the _process update in this State?
func Process(_delta: float) -> State:
	return null

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> State:
	return null

# What happens with input events in this State?
func HandleInput(_event: InputEvent) -> State:
	return null
