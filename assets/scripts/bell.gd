
class_name Bell extends AnimatableBody3D

signal bell_rang


@export var anim_player : AnimationPlayer


var _is_enabled : bool
var is_enabled : bool :
	get: return _is_enabled
	set(value):
		if _is_enabled == value: return
		_is_enabled = value

		anim_player.stop()
		anim_player.play(&"popup" if _is_enabled else &"ring")


func _ready() -> void:
	anim_player.play(&"ring", -1, 1, true)


func on_hit(body: Node3D) -> void:
	if is_enabled:
		is_enabled = false
		bell_rang.emit()


func try_ring_bell() -> bool:
	if is_enabled:
		is_enabled = false
		bell_rang.emit()
		return true
	return false
