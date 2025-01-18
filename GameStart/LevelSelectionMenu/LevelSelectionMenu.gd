extends Control


@export var grid_container: GridContainer
@export var card_scene: PackedScene


const ATLEAST_LEVELS_COUNT = 6 * 6


func _ready():

	# Based on Global.data["world1"], set only those number of cards as unlocked
	# and additional 8 more cards as locked

	var unlocked_levels_count = Global.data[Global.current_world.resource_name]
	var locked_levels_count = ATLEAST_LEVELS_COUNT - unlocked_levels_count

	 # If nothing is unlocked, themn unlock one
	if unlocked_levels_count < 1:
		unlocked_levels_count += 1

	for i in range(unlocked_levels_count):
		var card = card_scene.instantiate()
		card.set_level_locked(false)
		card.set_level_seed(i + 1)
		grid_container.add_child(card)
	
	for i in range(locked_levels_count):
		var card = card_scene.instantiate()
		card.set_level_locked(true)
		card.set_level_seed(i + 1)
		grid_container.add_child(card)
	
