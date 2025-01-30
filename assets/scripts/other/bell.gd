
class_name Bell extends AnimatableBody3D

signal bell_rang


const AUDIO_POPUP := preload("res://assets/audio/bell_popup.ogg")
const AUDIO_RING := preload("res://assets/audio/bell_ring.ogg")
const AUDIO_SLOW := preload("res://assets/audio/bell_ring_slow.ogg")


@export var anim_player : AnimationPlayer
@onready var audio_player := $audio_stream_player_3d


var _is_enabled : bool
var is_enabled : bool :
	get: return _is_enabled
	set(value):
		_is_enabled = value

		anim_player.stop()
		anim_player.play(&"popup" if _is_enabled else &"ring")
		audio_player.stream = AUDIO_POPUP if _is_enabled else (AUDIO_SLOW if WaveController.inst.timer.is_stopped() and not Wave.wave_stops_time(WaveController.inst.wave_hour) else AUDIO_RING)
		audio_player.play()

		if _is_enabled: await get_tree().create_timer(1.0).timeout
		self.set_collision_layer_value(2, _is_enabled)


func _ready() -> void:
	anim_player.play(&"ring", -1, 1, true)


func on_hit(body: Node3D) -> void:
	if is_enabled:
		is_enabled = false
		bell_rang.emit()


func try_ring_bell() -> bool:
	is_enabled = false
	if is_enabled:
		bell_rang.emit()
		return true
	return false
