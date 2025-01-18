extends Node2D

var level_seed: int = 0

# In another script that controls level generation:
@onready var tilemap = $TileMap  # Reference to your TileMap node

var is_level_completed = false

func _ready():
	level_seed = Global.current_level_seed
	
	var points = generate_points_with_distance(tilemap.map_width, tilemap.map_height, 28)
	var start = points[0]
	var end = points[1]
	
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
		
		#$UI/InGameMenu.visible = true
