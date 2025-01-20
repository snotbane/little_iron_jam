
class_name Vacuum extends Area3D

@onready var region : Camera3D = $region

@export var suck_angle := 30.0
@export var suck_power := 1.0

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
			try_collect(prospects.pop_front())


func _body_entered(body: Node3D) -> void:
	try_collect(body)


func _body_exited(body: Node3D) -> void:
	prospects.erase(body)


func try_collect(body: RigidBody3D) -> void:
	print(body)
	if is_sucking and not body.find_child("safe"):
		collect(body)
	else:
		fail_collect(body)


func collect(body: RigidBody3D) -> void:
	body.queue_free()


func fail_collect(body: RigidBody3D) -> void:
	prospects.push_back(body)

