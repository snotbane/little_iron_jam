
extends Brain

enum State {
	IDLING,
	CHASING,
	WANDERING,
	AIMING,
	ATTACK,
}
var _state : State
var state : State :
	get: return _state
	set(value):
		if _state == value: return
		_state = value

		match _state:
			State.CHASING:
				move_target = kill_target
				target_desired_distance = 8.0
			State.WANDERING:
				pick_new_personal_target()
				move_target = personal_target
				target_desired_distance = 3.0


@export var personal_target : Node3D
@export var personal_target_iterations : int = 5


func _ready() -> void:
	await super._ready()
	state = State.CHASING


func _process(delta: float) -> void:
	match state:
		State.CHASING, State.WANDERING:
			process_rotate_to_target_forwards(delta)
		State.AIMING:
			process_rotate_to_target_forwards(delta, true, 1, kill_target)


func _physics_process(delta: float) -> void:
	match state:
		State.CHASING:
			physics_process_walk_forward(delta)
			if self.is_target_reached() and can_see_kill_target:
				attack()
		State.WANDERING:
			physics_process_walk_forward(delta)
			if self.is_target_reached():
				state = State.IDLING
		State.AIMING:
			weapon_config.fire_direction = target_direction


func attack() -> void:
	state = State.AIMING
	await wait(0.9)
	state = State.ATTACK
	await wait(0.3)
	weapon_config.is_shooting = true
	await wait(0.1)
	weapon_config.is_shooting = false
	await wait(0.5)
	state = State.WANDERING
	await wait(5.0)
	state = State.CHASING


func pick_new_personal_target() -> void:
	var result := Vector3.ZERO
	var length := 10000.0
	for i in personal_target_iterations:
		var pos := WaveController.inst.random_floor_position
		var l := (pawn.global_position - pos).length_squared()
		if l > length: continue
		length = l
		result = pos
	personal_target.global_position = result * Vector3(1, 0, 1)
