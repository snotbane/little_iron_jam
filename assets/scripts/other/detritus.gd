
class_name Detritus extends RigidBody3D

@export var anim := &""
@export var impulse := Vector3(4, 5, 3)

var anim_player : AnimationPlayer

var random_unit : float :
	get: return randf_range(-1, 1)

func _ready() -> void:
	anim_player = find_child(&"animation_player")
	if anim: anim_player.play(anim)
	self.apply_impulse(Vector3(random_unit * impulse.x, randf_range(impulse.y * 0.8, impulse.y * 1.2), random_unit * impulse.x))
	if OS.has_feature("web"):
		self.global_rotation = Quaternion.IDENTITY * Vector3(random_unit, random_unit, random_unit)
	else:
		self.apply_torque_impulse(Vector3(random_unit, random_unit, random_unit) * impulse.z)
