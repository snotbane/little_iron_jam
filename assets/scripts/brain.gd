
class_name Brain extends NavigationAgent3D

@onready var pawn : CharacterBody3D = self.get_parent()
@onready var nav_timer : Timer = $nav_timer
@onready var target : CharacterBody3D = PlayerMovement.inst.pawn

@export var walk_speed : float = 100.0

func _ready() -> void:
	nav_timer.timeout.connect(update_target_position)


func update_target_position() -> void:
	self.target_position = target.global_position
