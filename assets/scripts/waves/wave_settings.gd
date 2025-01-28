
class_name WaveSettings extends Resource

@export var overall_difficulty_curve : Curve
@export var overall_difficulty_levels : float

@export var hour_difficulty_curve : Curve

func get_difficulty(index: int) -> float:
	var hour := index % Wave.HOURS_IN_DAY
	return overall_difficulty_curve.sample(float(index) / overall_difficulty_levels) * hour_difficulty_curve.sample(float(hour) / Wave.HOURS_IN_DAY)


@export var scene_chance_weights : Dictionary
@export var scene_costs : Dictionary


