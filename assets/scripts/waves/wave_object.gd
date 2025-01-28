
class_name WaveObject extends Resource

@export var scene_path := ""
var scene : PackedScene :
	get: return load(scene_path)
@export var difficulty_cost := 1.0
@export var difficulty_time := 10.0
# @export var
