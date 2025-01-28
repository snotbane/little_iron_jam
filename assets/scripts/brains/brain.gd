
class_name Brain extends NavigationAgent3D

@onready var pawn : CharacterBody3D = self.get_parent()
@onready var nav_timer : Timer = $nav_timer
@onready var kill_target : Node3D = PlayerMovement.inst.pawn
@onready var move_target : Node3D = kill_target

@export var weapon_config : WeaponConfig
@export var idle_on_ready : float = 2.0
@export var walk_speed : float = 100.0
@export var turn_speed : float = 0.0


var pawn_lateral_velocity : Vector3 :
	get: return pawn.velocity * Vector3(1, 0, 1)
	set(value): pawn.velocity = Vector3(value.x, pawn.velocity.y, value.z)


var can_see_kill_target : bool :
	get:
		var query := PhysicsRayQueryParameters3D.create(pawn.global_position + Vector3.UP, kill_target.global_position + Vector3.UP, 1, [ pawn.get_rid(), kill_target.get_rid() ])
		var dss := pawn.get_world_3d().direct_space_state
		var collision := dss.intersect_ray(query)
		return not collision


var _is_volatile : bool
@export var is_volatile : bool :
	get: return _is_volatile
	set(value):
		if _is_volatile == value: return
		_is_volatile = value

		pawn.set_collision_layer_value(3, _is_volatile)


var is_walking : bool :
	get: return pawn.velocity.length_squared() > 0.1

var target_direction : Vector3 :
	get: return (kill_target.global_position - pawn.global_position).normalized()

func _ready():
	nav_timer.timeout.connect(update_target_position)
	self.target_reached.connect(func(): pawn.velocity = Vector3.ZERO )
	await get_tree().create_timer(idle_on_ready).timeout


func wait(delay : float) :
	await get_tree().create_timer(delay).timeout


func process_rotate_to_target_forwards(delta: float, towards := true, turn_speed_scalar := 1.0) -> void:
	if not move_target: return
	var step := self.get_next_path_position() - pawn.global_position
	var dot_x := step.dot(pawn.global_basis.x) * (-1 if towards else 1)
	pawn.rotation.y += turn_speed * sqrt(absf(dot_x)) * signf(dot_x) * delta * turn_speed_scalar


func process_rotate_to_target_sideways(delta: float, clockwise := true, turn_speed_scalar := 1.0) -> void:
	if not move_target: return
	var step := self.get_next_path_position() - pawn.global_position
	var dot_z := step.dot(pawn.global_basis.z) * (-1 if clockwise else 1)
	pawn.rotation.y += turn_speed * sqrt(absf(dot_z)) * signf(dot_z) * delta * turn_speed_scalar


func physics_process_walk_forward(delta: float, towards := true) -> void:
	pawn_lateral_velocity = pawn.global_basis.z * (-1 if towards else 1) * walk_speed * delta
	pawn.move_and_slide()

func physics_process_walk_sideways(delta: float, clockwise := true) -> void:
	pawn_lateral_velocity = pawn.global_basis.x * (-1 if clockwise else 1) * walk_speed * delta
	pawn.move_and_slide()


func physics_process_walk_to_target(delta: float) -> void:
	var difference := self.get_next_path_position() - pawn.global_position
	pawn_lateral_velocity = difference.normalized() * walk_speed * delta
	pawn.move_and_slide()


func update_target_position() -> void:
	if not move_target:
		# nav_timer.timeout.disconnect(update_target_position)
		return

	self.target_position = move_target.global_position
