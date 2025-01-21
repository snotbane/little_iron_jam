
extends AnimationTree


func set_walk_speed(value: float) -> void:
	self["parameters/walk/blend_position"] = value
