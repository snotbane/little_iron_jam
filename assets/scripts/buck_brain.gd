
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


var _is_volatile : bool
@export var is_volatile : bool :
	get: return _is_volatile
	set(value):
		if _is_volatile == value: return
		_is_volatile = value

		pawn.set_collision_layer_value(3, _is_volatile)