
extends CharacterBody3D

signal received_weapon_config(weapon_config: WeaponConfig)

@export var damage := 1


func _ready() -> void:
	if self.is_in_group(&"enemy"):
		tree_exited.connect(WaveController.inst.check_enemy_group)


func _physics_process(delta: float) -> void:
	if not self.is_on_floor():
		self.velocity += get_gravity() * delta
		self.move_and_slide()
