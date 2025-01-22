
extends Brain

enum State {
	CHASING,
	WANDERING,
	AIMING,
	ATTACK,
}

@export var ideal_fire_distance : float = 20.0

