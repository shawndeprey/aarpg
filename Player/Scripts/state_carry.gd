class_name StateCarry extends State

@export var move_speed: float = 100.0
@export var throw_audio: AudioStream

var walking: bool = false
var throwable: Throwable

@onready var idle: StateIdle = $"../Idle"
@onready var stun: StateStun = $"../Stun"

# What happens when the player inits this state?
func Init() -> void:
	pass

# What happens when the player enters this state?
func Enter() -> void:
	player.UpdateAnimation("carry")
	walking = false

# What happens when the player exits this state?
func Exit() -> void:
	if throwable:
		throwable.throw_direction = player.direction if player.direction != Vector2.ZERO else player.cardinal_direction
		if state_machine.next_state == stun:
			throwable.throw_direction = throwable.throw_direction.rotated(PI)
			throwable.drop()
		else:
			player.audio.stream = throw_audio
			player.audio.play()
			throwable.throw()

# What happens during the _process update in this State?
func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.UpdateAnimation("carry")
	elif player.SetDirection() or !walking:
		walking = true
		player.UpdateAnimation("carry_walk")
	player.velocity = player.direction * move_speed
	return null

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> State:
	return null

# What happens with input events in this State?
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack") or _event.is_action_pressed("interact"):
		return idle
	return null
