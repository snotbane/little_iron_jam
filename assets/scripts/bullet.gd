
class_name Bullet extends Area3D

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_body_entered)


func populate(_shooter: Node3D) -> void:
	shooter = _shooter
	velocity = self.global_basis.z * impulse
	await get_tree().create_timer(falloff).timeout
	rest()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position += velocity * delta
	pass


func rest() -> void:
	queue_free()


func _body_entered(body: Node3D) -> void:
	if body == shooter: return

	if body.has_method("receive_damage"):
		damage(body)
	else:
		bounce()



func bounce() -> void:

	var state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(global_position, global_position + global_basis.z)
	query.hit_from_inside = true
	query.hit_back_faces = true
	query.collide_with_bodies = true
	var result := state.intersect_ray(query)

	print(query.to)
	print(result)

	velocity = -velocity
	# health -= 1



func damage(body: Node3D) -> void:
	print("Damaged ", body)
	health -= 1
