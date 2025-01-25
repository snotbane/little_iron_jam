
class_name Brain extends NavigationAgent3D

@onready var pawn : CharacterBody3D = self.get_parent()
@onready var nav_timer : Timer = $nav_timer
@onready var target : CharacterBody3D = PlayerMovement.inst.pawn

@export var weapon_config : WeaponConfig
@export var walk_speed : float = 100.0

var target_direction : Vector3 :
	get: return (target.global_position - pawn.global_position).normalized()

func _ready() -> void:
	nav_timer.timeout.connect(update_target_position)


func wait(delay : float) :
	await get_tree().create_timer(delay).timeout


func physics_process_walk_to_target(delta: float) -> void:
	var difference := self.get_next_path_position() - pawn.global_position
	pawn.velocity = difference.normalized() * walk_speed * delta
	pawn.move_and_slide()
	if pawn.velocity:
		pawn.look_at(pawn.global_position + pawn.velocity)


func update_target_position() -> void:
	if not target:
		# nav_timer.timeout.disconnect(update_target_position)
		return

	self.target_position = target.global_position
