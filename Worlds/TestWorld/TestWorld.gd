extends Node2D

var level_seed: int = 0

# In another script that controls level generation:
@onready var tilemap = $TileMap  # Reference to your TileMap node

var is_level_completed = false

func _ready():
	level_seed = Global.current_level_seed

	var tilemap_size := calculate_level_map_size(level_seed)
	var distance := calculate_level_distance(level_seed)
	
	var points = generate_points_with_distance(tilemap_size, tilemap_size, distance)
	var start = points[0]
	var end = points[1]
	
	tilemap.map_width = tilemap_size
	tilemap.map_height = tilemap_size
	tilemap.fill_percent += randf_range(-5, 5) # Add some randomness to the map generation
	tilemap.generate_level(start, end)
	
	$Rocket.global_position = tilemap.map_to_local(start)
	
	$LevelEndArea.global_position = tilemap.map_to_local(end)



func generate_points_with_distance(map_width: int, map_height: int, distance: int) -> Array:
	# Get the center of the map (using integer division)
	var center = Vector2i(map_width / 2, map_height / 2)
	
	# Generate random angle for the first point (in radians)
	var angle1 = randf() * 2.0 * PI
	
	# The first point will be on a circle with radius = distance/2 from center
	# We round the results to get integer coordinates
	var radius = distance / 2.0
	var point1 = Vector2i(
		center.x + roundi(radius * cos(angle1)),
		center.y + roundi(radius * sin(angle1))
	)
	
	# Second point will be exactly opposite to maintain the distance
	var angle2 = angle1 + PI
	var point2 = Vector2i(
		center.x + roundi(radius * cos(angle2)),
		center.y + roundi(radius * sin(angle2))
	)
	
	# Clamp points to ensure they're within map boundaries
	point1.x = clampi(point1.x, 0, map_width - 1)
	point1.y = clampi(point1.y, 0, map_height - 1)
	point2.x = clampi(point2.x, 0, map_width - 1)
	point2.y = clampi(point2.y, 0, map_height - 1)
	
	return [point1, point2]


func _on_level_end_area_body_entered(body):
	if body in get_tree().get_nodes_in_group("players"):
		is_level_completed = true
		print("Completed level.")
		
		$UI.show_level_complete_menu(true)
		# increase it only if the curent level which is completed is the last level of the world
		print (Global.current_level_seed)
		print("and")
		print(Global.data[Global.current_world.resource_name])
		if Global.current_level_seed == Global.data[Global.current_world.resource_name]:
			Global.data[Global.current_world.resource_name] += 1
		Global.save_savegame()




# Function to calcualt the size of generated map based on seed difficulty.
func calculate_level_map_size(_level_seed: int) -> int:
	var fseed := float(_level_seed)
	# Now increase the size of map by 5% per seed increase
	var map_size = 32 + (fseed * 1)
	return map_size


# Calculate distance as well based on seed difficulty.
func calculate_level_distance(_level_seed: int) -> int:
	var fseed := float(_level_seed)
	# Now increase the distance of map by 5% per seed increase
	var distance = 28 + (fseed * 1)
	return distance
