
extends WeaponConfig


@onready var cooldown : Timer = $cooldown


func _ready() -> void:
	super._ready()


func _set_is_shooting(value: bool) -> void:
	if value:
		if not cooldown.is_stopped(): return
		fire_volley()
		cooldown.start()
	else:
		cooldown.stop()


func fire_volley() -> void:
	for weapon in visible_weapons:
		await get_tree().create_timer(randf_range(0.02, 0.05)).timeout
		weapon.fire(ammo, fire_direction)

