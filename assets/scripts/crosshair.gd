extends Node3D

@export var source : Node3D
@export var camera : Camera3D
@export var mouse_plane : Plane
@export var mesh : Node3D

@export var aim_distance : float = 2.0
@export var aim_visual_alpha : float = 10.0

var aim_vector : Vector2
var aim_position : Vector3

var mouse_position : Vector2
var _is_using_mouse : bool = true
var is_using_mouse : bool = true :
	get: return _is_using_mouse
	set(value):
		if _is_using_mouse == value: return
		_is_using_mouse = value

		if _is_using_mouse:
			mesh.visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_using_mouse:
		self.global_position = mouse_plane.intersects_ray(camera.project_ray_origin(mouse_position), camera.project_ray_normal(mouse_position))
		aim_position = self.position * (Vector3.ONE - Vector3.UP)
		aim_vector = Vector2(aim_position.x, aim_position.z)
	else:
		aim_vector = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down").normalized()
		# mesh.visible = aim_vector != Vector2.ZERO
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
