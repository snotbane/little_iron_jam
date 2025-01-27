
extends Brain

enum State {
	IDLING,
	MOVING,
	AIMING,
	FIRING,
}

@export var aim_bone : BoneAttachment3D
@export var laser_path : Node3D
# @export var laser_path : Path3D

@export var aim_turn_speed : float = 0.25
@export var aim_acceptance_range : float = 0.005

@onready var aim_timer : Timer = $aim_giveup_timer


var _state : State
var state : State :
	get: return _state
	set(value):
		if _state == value: return
		_state = value

		laser_path.visible = _state == State.AIMING

		if state == State.AIMING:
			aim_timer.start()
		else:
			aim_timer.stop()


# var laser_length : float :
# 	get: return -laser_path.curve.get_point_position(1).z
# 	set(value): laser_path.curve.set_point_position(1, Vector3(0, 0, -value))


func _ready() -> void:
	await super._ready()
	aim_timer.timeout.connect(fire)
	self.target_reached.connect(begin_aim)
	state = State.MOVING


func _process(delta: float) -> void:
	match state:
		State.MOVING:
			process_rotate_to_target_forwards(delta)
		State.AIMING:
			if aim_bone.override_pose and target:
				# laser_length = (laser_path.global_position - target.global_position).length()
				var step := (target.global_position - aim_bone.global_position).normalized()
				var dot_x := -step.dot(aim_bone.global_basis.x)
				aim_bone.rotation.y += aim_turn_speed * signf(dot_x) * delta
				if absf(dot_x) <= aim_acceptance_range : fire()


func _physics_process(delta: float) -> void:
	match state:
		State.MOVING:
			physics_process_walk_forward(delta)


func begin_aim() -> void:
	state = State.AIMING


func fire() -> void:
	state = State.FIRING
	weapon_config.is_shooting = true
	pawn.global_rotation.y = aim_bone.global_rotation.y
	aim_bone.override_pose = false
	await wait(0.25)
	weapon_config.is_shooting = false
	state = State.IDLING
	await wait(1.0)
	state = State.MOVING
