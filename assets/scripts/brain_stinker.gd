
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

var lunge_vector : Vector3


func _ready() -> void:
	super._ready()

	self.target_reached.connect(attack)

func _physics_process(delta: float) -> void:
	if not target: return
	match state:
		State.CHASING:
			var difference := self.get_next_path_position() - pawn.global_position
			pawn.velocity = difference.normalized() * walk_speed * delta
			pawn.move_and_slide()
			if pawn.velocity:
				pawn.look_at(pawn.global_position + pawn.velocity)
		State.ATTACK:
			pawn.velocity = -pawn.global_basis.z * lunge_speed * delta
			pawn.move_and_slide()


func attack() -> void:
	print("Attack!")
	state = State.IDLE
	await get_tree().create_timer(lunge_pre_delay).timeout
	state = State.ATTACK
	await get_tree().create_timer(lunge_duration).timeout
	state = State.IDLE
	await get_tree().create_timer(lunge_post_delay).timeout
	state = State.CHASING
