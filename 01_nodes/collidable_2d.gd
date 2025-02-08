class_name Collidable2D extends CollisionShape2D

func get_collision_size() -> Vector2:
	if shape is RectangleShape2D:
		return shape.size * scale
	if shape is CircleShape2D:
		var d = shape.radius * 2 * scale.x
		return Vector2(d, d)
	if shape is CapsuleShape2D:
		return Vector2(shape.radius * 2 * scale.x, shape.height * scale.y)
	return Vector2.ZERO
