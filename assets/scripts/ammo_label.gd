
extends Node

signal changed

@export var ammo : Ammo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo.changed.connect(_on_ammo_changed)
	_on_ammo_changed()


func _on_ammo_changed() -> void:
	self.text = str(max(ammo.health, 0))
	changed.emit()
