
extends Node

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


func _ready() -> void:
	if not OS.is_debug_build(): self.is_fullscreen = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		self.is_fullscreen = not self.is_fullscreen
	# if event.is_action_pressed("menu"):
	# 	if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
	# 		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# 	elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
	# 		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
