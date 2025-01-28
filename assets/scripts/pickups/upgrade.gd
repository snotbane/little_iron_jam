
class_name Upgrade extends Resource

@export var mesh_material : Material
@export var sprite : Texture2D
@export var signal_name : StringName

func activate(node: Node) -> void:
	node.emit_signal(signal_name)
