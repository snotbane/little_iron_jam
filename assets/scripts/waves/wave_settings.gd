
class_name WaveSettings extends Resource

static var RANDOM := RandomNumberGenerator.new()

@export var objects : Array[EnemyWaveSettings]

@export var overall_difficulty_curve : Curve
@export var overall_difficulty_levels : float

@export var hour_difficulty_curve : Curve
@export var wave_duration_interval : float = 15.0

var object_weights : Array


func get_difficulty(index: int) -> float:
	return overall_difficulty_curve.sample(float(index) / overall_difficulty_levels) * hour_difficulty_curve.sample(float(index % Wave.HOURS_IN_DAY) / Wave.HOURS_IN_DAY)


func generate_wave(index: int) -> Wave:
	var result := Wave.new()
	result.difficulty = get_difficulty(index)
	object_weights = objects.map(func(i): return i.appearance_weight)

	var difficulty := result.difficulty
	while difficulty > 0.0:
		var chosen_object := objects[RANDOM.rand_weighted(object_weights)]
		if index < chosen_object.appearance_minimum_wave: continue
		difficulty -= chosen_object.difficulty_cost
		result.duration += chosen_object.difficulty_time

		if result.scenes.has(chosen_object.scene_path):
			result.scenes[chosen_object.scene_path] += 1
		else:
			result.scenes[chosen_object.scene_path] = 1

	result.duration = ceilf(result.duration / wave_duration_interval) * wave_duration_interval
	return result

