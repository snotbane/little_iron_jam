
class_name Brain extends Node

@onready var pawn : CharacterBody3D = self.get_parent()
@onready var target : CharacterBody3D = PlayerMovement.inst.pawn

@export var walk_speed : float = 1.0
