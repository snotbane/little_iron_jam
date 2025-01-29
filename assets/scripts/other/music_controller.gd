
extends AudioStreamPlayer

@onready var song : AudioStreamInteractive = self.stream


func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	play_high_noon()


func play_standard() -> void:
	self["parameters/switch_to_clip"] = &"standard"
func play_high_noon() -> void:
	self["parameters/switch_to_clip"] = &"high_noon"
func play_dead_of_night() -> void:
	self["parameters/switch_to_clip"] = &"dead_of_night"


