
extends Brain

var _is_slam_blip : bool
@export var is_slam_blip : bool :
	get: return _is_slam_blip
	set(value):
		if _is_slam_blip == value: return
		_is_slam_blip = value

		if _is_slam_blip and get_tree():
			await get_tree().create_timer(0.1).timeout
			_is_slam_blip = false
