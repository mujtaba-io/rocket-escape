extends Button

@export var world_scene: PackedScene
@export var level_select_scene: PackedScene


func _ready():
	# Add this world to the Global data
	if not Global.data.has(world_scene.resource_name):
		Global.data[world_scene.resource_name] = 0


func _on_pressed():
	var level_select_scene = SceneManager.load_scene(level_select_scene.resource_path)
	Global.current_world = world_scene
	SceneManager.switch_scene(level_select_scene)
