class_name EnemyStateDestroy extends EnemyState

const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

@export var anim_name: String = "destroy"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category("Item Drops")
@export var drops: Array[DropData]

var _direction: Vector2
var _damage_position: Vector2

# What happens when we initialize this state?
func Init() -> void:
	enemy.enemy_destroyed.connect(OnEnemyDestroyed)
	pass

# What happens when the player enters this state?
func Enter() -> void:
	enemy.invulderable = true
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.SetDirection(_direction)
	enemy.velocity = _direction * -knockback_speed
	enemy.UpdateAnimation(anim_name)
	enemy.animation_player.animation_finished.connect(OnAnimationFInished)
	disable_hurtbox()
	drop_items()

# What happens when the player exits this state?
func Exit() -> void:
	enemy.invulderable = false
	#enemy.animation_player.animation_finished.disconnect(OnAnimationFInished)

# What happens during the _process update in this State?
func Process(delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * delta
	return null

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> EnemyState:
	return null

func OnEnemyDestroyed(hurtbox: HurtBox) -> void:
	_damage_position = hurtbox.global_position
	state_machine.ChangeState(self)

func OnAnimationFInished(_a: String) -> void:
	enemy.queue_free()

func disable_hurtbox() -> void:
	var hurtbox: HurtBox = enemy.get_node_or_null("HurtBox")
	if hurtbox:
		hurtbox.monitoring = false

func drop_items() -> void:
	if drops.size() == 0: return
	for i in drops.size():
		if drops[i] == null or drops[i].item == null: continue
		var drop_count: int = drops[i].get_drop_count()
		for j in drop_count:
			var drop: ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[i].item
			enemy.get_parent().call_deferred("add_child", drop)
			# Sets the drop to where the enemy is and gives it a random velocity away from the enemy pos.
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5)
