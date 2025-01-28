
extends Weapon

@export var min_fire_delay := 0.025
@export var max_fire_delay := 0.8
@export var fire_delay_alpha := 10.0

@export var rotator_visual_speed := 1.0
@export var rotator_main : Node3D
@export var rotator_sub : Node3D

var fire_rate := max_fire_delay
var bullet_timer := fire_rate
var fire_rate_percent : float :
	get: return remap(fire_rate, max_fire_delay, min_fire_delay, 0.0, 1.0)

var ammo_ : Ammo
var direction_ : Vector3

func _process(delta: float) -> void:
	fire_rate = lerpf(fire_rate, min_fire_delay if is_shooting else max_fire_delay, fire_delay_alpha * delta)
	cooldown.stop()
	var visual_rotation_degrees_y = rotator_visual_speed * fire_rate_percent * delta
	rotator_main.rotation_degrees.y += visual_rotation_degrees_y
	rotator_sub.rotation_degrees.y -= visual_rotation_degrees_y

	bullet_timer -= delta
	if is_shooting and ammo_ and bullet_timer <= 0.0:
		super.fire(ammo_, direction_, lerp(0.6, 1.1, fire_rate_percent * fire_rate_percent))
		bullet_timer = wrapf(bullet_timer, 0.0, fire_rate)


func fire(ammo: Ammo, direction := Vector3.ZERO, pitch := 1.0) -> void:
	ammo_ = ammo
	direction_ = direction
	bullet_timer = 0