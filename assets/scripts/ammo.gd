
class_name Ammo extends Node

signal changed
signal died

@export var shell_scene : PackedScene
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_lost_ammo(amount: int) -> void:
	for i in amount:
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
