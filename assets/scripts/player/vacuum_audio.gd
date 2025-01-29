
extends AudioStreamPlayer3D


func set_is_sucking(value: bool) -> void:
	# clip_index = 0 if value else 2

	if value:
		self["parameters/looping"] = true
		self.stream = preload("res://assets/audio/vacuum/vacuum_start.ogg")
		self.play()
	else:
		self["parameters/looping"] = false
		self.stop()
		self.stream = preload("res://assets/audio/vacuum/vacuum_end.ogg")
		self.play()

