
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

		if _state != State.ATTACKING: weapon_config.is_shooting = false

var turn_switch : bool

@export var anim_tree : AnimationTree
@export var cackle_sound : AudioStreamPlayer3D

@export var min_chase_time := 5.0
@export var max_chase_time := 8.0
@export var min_attack_time := 12.0
@export var max_attack_time := 22.0
@export var min_cackle_time := 6.0
@export var max_cackle_time := 9.0

var is_cackling_in_animation : bool :
	get: return anim_tree["parameters/all/cackle/blend_amount"] == 1.0
	set(value): anim_tree["parameters/all/cackle/blend_amount"] = 1.0 if value else 0.0


func _ready() -> void:
	cackle()
	await super._ready()

	while true:
		attack()
		await wait(randf_range(min_attack_time, max_attack_time))
		state = State.CHASING
		await wait(randf_range(min_chase_time, max_chase_time))


func _process(delta: float) -> void:
	anim_tree["parameters/all/movement/walk/blend_position"] = Vector2(pawn.global_basis.x.dot(pawn_lateral_velocity), pawn.global_basis.z.dot(pawn_lateral_velocity))

	match state:
		State.CHASING:
			if can_see_kill_target:
				var dot_x := pawn.global_basis.x.dot(kill_target.global_position - pawn.global_position)
				process_rotate_to_target_sideways(delta, dot_x > 0)
			else:
				process_rotate_to_target_forwards(delta)
		State.ATTACKING:
			process_rotate_to_target_forwards(delta, true, 3.0, kill_target if can_see_kill_target else null)


func _physics_process(delta: float) -> void:
	match state:
		State.CHASING:
			physics_process_walk_forward(delta)
		State.ATTACKING:
			if can_see_kill_target:
				physics_process_walk_sideways(delta, turn_switch)
			else:
				physics_process_walk_forward(delta)
				turn_switch = not turn_switch


func attack() -> void:
	state = State.ATTACKING
	await wait(0.75)
	weapon_config.is_shooting = true
	await wait(randf_range(min_cackle_time, max_cackle_time))
	cackle()


func cackle():
	cackle_sound.play()
	is_cackling_in_animation = true
	await cackle_sound.finished
	is_cackling_in_animation = false

