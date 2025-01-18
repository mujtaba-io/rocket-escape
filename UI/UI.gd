extends CanvasLayer


func _ready():
	add_to_group("ui")


func set_health(health: float) -> void:
	$Control/HealthBar.value = health


func set_fuel(fuel: float) -> void:
	$Control/FuelBar.value = fuel


func set_timer(t: String):
	$Control/TimeLeftLabel.text = t
