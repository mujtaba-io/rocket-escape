extends Node

# Time in seconds
@export var time_left = 60 * 3
var game_active = true

func _ready():
	# Start updating the timer
	update_timer_display()

func _process(delta):
	if game_active:
		# Subtract time only if game is active
		time_left -= delta
		
		# Update the timer display
		update_timer_display()
		
		# Check if time has run out
		if time_left <= 0:
			game_over()

func update_timer_display():
	# Convert seconds to minutes:seconds format
	var minutes = floor(time_left / 60)
	var seconds = int(time_left) % 60
	
	# Update the timer label
	var ui = get_tree().get_nodes_in_group("ui")[0]
	ui.set_timer("%02d:%02d" % [minutes, seconds])

func game_over():
	pass
