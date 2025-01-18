extends TileMap

# Configuration parameters
@export var fill_percent := 45  # Initial random fill percentage
@export var smoothing_iterations := 4  # How many times to smooth the cave
@export var min_cave_size := 50  # Minimum size of cave regions to keep
@export var room_radius := 4  # Radius of open spaces around start/end

# Map settings
@export var map_width := 32
@export var map_height := 32
@export var max_generation_attempts := 16  # Maximum attempts to generate a valid map

# Tile IDs
const WALL_TILE := 0
const EMPTY := -1

var _map := {}  # Dictionary to store our map data
var _start_point: Vector2
var _end_point: Vector2

func generate_level(start: Vector2, end: Vector2) -> void:
	_start_point = start
	_end_point = end
	
	var attempt := 0
	var valid_map := false
	
	while !valid_map and attempt < max_generation_attempts:
		attempt += 1
		
		# Clear existing tiles
		clear()
		_map.clear()
		
		# Generate a new map
		_initialize_map(attempt)  # Pass attempt as seed
		
		# Smooth the map multiple times using cellular automata
		for i in smoothing_iterations:
			_smooth_map()
		
		# Create rooms at start and end points
		_create_room(_start_point, room_radius)
		_create_room(_end_point, room_radius)
		
		# Validate path existence
		valid_map = _check_path_exists()
	
	if !valid_map:
		push_error("Failed to generate a valid map after %d attempts" % max_generation_attempts)
	
	# Apply the final map to tilemap
	_apply_to_tilemap()

func _initialize_map(seed_value: int) -> void:
	seed(seed_value)  # Set the random seed for reproducibility
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2(x, y)
			# Fill edges with walls
			if x == 0 || x == map_width - 1 || y == 0 || y == map_height - 1:
				_map[pos] = true
			else:
				_map[pos] = randf() * 100 < fill_percent

func _smooth_map() -> void:
	var new_map := {}
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2(x, y)
			var wall_count := _get_surrounding_wall_count(pos)
			
			# Apply cellular automata rules
			if wall_count > 4:
				new_map[pos] = true
			elif wall_count < 4:
				new_map[pos] = false
			else:
				new_map[pos] = _map[pos]
	
	_map = new_map

func _get_surrounding_wall_count(pos: Vector2) -> int:
	var wall_count := 0
	for x in range(-1, 2):
		for y in range(-1, 2):
			var check_pos := Vector2(pos.x + x, pos.y + y)
			if check_pos != pos:
				if _map.get(check_pos, true):  # Default to wall if outside bounds
					wall_count += 1
	return wall_count

func _create_room(center: Vector2, radius: int) -> void:
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			var pos := Vector2(center.x + x, center.y + y)
			if pos.x >= 0 && pos.x < map_width && pos.y >= 0 && pos.y < map_height:
				if Vector2(x, y).length() <= radius:
					_map[pos] = false

func _check_path_exists() -> bool:
	var astar := AStar2D.new()
	
	# Add all empty points to AStar
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2(x, y)
			if !_map[pos]:  # If it's an empty space
				var point_id := _get_point_id(pos)
				astar.add_point(point_id, pos)
	
	# Connect neighboring points
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2(x, y)
			if !_map[pos]:
				var point_id := _get_point_id(pos)
				
				# Connect to orthogonal neighbors
				for neighbor in [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]:
					var next_pos :Vector2 = pos + neighbor
					if _is_valid_empty_pos(next_pos):
						var next_id := _get_point_id(next_pos)
						if !astar.are_points_connected(point_id, next_id):
							astar.connect_points(point_id, next_id)
	
	# Check if path exists between start and end
	var start_id := _get_point_id(_start_point)
	var end_id := _get_point_id(_end_point)
	
	return astar.has_point(start_id) && astar.has_point(end_id) && \
		   astar.get_point_path(start_id, end_id).size() > 0

func _is_valid_empty_pos(pos: Vector2) -> bool:
	return pos.x >= 0 && pos.x < map_width && \
		   pos.y >= 0 && pos.y < map_height && \
		   !_map[pos]

func _get_point_id(pos: Vector2) -> int:
	return int(pos.x + pos.y * map_width)

func _apply_to_tilemap() -> void:
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2(x, y)
			if _map[pos]:
				set_cell(0, pos, 0, Vector2i(0, 0))  # Set wall tile
			else:
				set_cell(0, pos, -1)  # Clear tile (empty space)
