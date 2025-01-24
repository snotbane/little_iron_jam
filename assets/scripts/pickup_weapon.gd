
extends Pickup

@export var weapon_config_scene : PackedScene

func _collect(ammo: Ammo) -> void:
	if not ammo.actor.has_signal("received_weapon_config"): return
	var weapon_config : WeaponConfig = weapon_config_scene.instantiate()
	ammo.actor.received_weapon_config.emit(weapon_config)
