
extends Node3D

signal angle_changed(value: Vector3)
signal shoot_start

@export var weapon_config_socket : Node3D
@export var weapon_config : WeaponConfig

@export var pawn : Node3D
@export var camera : Camera3D
@export var vacuum : Vacuum
@export var ammo : Ammo

@export var aim_distance : float = 2.0
@export var aim_visual_alpha : float = 10.0

var _aim_vector : Vector2
var aim_vector : Vector2 :
	get: return _aim_vector
	set(value):
		angle_changed.emit(Vector3(value.x, 0, value.y))
		if _aim_vector == value: return
		_aim_vector = value


var aim_position : Vector3

var is_using_face_buttons_to_shoot : bool
var mouse_position : Vector2
var _is_using_mouse : bool = true
var is_using_mouse : bool = true :
	get: return _is_using_mouse
	set(value):
		if _is_using_mouse == value: return
		_is_using_mouse = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


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
		elif is_using_face_buttons_to_shoot:
			aim_position = -pawn.global_basis.z * Vector3(1, 0, 1) * aim_distance
		self.position = lerp(self.position, aim_position, aim_visual_alpha * delta)
	self.global_position.y = 0
	if self.position:
		self.look_at(((self.global_position - self.position) * (Vector3.ONE - Vector3.UP)))


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		is_using_mouse = false
		if Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down"):
			is_using_face_buttons_to_shoot = false
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		is_using_mouse = true
		mouse_position = event.position

	if not pawn: return

	if weapon_config:
		if event.is_action_pressed("shoot_enforce_gamepad"):
			aim_position = -pawn.global_basis.z * Vector3(1, 0, 1) * aim_distance
			angle_changed.emit(aim_position)
			weapon_config.is_shooting = true
			shoot_start.emit()
			is_using_face_buttons_to_shoot = true
		elif event.is_action_released("shoot_enforce_gamepad"):
			weapon_config.is_shooting = false

		if event.is_action_pressed("shoot"):
			weapon_config.is_shooting = true
			shoot_start.emit()
		elif event.is_action_released("shoot"):
			weapon_config.is_shooting = false

	if event.is_action_pressed("vacuum"):
		vacuum.is_sucking = true
	elif event.is_action_released("vacuum"):
		vacuum.is_sucking = false


func _on_received_weapon_config(_weapon_config: WeaponConfig) -> void:
	if weapon_config and weapon_config.weapon_scene == _weapon_config.weapon_scene:
		_weapon_config.queue_free()
	else:
		if weapon_config:
			weapon_config.drop_weapon_pickups()
			weapon_config.queue_free()
		weapon_config = _weapon_config
		weapon_config.ammo = self.ammo
		weapon_config_socket.add_child(weapon_config)
	weapon_config.try_add_weapon()