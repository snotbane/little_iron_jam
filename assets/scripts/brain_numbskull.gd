
extends Brain

func _physics_process(delta: float) -> void:
	pawn.velocity = (target.global_position - pawn.global_position).normalized() * walk_speed * delta
	pawn.move_and_slide()
