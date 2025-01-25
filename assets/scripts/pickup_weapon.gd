
extends Pickup

@export var weapon_config_scene : PackedScene

@onready var visual : Node3D = $visual


func _ready() -> void:
	super._ready()
	tree_exiting.connect(visual.queue_free)
	detach_visual.call_deferred()


func detach_visual() -> void:
	var gt := visual.global_transform
	self.remove_child(visual)
	get_tree().root.add_child(visual)
	visual.global_transform = gt


func _collect(ammo: Ammo) -> void:
	if not ammo.actor.has_signal("received_weapon_config"): return
	var weapon_config : WeaponConfig = weapon_config_scene.instantiate()
	ammo.actor.received_weapon_config.emit(weapon_config)
