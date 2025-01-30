
@tool
extends Detritus


const MAX_UPGRADES_AVAILABLE := 3 - 1


signal material_changed(surface: int, material: Material)

@export var upgrades : Array[Upgrade]
var upgrade : Upgrade :
	get: return upgrades[effect_index]

var _effect_index : int
@export_range(0, MAX_UPGRADES_AVAILABLE) var effect_index : int :
	get: return _effect_index
	set(value):
		# if _effect_index == value: return
		_effect_index = value

		material_changed.emit(0, upgrade.mesh_material)

@export var randomize_index := true

func _ready() -> void:
	if not Engine.is_editor_hint() and  randomize_index:
		effect_index = randi_range(0, MAX_UPGRADES_AVAILABLE)


func spawn_pickup() -> void:
	var node : Node3D = preload("res://assets/scenes/pickups/pickup_upgrade.tscn").instantiate()
	node.effect_index = self.effect_index
	get_tree().root.add_child(node)
	node.global_position = self.find_child("shape").global_position

