
class_name Ammo extends Area3D

const SCREAM_AUDIO : AudioStream = preload("res://assets/audio/scream.tres")
const ENEMY_DAMAGE_AUDIO : AudioStream = preload("res://assets/audio/damage_enemy.tres")
const PLAYER_DAMAGE_AUDIO : AudioStream = preload("res://assets/audio/damage_player.tres")

signal changed
signal died

signal received_upgrade_any
signal received_upgrade_dodge
signal received_upgrade_vacuum
signal received_upgrade_bullet_speed
signal received_upgrade_bullet_damage


@export var shell_scene : PackedScene
@export var shell_loss_amount := 10
@export var shell_loss_linear_impulse := Vector2.ONE
@export var shell_loss_angular_impulse := 1.0

@export var invincible := false
@export var belongs_to_player := false
@export var can_scream := true
@export var extra_ammo_cost := 0
@export var bullet_speed_multiplier := 1.0
@export var upgrade_bullet_speed_multiplier := 0.2

@export var weapon_drop_on_death : PackedScene

@onready var actor : Node3D = self.get_parent()

var last_hit_by : Node3D

var _health : int = 1
@export var health : int = 1 :
	get: return _health
	set(value):
		value = max(value, -1) if _health == 0 else max(value, 0)

		if _health == value: return

		_health = max(_health, value) if invincible else value
		changed.emit()

		if _health < 0 if belongs_to_player else health <= 0:
			die()


func _ready() -> void:
	body_entered.connect(_body_entered)
	received_upgrade_bullet_speed.connect(_received_upgrade_bullet_speed)
	received_upgrade_bullet_damage.connect(_received_upgrade_bullet_damage)
	received_upgrade_bullet_speed.connect(received_upgrade_any.emit)
	received_upgrade_bullet_damage.connect(received_upgrade_any.emit)
	received_upgrade_dodge.connect(received_upgrade_any.emit)
	received_upgrade_vacuum.connect(received_upgrade_any.emit)


func _body_entered(body: Node3D) -> void:
	if body == actor or (body is Bullet and body.shooter == actor): return
	take_damage(body)


func take_damage(body: Node3D) -> void:
	if body is not CharacterBody3D and body is not Bullet: return

	last_hit_by = body
	health -= body.damage
	create_hitspark(body)
	if body is Bullet:
		body.health -= 1


func create_hitspark(bullet: Node3D) -> void:
	scream(PLAYER_DAMAGE_AUDIO if belongs_to_player else ENEMY_DAMAGE_AUDIO)
	var hitspark := preload("res://assets/scenes/hitspark.tscn").instantiate()
	get_tree().root.add_child(hitspark)
	hitspark.global_position = bullet.global_position + bullet.global_basis.z * (1.5 if bullet is Bullet else 0.0)
	hitspark.look_at(hitspark.global_position + bullet.global_basis.z)


func consume_bullets(amount: int) -> void:
	if belongs_to_player: self.health -= amount + extra_ammo_cost

var dead := false
func die() -> void:
	if dead: return
	dead = true
	# if last_hit_by is not Bullet:
		# drop_weapon()
	drop_weapon()
	drop_shells()
	if can_scream: scream(SCREAM_AUDIO)
	died.emit()
	actor.queue_free.call_deferred()


func scream(stream: AudioStream, volume := 2.0) -> void:
	var audio := AudioStreamPlayer3D.new()
	audio.stream = stream
	audio.volume_db = volume
	get_tree().root.add_child(audio)
	audio.global_position = self.global_position
	audio.play()

	var timeout := Timer.new()
	timeout.timeout.connect(audio.queue_free)
	timeout.wait_time = 3.0
	timeout.autostart = true
	audio.add_child(timeout)



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


func _received_upgrade_bullet_speed() -> void:
	bullet_speed_multiplier += upgrade_bullet_speed_multiplier


func _received_upgrade_bullet_damage() -> void:
	extra_ammo_cost += 1
