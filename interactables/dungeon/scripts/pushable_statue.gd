class_name PushableStatue extends RigidBody2D

@export var push_speed: float = 30.0
@export var persistent: bool = false
@export var persistent_location: Vector2

var push_direction: Vector2 = Vector2.ZERO : set = _set_push

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var on_target: PersistentDataHandeler = $OnTarget


func _ready() -> void:
	if persistent:
		on_target.get_value()
		if on_target.value:
			position = persistent_location
	pass

func _physics_process(_delta: float) -> void:
	linear_velocity = push_direction * push_speed

func persistence_trigger() -> void:
	if !persistent or on_target.value: return
	if global_position.distance_to(persistent_location) < 20:
		on_target.set_value()

func persistence_untrigger() -> void:
	on_target.remove_value()

func _set_push(value: Vector2) -> void:
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()


func _on_pressure_plate_deactivated() -> void:
	pass # Replace with function body.
