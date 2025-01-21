extends Node3D

@export var pawn : Node3D
@export var camera : Camera3D
@export var vacuum : Vacuum
@export var ammo : Ammo

@export var aim_distance : float = 2.0
@export var aim_visual_alpha : float = 10.0


@export var bullet_scene : PackedScene

var aim_vector : Vector2
var aim_position : Vector3

var mouse_position : Vector2
var _is_using_mouse : bool = true
var is_using_mouse : bool = true :
	get: return _is_using_mouse
	set(value):
		if _is_using_mouse == value: return
		_is_using_mouse = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_using_mouse:
		self.global_position = Plane.PLANE_XZ.intersects_ray(camera.project_ray_origin(mouse_position), camera.project_ray_normal(mouse_position))
		aim_position = self.position * (Vector3.ONE - Vector3.UP)
		aim_vector = Vector2(aim_position.x, aim_position.z)
	else:
		aim_vector = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down").normalized()
		if aim_vector:
			aim_position = Vector3(aim_vector.x * aim_distance, 0, aim_vector.y * aim_distance)
		self.position = lerp(self.position, aim_position, aim_visual_alpha * delta)
	self.global_position.y = 0
	self.look_at(((self.global_position - self.position) * (Vector3.ONE - Vector3.UP)))


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		is_using_mouse = false
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CONFINED_HIDDEN:
		is_using_mouse = true
		mouse_position = event.position

	if not pawn: return

	if event.is_action_pressed("shoot"):
		shoot()

	if event.is_action_pressed("vacuum"):
		vacuum.is_sucking = true
	elif event.is_action_released("vacuum"):
		vacuum.is_sucking = false



func shoot() -> void:
	ammo.count -= 1
	var projectile : Bullet = bullet_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_rotation = self.global_rotation
	projectile.global_position = pawn.global_position + projectile.basis.z * 1.5
	projectile.populate(pawn)
