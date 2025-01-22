
extends WeaponConfig


@onready var cooldown : Timer = $cooldown


func _ready() -> void:
	super._ready()


func _set_is_shooting(value: bool) -> void:
	if not cooldown.is_stopped() or not value: return

	fire_volley()


func fire_volley() -> void:
	for weapon in visible_weapons:
		weapon.fire(ammo)

