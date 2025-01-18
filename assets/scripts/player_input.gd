
extends Node

const JUMP_VELOCITY = 4.5

@export var move_speed : float = 5.0

@onready var pawn : CharacterBody3D = self.get_parent()

var move_vector : Vector2

func _process(delta: float) -> void:
	move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not pawn.is_on_floor():
		pawn.velocity += pawn.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and pawn.is_on_floor():
		pawn.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (pawn.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		pawn.velocity.x = direction.x * move_speed
		pawn.velocity.z = direction.z * move_speed
	else:
		pawn.velocity.x = move_toward(pawn.velocity.x, 0, move_speed)
		pawn.velocity.z = move_toward(pawn.velocity.z, 0, move_speed)

	pawn.move_and_slide()
