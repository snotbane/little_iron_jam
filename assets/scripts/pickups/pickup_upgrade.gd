
@tool
extends Pickup

signal texture_changed(texture: Texture2D)

@export var upgrades : Array[Upgrade]
var upgrade : Upgrade :
	get: return upgrades[effect_index]

var _effect_index : int
@export_range(0, 3) var effect_index : int :
	get: return _effect_index
	set(value):
		# if _effect_index == value: return
		_effect_index = value

		texture_changed.emit(upgrade.sprite)


func _collect(ammo: Ammo) -> void:
	upgrade.activate(ammo)
