
extends WeaponConfig

@export var socket_fire_order : Array[int]

var _fire_index : int
var fire_index : int :
	get: return _fire_index
	set(value):
		value = wrapi(value, 0, max_sockets)
		if _fire_index == value: return
		_fire_index = value


var fire_index_ordered : int :
	get: return socket_fire_order[_fire_index]


func _ready() -> void:
	super._ready()
	cooldown.timeout.connect(fire_single)


func _physics_process(delta: float) -> void:
	pass


func _set_is_shooting(value: bool) -> void:
	if value:
		for i in max_sockets:
			if sockets[fire_index_ordered].get_child_count() != 0: break
			fire_index += 1
		fire_single()
	super._set_is_shooting(value)


func fire_single() -> void:
	if not is_shooting: return
	if sockets[fire_index_ordered].get_child_count() != 0:
		var weapon : Weapon = sockets[fire_index_ordered].get_child(0)
		weapon.fire(ammo, fire_direction)
	fire_index += 1