class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO # A Vector2 contains 2 numbers, and x and a y

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

signal DirectionChanged(new_direction: Vector2)

func _ready() -> void:
	state_machine.Initialize(self)

func _process(_delta: float) -> void:
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()

func _physics_process(_delta: float) -> void:
	move_and_slide() # This function already handles frame-rate independent movement, thus, we do not need to multiply our values by delta.

func SetDirection() -> bool:
	# Determine new direction based on previous physics input operation
	var new_direction: Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN

	# If direction hasn't changed, just escape without changing direction
	if new_direction == cardinal_direction:
		return false
	
	# Update new direction and change sprite scale(horizontal flip) based on current direction
	cardinal_direction = new_direction
	sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	DirectionChanged.emit(cardinal_direction)
	return true

func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimDireciton())

func AnimDireciton() -> String:
	if cardinal_direction == Vector2.DOWN: return "down"
	elif cardinal_direction == Vector2.UP: return "up"
	else: return "side"
