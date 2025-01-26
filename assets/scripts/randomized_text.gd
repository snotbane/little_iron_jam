
extends Node

@export var texts : PackedStringArray


func randomize_text() -> void:
	self.text = texts[randi_range(0, texts.size() - 1)]
