
extends WeaponConfig

func _set_is_shooting(value: bool) -> void:
	for weapon in visible_weapons:
		weapon.is_shooting = value
		weapon.fire(ammo, fire_direction)
		await get_tree().create_timer(randf_range(0.12, 0.2)).timeout