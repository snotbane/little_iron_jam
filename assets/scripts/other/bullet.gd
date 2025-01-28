
class_name Bullet extends AnimatableBody3D

@export var damage := 1
@export var impulse := 1.0
@export var falloff := 1.0
@export var shooter_safety_delay := 0.15
var _health : int = 1
@export var health : int = 1 :
	get: return _health
	set(value):
		value = max(value, 0)
		if _health == value: return
		_health = value

		if _health == 0: rest()

var shooter : Node3D

var _velocity : Vector3
@export var velocity : Vector3 :
	get: return _velocity
	set(value):
		if _velocity == value: return
		_velocity = value

		if _velocity:
			self.look_at(global_position + _velocity)

@onready var collider : CollisionShape3D = $shape


func populate(_shooter: Node3D, audio : AudioStream = preload("res://assets/audio/pistol_fire.tres")) -> void:
	shooter = _shooter
	velocity = (-self.global_basis.z * Vector3(1, 0, 1)).normalized() * impulse

	var audio_player := AudioStreamPlayer3D.new()
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.stream = audio
	audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED
	get_tree().root.add_child(audio_player)
	audio_player.global_position = self.global_position
	audio_player.play()


func _ready() -> void:
	var timers := [
		# func() -> void:
		# 	await get_tree().create_timer(shooter_safety_delay).timeout
		# 	shooter = null
		# 	,
		func() -> void:
			await get_tree().create_timer(falloff - shooter_safety_delay).timeout
			rest()
			,
	]

	for i in timers:
		i.call()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var collision := self.move_and_collide(velocity * delta)
	if collision:
		bounce(collision.get_normal())


func rest() -> void:
	queue_free()


func bounce(normal: Vector3) -> void:
	velocity = velocity.bounce(normal)
	# health -= 1
