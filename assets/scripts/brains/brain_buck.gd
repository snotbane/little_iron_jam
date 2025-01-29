
extends Brain

enum State {
	IDLING,
	CHASING,
	WARNING,
	ATTACKING
}


signal attack_warning


var _state : State
var state : State :
	get: return _state
	set(value):
		if _state == value: return
		_state = value

		weapon_config.is_shooting = state == State.CHASING


@export var is_slam_blip : bool :
	get: return state == State.ATTACKING


func _ready() -> void:
	self.target_reached.connect(slam)
	await super._ready()
	state = State.CHASING


func _process(delta: float) -> void:
	match state:
		State.CHASING:
			process_rotate_to_target_forwards(delta)


func _physics_process(delta: float) -> void:
	if not kill_target: state = State.IDLING
	match state:
		State.CHASING:
			physics_process_walk_forward(delta)


func slam() -> void:
	state = State.WARNING
	attack_warning.emit()
	await wait(0.7)
	state = State.ATTACKING
	await wait(0.5)
	state = State.IDLING
	await wait(1.5)
	state = State.CHASING