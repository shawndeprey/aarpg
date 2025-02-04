@tool
class_name NPCBehaviorPatrol extends NPCBehavior

const COLORS = [Color(1,0,0), Color(1,1,0), Color(0,1,0), Color(0,1,1), Color(0,0,1), Color(1,0,1)]

@export var walk_speed: float = 30.0

var patrol_locations: Array[PatrolLocation]
var current_location_index: int = 0
var target: PatrolLocation

func _ready() -> void:
	gather_patrol_locations()
	if Engine.is_editor_hint():
		child_entered_tree.connect(gather_patrol_locations)
		child_order_changed.connect(gather_patrol_locations)
		return
	super()
	if patrol_locations.size() == 0:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	target = patrol_locations[0]

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	if npc.global_position.distance_to(target.target_position) < 1:
		start()

func gather_patrol_locations(_node: Node = null) -> void:
	patrol_locations = []
	for c in get_children():
		if c is PatrolLocation:
			#if !Engine.is_editor_hint():
				#c.visible = false
			patrol_locations.append(c)
	
	if Engine.is_editor_hint() and patrol_locations.size() > 0:
		for i in patrol_locations.size():
			var _p = patrol_locations[i] as PatrolLocation
			if !_p.transformed_changed.is_connected(gather_patrol_locations):
				_p.transformed_changed.connect(gather_patrol_locations)
			_p.update_label(str(i))
			_p.modulate = _get_color_by_index(i)
			var _next: PatrolLocation
			if i < patrol_locations.size() - 1:
				_next = patrol_locations[i + 1]
			else:
				_next = patrol_locations[0]
			_p.update_line(_next.position)

func start() -> void:
	if !npc.do_behavior or patrol_locations.size() < 2: return
	
	# Idle Phase
	npc.global_position = target.target_position
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	var wait_time: float = target.wait_time
	current_location_index += 1
	if current_location_index >= patrol_locations.size():
		current_location_index = 0
	target = patrol_locations[current_location_index]
	await get_tree().create_timer(wait_time).timeout
	
	# Walk Phase
	if !npc.do_behavior: return
	npc.state = "walk"
	var _dir = global_position.direction_to(target.target_position)
	npc.direction = _dir
	npc.velocity = walk_speed * _dir
	npc.update_direction(target.target_position)
	npc.update_animation()

func _get_color_by_index(i: int) -> Color:
	var color_count: int = COLORS.size()
	while i > color_count - 1:
		i -= color_count
	return COLORS[i]
