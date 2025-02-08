class_name Plant extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitBox.damaged.connect(TakeDamage)
	pass # Replace with function body.

func TakeDamage(_hurtbox: HurtBox) -> void:
	queue_free()
