
class_name Ammo extends Area3D

signal changed
signal died

@export var shell_scene : PackedScene
@export var shell_loss_amount := 10
@export var shell_loss_linear_impulse := Vector2.ONE
@export var shell_loss_angular_impulse := 1.0

@export var lose_health_on_consume := false

@export var weapon_drop_on_death : PackedScene

@onready var actor : Node3D = self.get_parent()

var _health : int = 10
@export var health : int = 10 :
	get: return _health
	set(value):
		value = max(value, 0)
		if _health == value: return
		if value < _health: _on_lost_ammo(_health - value)

		_health = value

		changed.emit()

		if _health == 0:
			die()


func _ready() -> void:
	body_entered.connect(_body_entered)


func _on_lost_ammo(amount: int) -> void:
	pass
	# for i in amount:
	# 	create_shell()


func _body_entered(body: Node3D) -> void:
	if body == actor or (body is Bullet and body.shooter == actor): return
	take_damage(body)


func take_damage(body: Node3D) -> void:
	health -= body.damage
	if body is Bullet:
		create_hitspark(body)
		body.health -= 1


func create_hitspark(bullet: Bullet) -> void:
	var hitspark := preload("res://assets/scenes/hitspark.tscn").instantiate()
	get_tree().root.add_child(hitspark)
	hitspark.global_position = bullet.global_position + bullet.global_basis.z * 1.5
	hitspark.look_at(hitspark.global_position + bullet.global_basis.z)


func consume_bullets(amount: int) -> void:
	if lose_health_on_consume: self.health -= amount


func die() -> void:
	drop_shells()
	drop_weapon()
	died.emit()
	actor.queue_free.call_deferred()


func drop_weapon() -> void:
	if not weapon_drop_on_death: return
	var result : RigidBody3D = weapon_drop_on_death.instantiate()
	get_tree().root.add_child(result)
	result.global_position = actor.global_position


func drop_shells() -> void:
	for i in shell_loss_amount:
		create_shell()


func create_shell() -> void:
	var result : RigidBody3D = shell_scene.instantiate()
	get_tree().root.add_child(result)
	result.global_position = actor.global_position
