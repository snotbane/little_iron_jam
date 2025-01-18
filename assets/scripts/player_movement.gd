
extends Node

const JUMP_VELOCITY = 4.5

@export_category("Walk")

@export var walk_speed : float = 5.0
@export var walk_damping : float = 5.0

@export_category("Dodge")

@export var dodge_impulse : float = 50.0
@export var dodge_damping : float = 3.0
@export var dodge_delay : float = 1.0

@onready var pawn : CharacterBody3D = self.get_parent()

var move_vector : Vector3
var is_dodging : bool

var damping : float :
	get: return dodge_damping if is_dodging else walk_damping

func _process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	move_vector = Vector3(input_vector.x, 0, input_vector.y)

func _physics_process(delta: float) -> void:
	var move_direction := (pawn.transform.basis * move_vector)

	if not is_dodging:
		pawn.velocity += move_direction * walk_speed * delta

	pawn.velocity -= pawn.velocity * damping * delta

	pawn.move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		dodge()


func dodge() -> void:
	if is_dodging: return
	is_dodging = true
	pawn.velocity += move_vector * dodge_impulse
	await get_tree().create_timer(dodge_delay).timeout
	is_dodging = false
