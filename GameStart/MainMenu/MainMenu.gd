extends Control

@export var world_selection_scene: PackedScene

func _on_button_pressed():
	SceneManager.switch_scene(
		SceneManager.load_scene(world_selection_scene.resource_path)
	)
