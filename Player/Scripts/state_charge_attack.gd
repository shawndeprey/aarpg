class_name StateChargeAttack extends State

@export var charge_duration: float = 1.0
@export var move_speed: float = 80.0
@export var sfx_charged: AudioStream
@export var sfx_spin: AudioStream

var timer: float = 0.0
var walking: bool = false
var is_attacking: bool = false
var particles: ParticleProcessMaterial

@onready var idle: StateIdle = $"../Idle"
@onready var charge_hurt_box: HurtBox = %ChargeHurtBox
@onready var charge_spin_hurt_box: HurtBox = %ChargeSpinHurtBox
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var spin_sprite: Sprite2D = $"../../Sprite2D/SpinSprite"
@onready var spin_animation_player: AnimationPlayer = $"../../Sprite2D/SpinSprite/AnimationPlayer"
@onready var gpu_particles: GPUParticles2D = $"../../Sprite2D/ChargeHurtBox/GPUParticles2D"

# What happens when the player inits this state?
func Init() -> void:
	gpu_particles.emitting = false
	particles = gpu_particles.process_material as ParticleProcessMaterial

# What happens when the player enters this state?
func Enter() -> void:
	spin_sprite.visible = false
	timer = charge_duration
	is_attacking = false
	walking = false
	charge_hurt_box.monitoring = true
	charge_hurt_box.damage = 0
	gpu_particles.emitting = true
	gpu_particles.amount = 4
	gpu_particles.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30

# What happens when the player exits this state?
func Exit() -> void:
	spin_sprite.visible = false
	charge_hurt_box.monitoring = false
	charge_spin_hurt_box.monitoring = false
	gpu_particles.emitting = false

# What happens during the _process update in this State?
func Process(delta: float) -> State:
	if timer > 0:
		timer -= delta
		if timer <= 0:
			timer = 0
			charge_complete()
	# Detect Input for walking
	# Move player
	if is_attacking == false:
		if player.direction == Vector2.ZERO:
			walking = false
			player.UpdateAnimation("charge")
		elif player.SetDirection() or walking == false:
			walking = true
			player.UpdateAnimation("charge_walk")
	player.velocity = player.direction * move_speed
	return null

# What happens during the _physics_process update in this State?
func Physics(_delta: float) -> State:
	return null

# What happens with input events in this State?
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_released("attack"):
		if timer > 0:
			return idle
		elif is_attacking == false:
			charge_attack()
	
	return null

func charge_attack() -> void:
	is_attacking = true
	charge_spin_hurt_box.monitoring = true
	spin_sprite.visible = true
	spin_animation_player.play("spin")
	play_audio(sfx_spin)
	player.animation_player.play("charge_attack")
	player.animation_player.seek(get_spin_frame())
	var duration: float = player.animation_player.current_animation_length
	player.MakeInvulnerable(duration)
	await get_tree().create_timer(duration).timeout
	state_machine.ChangeState(idle)

func get_spin_frame() -> float:
	var interval: float = 0.05
	charge_hurt_box.damage = 0
	match player.cardinal_direction:
		Vector2.DOWN:
			return interval * 0
		Vector2.UP:
			return interval * 4
		_:
			return interval * 6

func charge_complete() -> void:
	play_audio(sfx_charged)
	gpu_particles.explosiveness = 1
	gpu_particles.amount = 50
	particles.initial_velocity_min = 50
	particles.initial_velocity_max = 100
	await get_tree().create_timer(0.2).timeout
	gpu_particles.amount = 30
	gpu_particles.explosiveness = 0
	particles.initial_velocity_min = 20
	particles.initial_velocity_max = 40

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream
	audio.play()
