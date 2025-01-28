
@tool
extends WaveTimedNode

@export var update : bool = true
@export var alpha_time := 10.0


var target_background_energy_multiplier : float


func _process(delta: float) -> void:
	if not update: return
	var alpha := alpha_time * delta

	self.environment.background_energy_multiplier = lerp(self.environment.background_energy_multiplier, target_background_energy_multiplier, alpha)


func _set_current_hour(value: int) -> void:
	target_background_energy_multiplier = current_value[&"background_energy_multiplier"]