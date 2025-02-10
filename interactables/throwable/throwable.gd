class_name Throwable extends Area2D

@export var gravity_strength: float = 980.0
@export var throw_speed: float = 400.0
@export var throw_height_strength: float = 100.0
@export var throw_starting_height: float = 49.0

var picked_up: bool = false
var throwable: Node2D
var throw_direction: Vector2
var collidable: Collidable2D

var object_sprite: Sprite2D
var vertical_velocity: float = 0
var ground_height: float = 0
var animation_player: AnimationPlayer

@onready var hurt_box: HurtBox = $HurtBox

func _ready() -> void:
	throwable = get_parent()
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)
	setup_hurtbox()
	get_collidable(throwable)
	object_sprite = throwable.find_child("Sprite2D")
	ground_height = object_sprite.position.y
	animation_player = throwable.find_child("AnimationPlayer")
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	object_sprite.position.y += vertical_velocity * delta
	if object_sprite.position.y >= ground_height:
		destroy()
	vertical_velocity += gravity_strength * delta
	throwable.position += throw_direction * throw_speed * delta

func _on_area_enter(_a: Area2D) -> void:
	PlayerManager.interact_pressed.connect(player_interact)

func _on_area_exit(_a: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(player_interact)

func setup_hurtbox() -> void:
	hurt_box.monitoring = false
	for c in get_children():
		if c is CollisionShape2D:
			var col: CollisionShape2D = c.duplicate()
			hurt_box.add_child(col)
			col.debug_color = Color(1, 0, 0, 0.3)

func player_interact() -> void:
	if PlayerManager.interact_handled: return
	if !picked_up:
		picked_up = true
		PlayerManager.handle_interaction()
		collidable.set_deferred("disabled", true)
		if throwable.get_parent():
			throwable.get_parent().remove_child(throwable)
		PlayerManager.player.held_item.add_child(throwable)
		throwable.position = Vector2.ZERO
		PlayerManager.player.pickup_item(self)
		area_entered.disconnect(_on_area_enter)
		area_exited.disconnect(_on_area_exit)

func throw() -> void:
	throwable.get_parent().remove_child(throwable)
	PlayerManager.player.get_parent().call_deferred("add_child", throwable)
	throwable.position = PlayerManager.player.position
	object_sprite.position.y = -throw_starting_height
	vertical_velocity = -throw_height_strength
	set_physics_process(true)
	hurt_box.set_deferred("monitoring", true)
	hurt_box.did_damage.connect(destroy)

func drop() -> void:
	throwable.get_parent().remove_child(throwable)
	PlayerManager.player.get_parent().call_deferred("add_child", throwable)
	throwable.position = PlayerManager.player.position
	object_sprite.position.y = -50
	vertical_velocity = -200
	throw_speed = 100
	set_physics_process(true)
	# To make the object hurt enemies, use the following
	#hurt_box.set_deferred("monitoring", true)
	#hurt_box.did_damage.connect(destroy)

func destroy() -> void:
	set_physics_process(false)
	if animation_player:
		animation_player.play("destroy")
		await animation_player.animation_finished
	throwable.queue_free()

func enable_throwable() -> void:
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)
	picked_up = false
	throwable.position = PlayerManager.player.position
	var size = collidable.get_collision_size()
	if PlayerManager.player.cardinal_direction == Vector2.DOWN: throwable.position.y += size.y
	elif PlayerManager.player.cardinal_direction == Vector2.UP: throwable.position.y -= size.y
	elif PlayerManager.player.cardinal_direction == Vector2.LEFT: throwable.position.x -= size.x
	elif PlayerManager.player.cardinal_direction == Vector2.RIGHT: throwable.position.x += size.x
	collidable.set_deferred("disabled", false)

func get_collidable(node: Node) -> void:
	for c in node.get_children():
		if c == self: continue
		if c is Collidable2D:
			collidable = c
			break
		else:
			get_collidable(c)
