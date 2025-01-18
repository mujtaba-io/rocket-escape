extends Control


@export var label: Label
@export var main_menu_scene: PackedScene


func _on_go_to_main_menu_button_pressed():
	var main_menu = SceneManager.load_scene(main_menu_scene.resource_path)
	SceneManager.switch_scene(main_menu)


func _on_retry_button_pressed():
	var world_scene = SceneManager.load_scene(Global.current_world.resource_path)
	SceneManager.switch_scene(world_scene)


func _on_go_to_next_level_button_pressed():
	pass
