
extends Brain

enum State {
	CHASING,
	IDLE,
	ATTACK,
}

@export var lunge_pre_delay : float = 0.25
@export var lunge_duration : float = 0.25
@export var lunge_post_delay : float = 0.5
@export var lunge_speed : float = 100.0

var _state : State
var state : State :
	get: return _state
	set(value):
		if _state == value: return
		_state = value

		pawn.set_collision_layer_value(3, _state == State.ATTACK)


func _ready() -> void:
	super._ready()
	self.target_reached.connect(attack)

func _physics_process(delta: float) -> void:
	if not target: return
	match state:
		State.CHASING:
			physics_process_walk_to_target(delta)
		State.ATTACK:
			pawn.velocity = -pawn.global_basis.z * lunge_speed * delta
			pawn.move_and_slide()


func attack() -> void:
	state = State.IDLE
	await wait(lunge_pre_delay)
	state = State.ATTACK
	await wait(lunge_duration)
	state = State.IDLE
	await wait(lunge_post_delay)
	state = State.CHASING
