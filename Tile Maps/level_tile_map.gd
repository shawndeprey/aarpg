class_name LevelTileMap extends TileMapLayer

@export var tile_size: float = 32
@export var skip_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if skip_ready: return
	LevelManager.change_tilemap_bounds(get_tilemap_bounds())

func get_tilemap_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	bounds.append(Vector2(get_used_rect().position * tile_size))
	bounds.append(Vector2(get_used_rect().end * tile_size))
	return bounds
