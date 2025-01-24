
extends WeaponConfig


@onready var cooldown : Timer = $cooldown


func _ready() -> void:
	super._ready()


func _set_is_shooting(value: bool) -> void:
	if not value or not cooldown.is_stopped(): return

	fire_volley()


func fire_volley() -> void:
	for weapon in visible_weapons:
		await get_tree().create_timer(randf_range(0.02, 0.05)).timeout
		weapon.fire(ammo)

