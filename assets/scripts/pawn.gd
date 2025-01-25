
extends Node3D

signal received_weapon_config(weapon_config: WeaponConfig)

@export var damage := 1


func _ready() -> void:
	if self.is_in_group(&"enemy"):
		tree_exited.connect(WaveController.inst.check_enemy_group)
