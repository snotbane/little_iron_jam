extends Node3D

@export var spin_speed_degrees := Vector3.UP

func _process(delta: float) -> void:
	self.global_rotation = Vector3(0, self.global_rotation.y, 0)
	self.global_rotation_degrees += spin_speed_degrees * delta
