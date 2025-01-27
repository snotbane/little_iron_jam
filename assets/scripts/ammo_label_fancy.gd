
extends AmmoLabel

@export var scale_up_per_bullet : float
@export var scale_down_alpha : float
@export var scale_max : float = 2.0


func _process(delta: float) -> void:
	self.scale = lerp(self.scale, Vector2.ONE, scale_down_alpha * delta)
	if self.scale.x > scale_max:	self.scale = Vector2.ONE * scale_max


func _on_ammo_changed() -> void:
	var difference := absi(ammo.health - count)
	print(difference)
	self.scale += Vector2.ONE * difference * scale_up_per_bullet
	super._on_ammo_changed()