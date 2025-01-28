
class_name Pickup extends Detritus


@export var discreet_pickup := false


func collect(ammo: Ammo) -> void:
	if discreet_pickup: return
	_collect(ammo)
func _collect(ammo: Ammo) -> void: pass
