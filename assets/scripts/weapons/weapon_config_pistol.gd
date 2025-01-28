
extends WeaponConfig


func _ready() -> void:
	super._ready()
	cooldown.timeout.connect(fire_volley)


func _set_is_shooting(value: bool) -> void:
	if value:
		fire_volley()
	super._set_is_shooting(value)


func fire_volley() -> void:
	if not is_shooting: return
	for weapon in visible_weapons:
		await get_tree().create_timer(randf_range(0.02, 0.05)).timeout
		weapon.fire(ammo, fire_direction)

