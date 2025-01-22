
class_name Weapon extends Node3D

@export var health : int = 100
@export var bullet_scene : PackedScene
@export var bullet_spawn_location : Node3D
@export var projectile_count : int = 1
@export var bullet_cost : int = 1
@export var fire_rate : float = 1.0

var _is_shooting : bool
@export var is_shooting : bool :
	get: return _is_shooting
	set(value):
		if _is_shooting == value: return
		_is_shooting = value

# func _physics_process(delta: float) -> void:


func fire(ammo: Ammo) -> void:
	health -= 1
	ammo.consume_bullets(bullet_cost)
	for i in projectile_count:
		create_bullet(ammo.get_parent())


func create_bullet(shooter: Node3D) -> void:
	var projectile : Bullet = bullet_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_rotation = bullet_spawn_location.global_rotation
	projectile.global_position = bullet_spawn_location.global_position + projectile.basis.z * 1.5
	projectile.populate(shooter)