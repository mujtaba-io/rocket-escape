extends Control

func _on_resume_button_pressed():
	var ui = get_tree().get_nodes_in_group("ui")[0]
	ui.resume_game()


func _on_restart_button_pressed():
	var ui = get_tree().get_nodes_in_group("ui")[0]
	ui.resume_game() # Resume game before doing any more shit
	
	var world_scene = SceneManager.load_scene(Global.current_world.resource_path)
	SceneManager.switch_scene(world_scene)


func _on_main_menu_button_pressed():
	var ui = get_tree().get_nodes_in_group("ui")[0]
	ui.resume_game() # Resume game before doing any more shit
	
	var main_menu = SceneManager.load_scene("res://GameStart/MainMenu/MainMenu.tscn")
	SceneManager.switch_scene(main_menu)
