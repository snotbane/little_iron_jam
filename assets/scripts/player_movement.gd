
extends Node

const JUMP_VELOCITY = 4.5

@export_category("Walk")

@export var walk_speed : float = 5.0
@export var walk_damping : float = 5.0
@export var turn_speed : float = 1.0
@export_range(0.0, 1.0) var turn_limit : float = 0.8

@export_category("Dodge")

@export var dodge_impulse : float = 50.0
@export var dodge_damping : float = 3.0
@export var dodge_delay : float = 1.0

@onready var pawn : CharacterBody3D = self.get_parent()

var input_vector : Vector2
var move_vector : Vector3 :
	get: return Vector3(input_vector.x, 0, input_vector.y)
var orientation_vector : Vector2

var is_dodging : bool

var damping : float :
	get: return dodge_damping if is_dodging else walk_damping

func _process(delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	orientation_vector = Vector2(move_vector.dot(pawn.global_basis.x), move_vector.dot(pawn.global_basis.z))

	if input_vector and not is_dodging:
		var turn_amount := signf(orientation_vector.x) if orientation_vector.y >= 0.0 else orientation_vector.x
		pawn.rotate_y(turn_amount * turn_speed * delta * -1.0)
		# pawn.rotate_y(sqrt(abs(turn_amount)) * signf(turn_amount) * turn_speed * delta * -1.0)


func _physics_process(delta: float) -> void:
	var move_direction := -pawn.transform.basis.z

	if input_vector and not is_dodging and orientation_vector.y < -turn_limit:
		pawn.velocity += move_direction * walk_speed * delta

	pawn.velocity -= pawn.velocity * damping * delta

	pawn.move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		dodge()


func dodge() -> void:
	if is_dodging: return
	is_dodging = true
	pawn.velocity += (move_vector if move_vector else -pawn.global_basis.z) * dodge_impulse
	await get_tree().create_timer(dodge_delay).timeout
	is_dodging = false
