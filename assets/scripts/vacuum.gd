
class_name Vacuum extends Area3D

@export var region : Camera3D
@export var suck_angle : float = 45.0 :
	get: return region.fov
	set(value):
		value = clamp(value, 0, 179)
		region.fov = value
@export var suck_distance : float = 3.0 :
	get: return region.far
	set(value):
		value = max(value, 0.001)
		region.far = value
		($shape.shape as CylinderShape3D).radius = value

@export var suck_power := 1.0
@export var collect_radius_squared := 1.0

var prospects : Array[RigidBody3D]

var _is_sucking : bool = false
@export var is_sucking : bool = false :
	get: return _is_sucking
	set(value):
		if _is_sucking == value: return
		_is_sucking = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)


func _physics_process(delta: float) -> void:
	if is_sucking:
		for i in prospects.size():
			var body : RigidBody3D = prospects.pop_front()

			if body.find_child("safe"): continue

			var difference := (self.global_position - body.global_position) * Vector3(1, 0, 1)
			if difference.length_squared() < collect_radius_squared:
				collect(body); continue
			elif region.is_position_in_frustum(body.global_position * Vector3(1, 0, 1)):
				body.apply_force(difference.normalized() * suck_power)
			fail_collect(body)


func _body_entered(body: Node3D) -> void:
	prospects.push_back(body)


func _body_exited(body: Node3D) -> void:
	prospects.erase(body)


func collect(body: RigidBody3D) -> void:
	body.queue_free()


func fail_collect(body: RigidBody3D) -> void:
	prospects.push_back(body)

