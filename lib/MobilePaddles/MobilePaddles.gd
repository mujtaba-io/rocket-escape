# MobilePaddles.gd
extends Node

@export var left_paddle: TouchScreenButton
@export var right_paddle: TouchScreenButton

@export var left_action: String = "ui_left"
@export var right_action: String = "ui_right"

func _ready():
	# In the editor or via code
	left_paddle.visibility_mode = TouchScreenButton.VISIBILITY_ALWAYS
	left_paddle.passby_press = true  # Allows sliding touches
	# In the editor or via code
	right_paddle.visibility_mode = TouchScreenButton.VISIBILITY_ALWAYS
	right_paddle.passby_press = true  # Allows sliding touches

	if not OS.has_feature("mobile"):
		queue_free()


func _on_left_paddle_pressed():
	# Simulate input action press
	Input.action_press(left_action)

func _on_left_paddle_released():
	# Simulate input action release
	Input.action_release(left_action)

func _on_right_paddle_pressed():
	Input.action_press(right_action)

func _on_right_paddle_released():
	Input.action_release(right_action)
