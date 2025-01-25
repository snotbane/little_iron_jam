
@tool
extends WaveTimedNode

@export var update : bool = true
@export var alpha_time := 10.0


var target_light_color : Color
var target_light_energy : float
var target_quaternion : Quaternion


func _ready() -> void:
	super._ready()

	set_current_hour(0)


func _process(delta: float) -> void:
	if not update: return
	var alpha := alpha_time * delta
	self.light_color = lerp(self.light_color, target_light_color, alpha)
	self.light_energy = lerp(self.light_energy, target_light_energy, alpha)
	self.quaternion = lerp(self.quaternion, target_quaternion, alpha)


func _set_current_hour(value: int) -> void:
	target_light_color = current_value[&"color"]
	target_light_energy = current_value[&"energy"]
	target_quaternion = current_value[&"quat"]