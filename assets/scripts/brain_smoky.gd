
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
			weapon_config.fire_direction = target_direction
			pawn.look_at(target.global_position)


func attack() -> void:
	state = State.AIMING
	await wait(0.9)
	state = State.ATTACK
	await wait(0.3)
	weapon_config.is_shooting = true
	await wait(1.0)
	state = State.WANDERING
	weapon_config.is_shooting = false
	await wait(1.0)
	state = State.CHASING
