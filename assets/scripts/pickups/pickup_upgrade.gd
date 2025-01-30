
@tool
extends Pickup

const MAX_UPGRADES_AVAILABLE := 3 - 1

signal texture_changed(texture: Texture2D)

@export var randomize_index := false

@export var upgrades : Array[Upgrade]
var upgrade : Upgrade :
	get: return upgrades[effect_index]

var _effect_index : int
@export_range(0, MAX_UPGRADES_AVAILABLE) var effect_index : int :
	get: return _effect_index
	set(value):
		# if _effect_index == value: return
		_effect_index = value

		texture_changed.emit(upgrade.sprite)

func _ready() -> void:
	if randomize_index:
		effect_index = randi_range(0, MAX_UPGRADES_AVAILABLE)


func _exit_tree() -> void:
	# AudioStream.one
	pass


func _collect(ammo: Ammo) -> void:
	upgrade.activate(ammo)
