
extends Pickup

func _collect(ammo: Ammo) -> void:
	ammo.health += 1
