
class_name Autoload extends Node

static var inst : Autoload

var loaded_resources : Array

var _is_fullscreen_exclusive : bool = true
var is_fullscreen_exclusive : bool = true :
	get: return _is_fullscreen_exclusive
	set(value):
		_is_fullscreen_exclusive = value
		self.is_fullscreen = self.is_fullscreen


var fullscreen_mode : Window.Mode :
	get:
		if is_fullscreen_exclusive:
			return Window.MODE_EXCLUSIVE_FULLSCREEN
		else:
			return Window.MODE_FULLSCREEN


var is_fullscreen : bool :
	get: return get_window().mode == Window.MODE_FULLSCREEN or get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN
	set(value):
		if value:
			get_window().mode = self.fullscreen_mode
		else:
			get_window().mode = Window.MODE_WINDOWED


static var hidden_mouse_mode : Input.MouseMode :
	get: return Input.MOUSE_MODE_HIDDEN if OS.has_feature("web") else Input.MOUSE_MODE_CONFINED_HIDDEN


func _ready() -> void:
	inst = self
	if not OS.is_debug_build(): self.is_fullscreen = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		self.is_fullscreen = not self.is_fullscreen
	# if event.is_action_pressed("menu"):
	# 	if Input.mouse_mode == Input.Autoload.hidden_mouse_mode:
	# 		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# 	elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
	# 		Input.mouse_mode = Input.Autoload.hidden_mouse_mode
