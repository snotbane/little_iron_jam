
extends Brain

enum State {
	IDLING,
	CHASING,
	ATTACKING,
}
var state : State


signal cackled


@export var anim_tree : AnimationTree
@export var cackle_sound : AudioStreamPlayer3D

var is_cackling_in_animation : bool :
	get: return anim_tree["parameters/all/cackle/blend_amount"] == 1.0
	set(value): anim_tree["parameters/all/cackle/blend_amount"] = 1.0 if value else 0.0


func _ready() -> void:
	cackle()
	await super._ready()

	while true:
		state = State.CHASING
		await wait(5.0)
		attack()
		await wait(5.0)


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
			process_rotate_to_target_forwards(delta, true, 3.0)


func _physics_process(delta: float) -> void:
	match state:
		State.CHASING:
			physics_process_walk_forward(delta)
		State.ATTACKING:
			if can_see_kill_target:
				physics_process_walk_sideways(delta)
			else:
				physics_process_walk_forward(delta)


func attack() -> void:
	cackle()
	state = State.ATTACKING


func cackle():
	cackle_sound.play()
	is_cackling_in_animation = true
	await cackle_sound.finished
	is_cackling_in_animation = false

