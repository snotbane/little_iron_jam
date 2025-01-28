extends Node3D

@export var casing_scene : PackedScene = preload("res://assets/scenes/detritus/detritus_casing.tscn")
@export var count := 1


func spawn() -> void:
	for i in count:	spawn_single()


func spawn_single() -> void:
	var casing : Detritus = casing_scene.instantiate()
	get_tree().root.add_child(casing)
	casing.global_position = self.global_position
	casing.global_rotation = self.global_rotation
