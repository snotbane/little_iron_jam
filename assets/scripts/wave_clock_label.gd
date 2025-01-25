
@tool
extends Label

# @export var text_prefix : String = "[center]"
@export var hour_names : PackedStringArray

var _current_hour : int = 0
@export var current_hour : int = 0 :
	get: return _current_hour
	set(value):
		value = wrapi(value, 0, hour_names.size())
		if _current_hour == value: return
		_current_hour = value

		self.text = hour_names[_current_hour]
		# self.text = text_prefix + hour_names[_current_hour]


func set_current_hour(value: int) -> void:
	current_hour = value
