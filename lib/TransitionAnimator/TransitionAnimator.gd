# TransitionAnimator.gd
# Place this script in a autoload folder or anywhere accessible
extends Node
class_name TransitionAnimator

# Enum for different transition types
enum TransitionType {
	FADE,
	SLIDE_RIGHT,
	SLIDE_LEFT,
	SLIDE_UP,
	SLIDE_DOWN,
	SCALE,
	ROTATE
}

# Static method to show a node with animation
static func show_animated(
	node: Node,
	transition_type: TransitionType = TransitionType.FADE,
	duration: float = 0.5,
	delay: float = 0.0,
	ease_type: Tween.EaseType = Tween.EASE_OUT,
	callback: Callable = Callable()
) -> void:
	if not is_instance_valid(node):
		return
		
	# Make sure node is visible but fully transparent
	node.visible = true
	node.modulate.a = 0
	
	var tween = node.create_tween()
	tween.set_ease(ease_type)
	
	# Add delay if specified
	if delay > 0:
		tween.tween_interval(delay)
	
	match transition_type:
		TransitionType.FADE:
			tween.tween_property(node, "modulate:a", 1.0, duration)
			
		TransitionType.SLIDE_RIGHT:
			node.position.x -= 100
			tween.tween_property(node, "modulate:a", 1.0, duration)
			tween.parallel().tween_property(node, "position:x", node.position.x + 100, duration)
			
		TransitionType.SLIDE_LEFT:
			node.position.x += 100
			tween.tween_property(node, "modulate:a", 1.0, duration)
			tween.parallel().tween_property(node, "position:x", node.position.x - 100, duration)
			
		TransitionType.SLIDE_UP:
			node.position.y += 100
			tween.tween_property(node, "modulate:a", 1.0, duration)
			tween.parallel().tween_property(node, "position:y", node.position.y - 100, duration)
			
		TransitionType.SLIDE_DOWN:
			node.position.y -= 100
			tween.tween_property(node, "modulate:a", 1.0, duration)
			tween.parallel().tween_property(node, "position:y", node.position.y + 100, duration)
			
		TransitionType.SCALE:
			node.scale = Vector2.ZERO
			tween.tween_property(node, "modulate:a", 1.0, duration)
			tween.parallel().tween_property(node, "scale", Vector2.ONE, duration)
			
		TransitionType.ROTATE:
			node.rotation = -PI
			node.scale = Vector2.ZERO
			tween.tween_property(node, "modulate:a", 1.0, duration)
			tween.parallel().tween_property(node, "rotation", 0, duration)
			tween.parallel().tween_property(node, "scale", Vector2.ONE, duration)
	
	if callback.is_valid():
		tween.tween_callback(callback)

# Static method to hide a node with animation
static func hide_animated(
	node: Node,
	transition_type: TransitionType = TransitionType.FADE,
	duration: float = 0.5,
	delay: float = 0.0,
	ease_type: Tween.EaseType = Tween.EASE_IN,
	callback: Callable = Callable()
) -> void:
	if not is_instance_valid(node):
		return
		
	var tween = node.create_tween()
	tween.set_ease(ease_type)
	
	# Add delay if specified
	if delay > 0:
		tween.tween_interval(delay)
	
	match transition_type:
		TransitionType.FADE:
			tween.tween_property(node, "modulate:a", 0.0, duration)
			
		TransitionType.SLIDE_RIGHT:
			tween.tween_property(node, "modulate:a", 0.0, duration)
			tween.parallel().tween_property(node, "position:x", node.position.x + 100, duration)
			
		TransitionType.SLIDE_LEFT:
			tween.tween_property(node, "modulate:a", 0.0, duration)
			tween.parallel().tween_property(node, "position:x", node.position.x - 100, duration)
			
		TransitionType.SLIDE_UP:
			tween.tween_property(node, "modulate:a", 0.0, duration)
			tween.parallel().tween_property(node, "position:y", node.position.y - 100, duration)
			
		TransitionType.SLIDE_DOWN:
			tween.tween_property(node, "modulate:a", 0.0, duration)
			tween.parallel().tween_property(node, "position:y", node.position.y + 100, duration)
			
		TransitionType.SCALE:
			tween.tween_property(node, "modulate:a", 0.0, duration)
			tween.parallel().tween_property(node, "scale", Vector2.ZERO, duration)
			
		TransitionType.ROTATE:
			tween.tween_property(node, "modulate:a", 0.0, duration)
			tween.parallel().tween_property(node, "rotation", PI, duration)
			tween.parallel().tween_property(node, "scale", Vector2.ZERO, duration)
	
	# Hide node after animation
	tween.tween_callback(func(): node.visible = false)
	
	if callback.is_valid():
		tween.tween_callback(callback)



"""
Usage:
	# Example usage in any scene script

func _ready():
	# Basic usage with default parameters (fade animation)
	TransitionAnimator.show_animated($YourNode)
	
	# Advanced usage with custom parameters
	TransitionAnimator.show_animated(
		$YourNode,
		TransitionAnimator.TransitionType.SLIDE_RIGHT,
		0.75,  # duration
		0.2,   # delay
		Tween.EASE_OUT_BACK,
		func(): print("Animation completed!")  # callback
	)
	
	# Hide with animation
	TransitionAnimator.hide_animated(
		$YourNode,
		TransitionAnimator.TransitionType.SCALE,
		0.5,   # duration
		0.0,   # delay
		Tween.EASE_IN_BACK,
		func(): print("Node hidden!")  # callback
	)
"""
