class_name StateIdle extends State
@onready var walk: State = $"../Walk"
@onready var attack: StateAttack = $"../Attack"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# What happens when the player enters this state?
func Enter() -> void:
	player.UpdateAnimation("idle")
	pass

# What happens when the player exits this state?
func Exit() -> void:
	pass

# What happens during the _process update in this State?
func Process(_delta: float) -> State:
	if player.direction != Vector2.ZERO: return walk
	player.velocity = Vector2.ZERO
	return null

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> State:
	return null

# What happens with input events in this State?
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"): return attack
	return null
