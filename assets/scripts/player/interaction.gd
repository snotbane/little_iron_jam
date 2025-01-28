
extends Node

@onready var ammo : Ammo = self.get_parent()


var focused_pickup : Pickup


func _ready() -> void:
	ammo.body_entered.connect(body_entered)
	ammo.body_exited.connect(body_exited)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		try_collect()


func body_entered(body: Node3D) -> void:
	if not (body is Pickup and body.discreet_pickup): return
	focused_pickup = body


func body_exited(body: Node3D) -> void:
	if not body == focused_pickup: return
	focused_pickup = null


func try_collect() -> void:
	if not focused_pickup: return
	focused_pickup._collect(ammo)
	focused_pickup.queue_free()
	focused_pickup = null
