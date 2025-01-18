extends Control

@export var level_seed: int = 0
@export var is_level_locked: bool = false

func set_level_seed(_level_seed: int):
	self.level_seed = _level_seed
	if not is_level_locked:
		$Label.text = str(_level_seed)


func set_level_locked(b: bool):
	self.is_level_locked = b
	if is_level_locked:
		$Label.text = "!"

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if is_level_locked:
				print("Level is locked")
			else:
				print("Level is unlocked")
				
				var world_scene = SceneManager.load_scene(Global.current_world.resource_path)
				Global.current_level_seed = level_seed
				SceneManager.switch_scene(world_scene)
