
class_name PlayerMovement extends Node

static var inst : Node

signal speed_changed(value: float)
signal on_dodge

@export_category("Walk")

@export var walk_speed : float = 5.0
@export var walk_damping : float = 5.0
@export var turn_speed : float = 1.0
@export_range(0.0, 1.0) var turn_limit : float = 0.8

@export_category("Dodge")

@export var dodge_impulse : float = 50.0
@export var dodge_damping : float = 3.0
@export var dodge_delay : float = 1.0
@export var dodge_ammo_cost : int = 3

@onready var pawn : CharacterBody3D = self.get_parent()
@onready var ammo : Ammo = pawn.find_child("ammo")

var input_vector : Vector2
var move_vector : Vector3 :
	get: return Vector3(input_vector.x, 0, input_vector.y)
var orientation_vector : Vector2

var _is_dodging : bool
var is_dodging : bool :
	get: return _is_dodging
	set(value):
		if _is_dodging == value: return
		_is_dodging = value
		pawn.set_collision_layer_value(2, not _is_dodging)
		pawn.set_collision_layer_value(3, _is_dodging)
		pawn.set_collision_mask_value(2, not _is_dodging)

var damping : float :
	get: return dodge_damping if is_dodging else walk_damping


func _ready() -> void:
	inst = self


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
	speed_changed.emit(pawn.velocity.length_squared())

	pawn.move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		dodge()


func dodge() -> void:
	if is_dodging: return
	is_dodging = true
	on_dodge.emit()
	ammo.count -= dodge_ammo_cost
	if move_vector:
		pawn.look_at(pawn.global_position + move_vector)
	pawn.velocity += -pawn.global_basis.z * dodge_impulse
	await get_tree().create_timer(dodge_delay).timeout
	is_dodging = false
