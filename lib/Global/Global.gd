extends Node

var current_world: PackedScene
var current_level_seed: int = 0

var data: Dictionary = {
	# "world1": 1, # which level is we on in this world
	# "world2": 1, # which level is we on in this world
}



# Save global data to a file
var save_path = "user://rocketescape.sav"

func save_savegame():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)


func load_savegame():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		data = file.get_var()
	else:
		print("file not found")
		data = {}


func _ready():
	load_savegame()


func _exit_tree():
	save_savegame()
