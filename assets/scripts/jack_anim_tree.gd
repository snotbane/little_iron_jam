
extends AnimationTree

@export var head_bone : Node3D

var dodge_blip : bool


func set_aim_vector(value: float) -> void:
	head_bone.global_rotation.y = -value


func set_walk_speed(value: float) -> void:
	self["parameters/walk/blend_position"] = value


func dodge() -> void:
	dodge_blip = true
	await get_tree().create_timer(0.05).timeout
	dodge_blip = false
