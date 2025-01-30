class_name StateWalk extends State

@export var move_speed: float = 100.0
@onready var idle: State = $"../Idle"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# What happens when the player enters this state?
func Enter() -> void:
	player.UpdateAnimation("walk")
	pass

# What happens when the player exits this state?
func Exit() -> void:
	pass

# What happens during the _process update in this State?
func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO: return idle
	player.velocity = player.direction * move_speed
	if player.SetDirection(): player.UpdateAnimation("walk")
	return null

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> State:
	return null

# What happens with input events in this State?
func HandleInput(_event: InputEvent) -> State:
	return null
