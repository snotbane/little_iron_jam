extends Node3D

@export var source : Node3D
@export var camera : Camera3D
@export var mouse_plane : Plane
@export var mesh : Node3D

var mouse_position : Vector2
var _is_using_mouse : bool = true
var is_using_mouse : bool = true :
	get: return _is_using_mouse
	set(value):
		if _is_using_mouse == value: return
		_is_using_mouse = value

		mesh.visible = _is_using_mouse

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_using_mouse: return

	self.global_position = mouse_plane.intersects_ray(camera.project_ray_origin(mouse_position), camera.project_ray_normal(mouse_position))

	mesh.look_at((source.global_position - self.global_position) * (Vector3.ONE - Vector3.UP))


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		is_using_mouse = false
	if event is InputEventMouseMotion:
		is_using_mouse = true
		mouse_position = event.position
