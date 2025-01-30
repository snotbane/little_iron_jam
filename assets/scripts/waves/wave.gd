
class_name Wave extends Resource

enum Hour {
	SUNSET,
	EVENING,
	NIGHT,
	MIDNIGHT,
	EARLY_AM,
	DAWN,
	SUNRISE,
	MORNING,
	BRUNCH,
	HIGH_NOON,
	SIESTA,
	AFTERNOON,
}

enum Events {
	BUCK = 9,
	WESLEY = 15,
	MAGNUS = 21,
}

const HOURS_IN_DAY := 12
const SETTINGS := preload("res://assets/data/wave_settings_default.tres")

@export var scenes : Dictionary
@export var crates : int
@export var duration : float = 0.0
@export var difficulty : float = 0.0

static func new_from_wave_index(index : int) -> Wave:
	var result : Wave
	var hour := index % HOURS_IN_DAY
	if hour == Hour.MIDNIGHT:
		result = Wave.new()
		result.scenes["res://assets/scenes/pickups/shell.tscn"] = 3
	else:
		result = SETTINGS.generate_wave(index)

	print("Wave difficulty: ", result.difficulty)
	print("Wave scenes: ", result.scenes)
	return result

static func wave_stops_time(idx: int, offset := 0) -> bool:
	return idx - offset == Hour.MIDNIGHT or idx - offset == Hour.HIGH_NOON
