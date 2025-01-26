
extends Brain

enum State {
	IDLING,
	CHASING,
	ATTACKING,
}

var _state : State
@export var state : State :
	get: return _state
	set(value):
		if _state == value: return
		_state = value


var is_attacking_blip : bool :
	get: return state == State.ATTACKING


var _is_volatile : bool
@export var is_volatile : bool :
	get: return _is_volatile
	set(value):
		if _is_volatile == value: return
		_is_volatile = value

		pawn.set_collision_layer_value(3, _is_volatile)
func set_is_volatile(value: bool) -> void:
	is_volatile = value


func _ready() -> void:
	super._ready()
	await get_tree().create_timer(1.0).timeout

	state = State.CHASING
	self.target_reached.connect(attack)


func _physics_process(delta: float) -> void:
	if not target:
		state = State.IDLING
	match state:
		State.CHASING:
			physics_process_walk_to_target(delta)
		_:
			pawn.velocity = Vector3.ZERO


func attack() -> void:
	state = State.ATTACKING
	await get_tree().create_timer(0.5).timeout
	state = State.IDLING
	await get_tree().create_timer(2.0).timeout
	state = State.CHASING