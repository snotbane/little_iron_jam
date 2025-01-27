
class_name AmmoLabel extends Node

signal changed

@export var ammo : Ammo
var count : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo.changed.connect(_on_ammo_changed)
	_on_ammo_changed()


func _on_ammo_changed() -> void:
	count = maxi(ammo.health, 0)
	self.text = str(count)
	changed.emit()
