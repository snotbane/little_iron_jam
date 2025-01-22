
extends AnimationTree

@export var head_bone : Node3D

var dodge_blip : bool
var recoil_blip : bool


func set_aim_vector(value: Vector3) -> void:
	head_bone.look_at(head_bone.global_position + value)
	value = self.get_parent().global_basis * value
	self["parameters/recoil/blend_position"] = Vector2(-value.x, value.z)


func set_walk_speed(value: float) -> void:
	self["parameters/walk/blend_position"] = value


func dodge() -> void:
	dodge_blip = true
	await get_tree().create_timer(0.05).timeout
	dodge_blip = false

func recoil() -> void:
	recoil_blip = true
	await get_tree().create_timer(0.05).timeout
	recoil_blip = false
