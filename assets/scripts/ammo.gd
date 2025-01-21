
class_name Ammo extends Area3D

signal changed
signal died

@export var shell_scene : PackedScene
@export var shell_loss_amount := 10
@export var shell_loss_linear_impulse := Vector2.ONE
@export var shell_loss_angular_impulse := 1.0

@onready var actor : Node3D = self.get_parent()

var _count : int = 10
@export var count : int = 10 :
	get: return _count
	set(value):
		value = max(value, 0)
		if _count == value: return
		if value < _count: _on_lost_ammo(_count - value)

		_count = value

		changed.emit()

		if _count == 0:
			died.emit()
			actor.queue_free()


func _ready() -> void:
	body_entered.connect(_body_entered)
	tree_exiting.connect(drop_shells)


func _on_lost_ammo(amount: int) -> void:
	pass
	# for i in amount:
	# 	create_shell()


func _body_entered(body: Node3D) -> void:
	if body == actor or (body is Bullet and body.shooter == actor): return
	take_damage(body)


func take_damage(body: Node3D) -> void:
	count -= body.damage
	if body is Bullet:
		body.health -= 1


func drop_shells() -> void:
	for i in shell_loss_amount:
		create_shell()


func create_shell() -> void:
	var result : RigidBody3D = shell_scene.instantiate()
	get_tree().root.add_child(result)
	result.global_position = actor.global_position
	var lateral_impulse := Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shell_loss_linear_impulse.x
	var impulse := Vector3(lateral_impulse.x, shell_loss_linear_impulse.y, lateral_impulse.y)
	var torque := Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)) * shell_loss_angular_impulse
	result.apply_torque_impulse(torque * result.mass)
	result.apply_impulse(impulse * result.mass)
	# return result
