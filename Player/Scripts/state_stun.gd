class_name StateStun extends State

@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export var invulnerable_duration: float = 1.0

@onready var idle: State = $"../Idle"

var hurtbox: HurtBox
var direction: Vector2

var next_state: State = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# What happens when the player enters this state?
func Init() -> void:
	player.PlayerDamaged.connect(PlayerDamaged)

# What happens when the player enters this state?
func Enter() -> void:
	player.animation_player.animation_finished.connect(AnimationFinished)
	direction = player.global_position.direction_to(hurtbox.global_position)
	player.velocity = direction * - knockback_speed
	player.SetDirection()
	player.UpdateAnimation("stun")
	player.MakeInvulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")

# What happens when the player exits this state?
func Exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(AnimationFinished)

# What happens during the _process update in this State?
func Process(delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * delta
	return next_state

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> State:
	return null

# What happens with input events in this State?
func HandleInput(_event: InputEvent) -> State:
	return null

func PlayerDamaged(_hurtbox: HurtBox) -> void:
	hurtbox = _hurtbox
	state_machine.ChangeState(self)

func AnimationFinished(_a: String) -> void:
	next_state = idle
