extends RigidBody2D


# Export variables for thrust markers
@export var left_nozzle_marker: Marker2D
@export var right_nozzle_marker: Marker2D


@export var left_thrust_animation: AnimatedSprite2D
@export var right_thrust_animation: AnimatedSprite2D


@export var thrust_force: float = 128.0  # Adjust this to control thrust power


@export var max_health: float = 100
var health: float = max_health


@export var max_fuel: float = 100
var fuel: float = max_fuel


func _ready():
	# Verify that the marker nodes are assigned
	if !left_nozzle_marker or !right_nozzle_marker:
		push_warning("Please assign Marker2D nodes for the nozzle positions!")
		return
	
	# Verify that the thrust animations are assigned
	if !left_thrust_animation or !right_thrust_animation:
		push_warning("Please assign AnimatedSprite2D nodes for the thrust animations!")
		return
	
	add_to_group('players')
	
	# Hide the thrust animations
	left_thrust_animation.visible = false
	right_thrust_animation.visible = false
	
	left_thrust_animation.play("default")
	right_thrust_animation.play("default")


func _physics_process(delta: float) -> void:
	# Early return if markers are not set
	if !left_nozzle_marker or !right_nozzle_marker:
		return
	
	# Hide the thrust animations before start of the loop
	# it will later be shown if thrusters are active
	left_thrust_animation.visible = false
	right_thrust_animation.visible = false
	
	var left_thruster = Input.is_action_pressed("ui_left")
	var right_thruster = Input.is_action_pressed("ui_right")
	
	if left_thruster and not right_thruster:
		var radius := left_nozzle_marker.global_position.distance_to(self.global_position)
		apply_torque(thrust_force * radius)
		
		left_thrust_animation.visible = true
		right_thrust_animation.visible = false
		
		fuel -= delta
	
	elif right_thruster and not left_thruster:
		var radius := left_nozzle_marker.global_position.distance_to(self.global_position)
		apply_torque(-thrust_force * radius)
		left_thrust_animation.visible = false
		right_thrust_animation.visible = true
		
		fuel -= delta
	
	if left_thruster and right_thruster:
		apply_central_force(Vector2.UP.rotated(self.rotation) * 2.0 * thrust_force) # Since both thrusters are open
		
		left_thrust_animation.visible = true
		right_thrust_animation.visible = true
		
		fuel -= delta * 2.0
	
	var ui = get_tree().get_nodes_in_group("ui")[0]
	ui.set_fuel(fuel)
	ui.set_health(health)














# Rocket properties
var damage_threshold: float = 5.0  # Minimum velocity for damage to occur
var impact_damage_multiplier: float = 0.25  # Adjust this to control damage sensitivity

# Called when a collision occurs
func _on_body_entered(body: Node) -> void:
	var impact = calculate_collision_impact()
	apply_impact_damage(impact)

# Calculate the impact force based on both linear and angular velocity
func calculate_collision_impact() -> float:
	# Get the magnitude of linear velocity
	var linear_impact = linear_velocity.length()
	
	# Get the magnitude of angular velocity (in radians/sec)
	var angular_impact = abs(angular_velocity)
	
	# Combine both impacts - you can adjust these weights
	var total_impact = (linear_impact * 0.8) + (angular_impact * 0.2)
	
	# Return 0 if impact is below threshold
	if total_impact < damage_threshold:
		return 0.0
		
	return total_impact

# Apply damage based on the impact force
func apply_impact_damage(impact: float) -> void:
	if impact <= 0:
		return
		
	# Calculate damage based on impact
	var damage = impact * impact_damage_multiplier
	
	# Reduce health
	health = max(0, health - damage)
	
	# Print debug information
	print("Impact force: ", impact)
	print("Damage dealt: ", damage)
	print("Current health: ", health)
	
	# Check if rocket is destroyed
	if health <= 0:
		destroy_rocket()

# Handle rocket destruction
func destroy_rocket() -> void:
	# Add your destruction logic here
	# For example: play explosion animation, spawn particles, etc.
	# queue_free()  # Remove the rocket from the scene
	pass
