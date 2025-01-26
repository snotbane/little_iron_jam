
class_name Wave extends Resource

enum Hour {
	AFTERNOON,
	SUNSET,
	NIGHT,
	MIDNIGHT,
	EARLY_AM,
	SUNRISE,
	MORNING,
	NOON
}

const HOUR_COUNT := 8
const SETTINGS := preload("res://assets/data/wave_settings_default.tres")


static var RANDOM := RandomNumberGenerator.new()


@export var scenes : Dictionary
@export var crates : int
@export var duration : float = 5.0


static func new_from_wave_index(index : int) -> Wave:
	var result := Wave.new()
	var time_of_day := index % 8

	if time_of_day == Hour.MIDNIGHT:
		result.duration = 30.0
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

	print(result.scenes)

	return result
