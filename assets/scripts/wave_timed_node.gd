
@tool
class_name WaveTimedNode extends Node

@export var wave_values : Array

var _current_hour : int = 0
@export var current_hour : int = 0 :
	get: return _current_hour
	set(value):
		value = wrapi(value, 0, wave_values.size())
		if _current_hour == value: return
		_current_hour = value

		_set_current_hour(_current_hour)

var current_value : Variant :
	get: return wave_values[current_hour]


func _ready() -> void:
	_set_current_hour(0)


func set_current_hour(value: int) -> void:
	current_hour = value
func _set_current_hour(value: int) -> void: pass