
class_name Wave extends Resource

@export var scenes : Dictionary
@export var crates : int
@export var duration : float


static func new_from_wave_index(index : int) -> Wave:
	return Wave.new()
