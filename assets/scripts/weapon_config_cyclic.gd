
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


var available_fire_index : int :
	get:
		var start := fire_index
		var i = wrapi(fire_index + 1, 0, max_sockets)
		while i != start:
			if sockets[i].get_child_count() != 0:
				break
			i = wrapi(i + 1, 0, max_sockets)
		return i


func _ready() -> void:
	super._ready()
	$timer.timeout.connect(fire_single)


func _physics_process(delta: float) -> void:
	pass


func _set_is_shooting(value: bool) -> void:
	if value:
		if $timer.is_stopped():
			fire_index = available_fire_index
			fire_single()
			$timer.start()
	# else:
	# 	$timer.stop()


func fire_single() -> void:
	if not is_shooting: return
	if sockets[fire_index_ordered].get_child_count() != 0:
		var weapon : Weapon = sockets[fire_index_ordered].get_child(0)
		weapon.fire(ammo, fire_direction)
	fire_index += 1