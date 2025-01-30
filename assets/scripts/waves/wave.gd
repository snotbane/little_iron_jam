
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
	WESLEY = 27,
	MAGNUS = 45,
}

const HOURS_IN_DAY := 12
const UPGRADE_FREQUENCY := 3
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
	if hour > 0 and hour % UPGRADE_FREQUENCY == 0:
		result.scenes["res://assets/scenes/detritus/upgrade_crate.tscn"] = 1


	print("Wave difficulty: ", result.difficulty)
	print("Wave scenes: ", result.scenes)
	return result

static func wave_stops_time(idx: int, offset := 0) -> bool:
	return idx - offset == Hour.MIDNIGHT or idx - offset == Hour.HIGH_NOON

static func wave_uses_victory_music(idx: int) -> bool:
	var hour := idx % HOURS_IN_DAY
	return idx > Hour.HIGH_NOON and (hour > Hour.HIGH_NOON or hour < Hour.MIDNIGHT)