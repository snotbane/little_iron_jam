
class_name Detritus extends RigidBody3D

@export var anim := &"flash_out"
@export var impulse := Vector3.ONE

@onready var anim_player : AnimationPlayer = $animation_player

var random_unit : float :
	get: return randf_range(-1, 1)

func _ready() -> void:
	anim_player.play(anim)
	self.apply_impulse(Vector3(random_unit * impulse.x, impulse.y, random_unit * impulse.x))
	self.apply_torque_impulse(Vector3(random_unit, random_unit, random_unit) * impulse.z)
