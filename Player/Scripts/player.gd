class_name Player extends CharacterBody2D
signal DirectionChanged(new_direction: Vector2)
signal PlayerDamaged(hurtbox: HurtBox)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hit_box: HitBox = $HitBox

var cardinal_direction: Vector2 = Vector2.DOWN
const DIR_4: Array = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var direction: Vector2 = Vector2.ZERO # A Vector2 contains 2 numbers, and x and a y
var invulnerable: bool = false
var hp: int = 6
var max_hp: int = 6

func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect(TakeDamage)
	UpdateHp(99)

func _process(_delta: float) -> void:
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()

func _physics_process(_delta: float) -> void:
	move_and_slide() # This function already handles frame-rate independent movement, thus, we do not need to multiply our values by delta.

func SetDirection() -> bool:
	if direction == Vector2.ZERO: return false
	var direction_id: int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_direction: Vector2 = DIR_4[direction_id]

	# If direction hasn't changed, just escape without changing direction
	if new_direction == cardinal_direction: return false
	
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

func TakeDamage(hurtbox: HurtBox) -> void:
	if invulnerable: return
	UpdateHp(-hurtbox.damage)
	PlayerDamaged.emit(hurtbox)
	if hp <= 0: UpdateHp(99)

func UpdateHp(change: int) -> void:
	hp = clampi(hp + change, 0, max_hp)

func MakeInvulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true
