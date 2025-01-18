extends CanvasLayer


func _ready():
	add_to_group("ui")
	show_level_complete_menu(false)
	show_pause_menu(false)
	
	process_mode = Node.PROCESS_MODE_ALWAYS


func set_health(health: float) -> void:
	$Control/HealthBar.value = health


func set_fuel(fuel: float) -> void:
	$Control/FuelBar.value = fuel


func set_timer(t: String):
	$Control/TimeLeftLabel.text = t


func show_level_complete_menu(b: bool):
	$Control/LevelCompleteMenu.visible = b



func pause_game():
	get_tree().paused = true
	show_pause_menu(true)


func resume_game():
	get_tree().paused = false
	show_pause_menu(false)


func show_pause_menu(b: bool):
	$Control/PauseMenu.visible = b


func _on_pause_pressed():
	pause_game()
