
extends Brain

enum State {
	IDLING,
	MOVING,
	AIMING,
	FIRING,
}

@export var personal_target : Node3D
@export var aim_bone : BoneAttachment3D
@export var laser_path : Node3D
# @export var laser_path : Path3D

@export var aim_turn_speed : float = 0.25

## How many points to pick on the map. The higher the number, the more likely it is for this enemy to keep away from the player.
@export var move_target_iterations : int = 10

@onready var aim_timer : Timer = $aim_giveup_timer


var prev_dot_x : float

var _state : State
var state : State :
	get: return _state
	set(value):
		if _state == value: return
		_state = value

		laser_path.visible = _state == State.AIMING

		if state == State.AIMING:
			aim_timer.start()
			prev_dot_x = 0
		else:
			aim_timer.stop()


# var laser_length : float :
# 	get: return -laser_path.curve.get_point_position(1).z
# 	set(value): laser_path.curve.set_point_position(1, Vector3(0, 0, -value))


func _ready() -> void:
	move_target = personal_target
	await super._ready()
	pick_new_personal_target()
	aim_timer.timeout.connect(fire)
	self.target_reached.connect(begin_aim)
	state = State.MOVING


func _process(delta: float) -> void:
	match state:
		State.MOVING:
			process_rotate_to_target_forwards(delta)
		State.AIMING:
			if not kill_target: return
			var rotate_node : Node3D = aim_bone as Node3D if aim_bone.override_pose else pawn as Node3D
			# laser_length = (laser_path.global_position - target.global_position).length()
			var step := (kill_target.global_position - rotate_node.global_position).normalized()
			var dot_x := -step.dot(rotate_node.global_basis.x)
			rotate_node.rotation.y += aim_turn_speed * signf(dot_x) * delta
			if prev_dot_x != 0 and prev_dot_x != signf(dot_x): fire()
			prev_dot_x = signf(dot_x)


func _physics_process(delta: float) -> void:
	match state:
		State.MOVING:
			physics_process_walk_forward(delta)


func begin_aim() -> void:
	state = State.AIMING


func fire() -> void:
	pick_new_personal_target()
	state = State.FIRING
	weapon_config.is_shooting = true
	pawn.global_rotation.y = aim_bone.global_rotation.y
	aim_bone.override_pose = false
	await wait(0.25)
	weapon_config.is_shooting = false
	state = State.IDLING
	await wait(1.0)
	state = State.MOVING


func pick_new_personal_target() -> void:
	var result := pawn.global_position
	var length := 0.0
	for i in move_target_iterations:
		var pos := WaveController.inst.random_floor_position
		var l := (pawn.global_position - pos).length_squared()
		if l < length: continue
		length = l
		result = pos

	move_target.global_position = result * Vector3(1, 0, 1)
