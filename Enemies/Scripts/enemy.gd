class_name Enemy extends CharacterBody2D
signal direction_changed(new_direction: Vector2)
signal enemy_damaged(hurtbox: HurtBox)
signal enemy_destroyed(hurtbox: HurtBox)
const DIR_4: Array = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp: int = 3

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player
var invulderable: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: HitBox = $HitBox
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.Initialize(self)
	player = PlayerManager.player
	hitbox.damaged.connect(TakeDamage)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func SetDirection(new_direction: Vector2) -> bool:
	direction = new_direction
	if direction == Vector2.ZERO: return false
	var direction_id: int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_dir: Vector2 = DIR_4[direction_id]

	# If direction hasn't changed, just escape without changing direction
	if new_dir == cardinal_direction: return false
	
	# Update new direction and change sprite scale(horizontal flip) based on current direction
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimDireciton())

func AnimDireciton() -> String:
	if cardinal_direction == Vector2.DOWN: return "down"
	elif cardinal_direction == Vector2.UP: return "up"
	else: return "side"

func TakeDamage(hurtbox: HurtBox) -> void:
	if invulderable: return
	hp -= hurtbox.damage
	if hp > 0:
		enemy_damaged.emit(hurtbox)
	else:
		enemy_destroyed.emit(hurtbox)
