
class_name Wave extends Resource

@export var scenes : Dictionary
@export var crates : int
@export var duration : float = 5.0


static func new_from_wave_index(index : int) -> Wave:
	return Wave.new()
