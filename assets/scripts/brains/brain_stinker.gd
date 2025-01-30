
extends Brain

enum State {
	IDLING,
	CHASING,
	ATTACKING,
}

var _state : State
var state : State :
	get: return _state
	set(value):
		if _state == value: return
		_state = value


var is_attacking_blip : bool :
	get: return state == State.ATTACKING


func _ready() -> void:
	await super._ready()

	state = State.CHASING


func _process(delta: float) -> void:
	match state:
		State.CHASING:
			process_rotate_to_target_forwards(delta)
			if self.is_target_reached() and get_is_facing_kill_target():
				attack()



func _physics_process(delta: float) -> void:
	if not kill_target:
		state = State.IDLING
	match state:
		State.CHASING:
			physics_process_walk_forward(delta)
		_:
			pawn.velocity = Vector3.ZERO


func attack() -> void:
	state = State.ATTACKING
	await get_tree().create_timer(0.5).timeout
	state = State.IDLING
	await get_tree().create_timer(2.0).timeout
	state = State.CHASING