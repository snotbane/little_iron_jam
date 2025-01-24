
class_name WeaponConfig extends Node3D

@export var weapon_scene : PackedScene
@export var ammo : Ammo

var sockets : Array[Node3D]
var max_sockets : int :
	get: return sockets.size()
var visible_weapons : Array[Weapon] :
	get:
		var result : Array[Weapon]
		for socket in sockets:
			if socket.get_child_count() == 0: continue
			var weapon_ := socket.get_child(0)
			if weapon_ is Weapon:
				result.push_back(weapon_)
		return result

var available_socket : Node3D :
	get:
		for socket in sockets:
			if socket.get_child(0):	continue
			return socket
		return null


var _is_shooting : bool
var is_shooting : bool :
	get: return _is_shooting
	set(value):
		if _is_shooting == value: return
		_is_shooting = value
		_set_is_shooting(_is_shooting)


func _ready() -> void:
	for child in self.get_children():
		if child is Node3D:
			sockets.push_back(child)


func _set_is_shooting(value: bool) -> void:	pass


func try_add_weapon() -> bool:
	var socket := available_socket
	if socket:
		socket.add_child(weapon_scene.instantiate())
		return true
	return false
