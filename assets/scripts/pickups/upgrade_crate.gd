
@tool
extends Detritus


signal material_changed(surface: int, material: Material)

@export var upgrades : Array[Upgrade]
var upgrade : Upgrade :
	get: return upgrades[effect_index]

var _effect_index : int
@export_range(0, 3) var effect_index : int :
	get: return _effect_index
	set(value):
		# if _effect_index == value: return
		_effect_index = value

		material_changed.emit(0, upgrade.mesh_material)


func spawn_pickup() -> void:
	var node : Node3D = preload("res://assets/scenes/pickups/pickup_upgrade.tscn").instantiate()
	node.effect_index = self.effect_index
	get_tree().root.add_child(node)
	node.global_position = self.global_position

