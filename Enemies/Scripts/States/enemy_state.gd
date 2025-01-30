class_name EnemyState extends Node

# Store a reference to the enemy and that this state belongs to
var enemy: Enemy
var state_machine: EnemyStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# What happens when we initialize this state?
func Init() -> void:
	pass

# What happens when the player enters this state?
func Enter() -> void:
	pass

# What happens when the player exits this state?
func Exit() -> void:
	pass

# What happens during the _process update in this State?
func Process(_delta: float) -> EnemyState:
	return null

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> EnemyState:
	return null
