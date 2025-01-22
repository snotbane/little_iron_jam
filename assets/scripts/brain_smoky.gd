
extends Brain

enum State {
	CHASING,
	WANDERING,
	AIMING,
	ATTACK,
}

var state : State = State.CHASING


func _ready() -> void:
	super._ready()
	self.target_reached.connect(attack)


func _physics_process(delta: float) -> void:
	if not target: return
	match state:
		State.CHASING:
			physics_process_walk_to_target(delta)
		State.AIMING:
			pawn.look_at(target.global_position)


func attack() -> void:
	state = State.AIMING
	await wait(1.5)
	state = State.ATTACK
	shoot()
	await wait(1.0)
	state = State.WANDERING
	await wait(5.0)
	state = State.CHASING
