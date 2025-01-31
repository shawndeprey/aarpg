class_name EnemyStateStun extends EnemyState

@export var anim_name: String = "walk"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export_category("AI")
@export var next_state: EnemyState

var _direction: Vector2
var _animation_finished: bool = false
var _damage_position: Vector2

# What happens when we initialize this state?
func Init() -> void:
	enemy.enemy_damaged.connect(OnEnemyDamaged)
	pass

# What happens when the player enters this state?
func Enter() -> void:
	enemy.invulderable = true
	_animation_finished = false
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.SetDirection(_direction)
	enemy.velocity = _direction * -knockback_speed
	enemy.UpdateAnimation(anim_name)
	enemy.animation_player.animation_finished.connect(OnAnimationFInished)

# What happens when the player exits this state?
func Exit() -> void:
	enemy.invulderable = false
	enemy.animation_player.animation_finished.disconnect(OnAnimationFInished)

# What happens during the _process update in this State?
func Process(delta: float) -> EnemyState:
	if _animation_finished: return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * delta
	return null

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> EnemyState:
	return null

func OnEnemyDamaged(hurtbox: HurtBox) -> void:
	_damage_position = hurtbox.global_position
	state_machine.ChangeState(self)

func OnAnimationFInished(_a: String) -> void:
	_animation_finished = true
