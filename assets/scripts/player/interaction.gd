
extends Node

signal on_collected

@onready var ammo : Ammo = self.get_parent()


var pickup_stack : Array[Pickup]
var focused_pickup : Pickup :
	get: return pickup_stack.back() if pickup_stack else null


func _ready() -> void:
	ammo.body_entered.connect(body_entered)
	ammo.body_exited.connect(body_exited)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		try_collect()


func body_entered(body: Node3D) -> void:
	if not (body is PickupWeapon): return
	pickup_stack.push_back(body)


func body_exited(body: Node3D) -> void:
	if body is not Pickup: return
	pickup_stack.erase(body)


func try_collect() -> void:
	if not focused_pickup: return
	focused_pickup._collect(ammo)
	focused_pickup.queue_free()
	pickup_stack.pop_back()
	on_collected.emit()
