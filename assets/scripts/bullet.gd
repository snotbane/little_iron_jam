
class_name Bullet extends StaticBody3D

@export var impulse := 1.0
@export var falloff := 1.0
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

		self.look_at(global_position - _velocity)

@onready var collider : CollisionShape3D = $shape


func populate(_shooter: Node3D) -> void:
	shooter = _shooter
	velocity = self.global_basis.z * impulse
	await get_tree().create_timer(falloff).timeout
	rest()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var collision := self.move_and_collide(velocity * delta)

	if collision and collision.get_collision_count() > 0:
		var ammo : Ammo = collision.get_collider().find_child("ammo")
		if ammo: 	damage(ammo)
		else:		bounce(collision.get_normal())


func rest() -> void:
	queue_free()


func bounce(normal: Vector3) -> void:
	velocity = velocity.bounce(normal)
	# health -= 1


func damage(other: Ammo) -> void:
	other.count -= 1
	health -= 1
