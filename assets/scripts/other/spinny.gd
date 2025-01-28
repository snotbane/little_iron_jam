extends Node3D

@export var spin_speed_degrees := Vector3.UP

func _process(delta: float) -> void:
	self.rotation_degrees += spin_speed_degrees * delta
