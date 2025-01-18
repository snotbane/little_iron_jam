extends Area3D

@export var impulse := 1.0
@export var falloff := 1.0

var velocity : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func fire() -> void:
	velocity = self.global_basis.z * impulse
	await get_tree().create_timer(falloff).timeout
	land()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position += velocity * delta
	pass


func land() -> void:
	queue_free()
