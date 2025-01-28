
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

const HOURS_IN_DAY := 12
const SETTINGS := preload("res://assets/data/wave_settings_default.tres")


static var RANDOM := RandomNumberGenerator.new()


@export var scenes : Dictionary
@export var crates : int
@export var duration : float = 30.0


static func new_from_wave_index(index : int) -> Wave:
	var result := Wave.new()
	var hour := index % HOURS_IN_DAY

	if hour == Hour.MIDNIGHT:
		result.duration = 0.0
		result.scenes["res://assets/scenes/pickups/shell.tscn"] = 10
		return result


	var difficulty := SETTINGS.get_difficulty(index)
	print("Wave difficulty: ", difficulty)


	while difficulty > 0.0:
		var i := RANDOM.rand_weighted(SETTINGS.scene_chance_weights.values())
		var scene_path : String = SETTINGS.scene_chance_weights.keys()[i]
		difficulty -= SETTINGS.scene_costs[scene_path]

		if result.scenes.has(scene_path):
			result.scenes[scene_path] += 1
		else:
			result.scenes[scene_path] = 1

	return result
