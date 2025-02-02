class_name StateAttack extends State
var attacking: bool = false
@export var attack_sound: AudioStream
# Min, Max, Increment Size
@export_range(1, 20, 0.5) var decelerate_speed: float = 5.0
@onready var walk: State = $"../Walk"
@onready var idle: StateIdle = $"../Idle"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box: HurtBox = %AttackHurtBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# What happens when the player enters this state?
func Enter() -> void:
	player.UpdateAnimation("attack")
	attack_anim.play("attack_" + player.AnimDireciton())
	animation_player.animation_finished.connect(EndAttack)
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	attacking = true
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurt_box.monitoring = true
	pass

# What happens when the player exits this state?
func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	hurt_box.monitoring = false
	pass

# What happens during the _process update in this State?
func Process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	if !attacking:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> State:
	return null

# What happens with input events in this State?
func HandleInput(_event: InputEvent) -> State:
	return null

func EndAttack(_newAnimName: String) -> void:
	attacking = false
