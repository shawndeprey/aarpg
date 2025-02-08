class_name Player extends CharacterBody2D
signal DirectionChanged(new_direction: Vector2)
signal PlayerDamaged(hurtbox: HurtBox)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hit_box: HitBox = $HitBox
@onready var audio: AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D
@onready var lift: StateLift = $StateMachine/Lift
@onready var carry: StateCarry = $StateMachine/Carry
@onready var held_item: Node2D = $Sprite2D/HeldItem

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
	update_hp(99)

func _process(_delta: float) -> void:
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()

func _physics_process(_delta: float) -> void:
	move_and_slide() # This function already handles frame-rate independent movement, thus, we do not need to multiply our values by delta.

func _unhandled_input(_event: InputEvent) -> void:
	#if event.is_action_pressed("test"):
		#PlayerManager.shake_camera()
	pass

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
	if hp > 0:
		update_hp(-hurtbox.damage)
		PlayerDamaged.emit(hurtbox)

func update_hp(change: int) -> void:
	hp = clampi(hp + change, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp)

func MakeInvulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true

func pickup_item(t: Throwable) -> void:
	state_machine.ChangeState(lift)
	carry.throwable = t

func lower_item() -> void:
	for c in held_item.get_children():
		if c != Sprite2D:
			held_item.remove_child(c)
			PlayerManager.player.get_parent().call_deferred("add_child", c)
			c.position = PlayerManager.player.position
			var offset = 20
			if cardinal_direction == Vector2.DOWN: c.position.y += offset
			elif cardinal_direction == Vector2.UP: c.position.y -= offset
			elif cardinal_direction == Vector2.LEFT: c.position.x -= offset
			elif cardinal_direction == Vector2.RIGHT: c.position.x += offset
			enable_lowered_throwable(c)

func enable_lowered_throwable(node: Node) -> void:
	for c in node.get_children():
		if c.name == "Throwable":
			c.enable_throwable()

func revive_player() -> void:
	update_hp(99)
	state_machine.ChangeState($StateMachine/Idle)

func is_dead() -> bool:
	return hp <= 0
